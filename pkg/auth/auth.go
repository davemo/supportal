package auth

import (
	"context"
	"fmt"
	"net/http"
	"golang.org/x/crypto/bcrypt"
	"supportal/pkg/db"
	"database/sql"
)

// Authenticate checks if the provided email/password combo is valid
func Authenticate(queries *db.Queries, email, password string) (db.User, error) {
	user, err := queries.GetUserByEmail(context.Background(), email)
	if err != nil {
		if err == sql.ErrNoRows {
			return db.User{}, fmt.Errorf("invalid email or password")
		}
		return db.User{}, fmt.Errorf("error fetching user: %v", err)
	}

	if !user.HashedPassword.Valid {
		return db.User{}, fmt.Errorf("user has no password set")
	}

	err = bcrypt.CompareHashAndPassword([]byte(user.HashedPassword.String), []byte(password))
	if err != nil {
		return db.User{}, fmt.Errorf("invalid email or password")
	}

	return user, nil
}

// RequireAuth is middleware that checks if a user is authenticated
func RequireAuth(queries *db.Queries, next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		cookie, err := r.Cookie("auth")
		if err != nil {
			http.Redirect(w, r, "/?error=unauthorized", http.StatusSeeOther)
			return
		}

		user, err := queries.GetUserByEmail(context.Background(), cookie.Value)
		if err != nil {
			http.Redirect(w, r, "/?error=unauthorized", http.StatusSeeOther)
			return
		}

		// Store user in context
		ctx := context.WithValue(r.Context(), "user", user)
		next.ServeHTTP(w, r.WithContext(ctx))
	}
}

// SetAuthCookie sets the authentication cookie for the given user
func SetAuthCookie(w http.ResponseWriter, user db.User) {
	http.SetCookie(w, &http.Cookie{
		Name:     "auth",
		Value:    user.Email,
		Path:     "/",
		HttpOnly: true,
	})
}

// ClearAuthCookie removes the authentication cookie
func ClearAuthCookie(w http.ResponseWriter) {
	http.SetCookie(w, &http.Cookie{
		Name:     "auth",
		Value:    "",
		Path:     "/",
		MaxAge:   -1,
		HttpOnly: true,
	})
}

// HandleLogin handles the login form submission
func HandleLogin(queries *db.Queries) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		email := r.FormValue("email")
		password := r.FormValue("password")

		user, err := Authenticate(queries, email, password)
		if err != nil {
			http.Redirect(w, r, "/?error=invalid_credentials", http.StatusSeeOther)
			return
		}

		SetAuthCookie(w, user)
		http.Redirect(w, r, "/dashboard", http.StatusSeeOther)
	}
}

// HandleLogout handles user logout
func HandleLogout() http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		ClearAuthCookie(w)
		http.Redirect(w, r, "/", http.StatusSeeOther)
	}
}
