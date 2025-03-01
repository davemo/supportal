package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net/http"
	"os"
	"golang.org/x/crypto/bcrypt"
	_ "github.com/lib/pq"
	"github.com/joho/godotenv"
	"supportal/pkg/db"
	"supportal/pkg/view"
)

// authenticateUser checks if the provided email/password combo is valid
func authenticateUser(queries *db.Queries, email, password string) (db.User, error) {
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

// requireAuth is middleware that checks if a user is authenticated
func requireAuth(queries *db.Queries, next http.HandlerFunc) http.HandlerFunc {
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

func main() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Printf("Warning: Error loading .env file: %v", err)
	}

	// Initialize database connection
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		log.Fatal("DATABASE_URL environment variable is required")
	}
	
	dbConn, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer dbConn.Close()

	// Verify database connection
	if err := dbConn.Ping(); err != nil {
		log.Fatalf("Unable to connect to database: %v", err)
	}

	// Create queries instance
	queries := db.New(dbConn)

	// Create router
	mux := http.NewServeMux()

	// Serve static files
	fs := http.FileServer(http.Dir("assets"))
	mux.Handle("/assets/", http.StripPrefix("/assets/", fs))

	// Login page (/)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		component := view.Login()
		component.Render(context.Background(), w)
	})

	// Handle login form submission
	mux.HandleFunc("/auth/login", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		email := r.FormValue("email")
		password := r.FormValue("password")

		user, err := authenticateUser(queries, email, password)
		if err != nil {
			log.Printf("authentication failed: %v", err)
			http.Redirect(w, r, "/?error=invalid_credentials", http.StatusSeeOther)
			return
		}

		// Set auth cookie
		http.SetCookie(w, &http.Cookie{
			Name:     "auth",
			Value:    user.Email,
			Path:     "/",
			HttpOnly: true,
		})

		http.Redirect(w, r, "/dashboard", http.StatusSeeOther)
	})

	// Handle logout
	mux.HandleFunc("/auth/logout", func(w http.ResponseWriter, r *http.Request) {
		// Clear the auth cookie
		http.SetCookie(w, &http.Cookie{
			Name:     "auth",
			Value:    "",
			Path:     "/",
			MaxAge:   -1,
			HttpOnly: true,
		})

		http.Redirect(w, r, "/", http.StatusSeeOther)
	})

	// Dashboard (protected)
	mux.HandleFunc("/dashboard", requireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Home(user.Email, user.Name.String)
		component.Render(context.Background(), w)
	}))

	// Start server
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	log.Printf("Server starting on http://localhost:%s", port)
	if err := http.ListenAndServe(":"+port, mux); err != nil {
		log.Fatal(err)
	}
}
