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
	"supportal/pkg/view"
)

type User struct {
	ID             int
	Email          string
	HashedPassword string
	Name           string
}

func authenticateUser(db *sql.DB, email, password string) (*User, error) {
	log.Printf("Attempting to authenticate user: %s", email)
	
	user := &User{}
	err := db.QueryRow("SELECT id, email, hashed_password, name FROM users WHERE email = $1", email).
		Scan(&user.ID, &user.Email, &user.HashedPassword, &user.Name)
	if err != nil {
		log.Printf("Database query failed: %v", err)
		return nil, err
	}

	log.Printf("Found user %s, comparing passwords", user.Name)
	err = bcrypt.CompareHashAndPassword([]byte(user.HashedPassword), []byte(password))
	if err != nil {
		log.Printf("Password comparison failed: %v", err)
		return nil, err
	}

	log.Printf("Authentication successful for user: %s", user.Name)
	return user, nil
}

func requireAuth(db *sql.DB, next http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		cookie, err := r.Cookie("auth")
		if err != nil {
			http.Redirect(w, r, "/", http.StatusSeeOther)
			return
		}

		// In a production app, you'd want to verify the cookie value against a session store
		// For this example, we'll just verify the user exists
		user := &User{}
		err = db.QueryRow("SELECT id, email, name FROM users WHERE email = $1", cookie.Value).
			Scan(&user.ID, &user.Email, &user.Name)
		if err != nil {
			http.SetCookie(w, &http.Cookie{
				Name:   "auth",
				Value:  "",
				Path:   "/",
				MaxAge: -1,
			})
			http.Redirect(w, r, "/", http.StatusSeeOther)
			return
		}

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
	
	db, err := sql.Open("postgres", dbURL)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Verify database connection
	if err := db.Ping(); err != nil {
		log.Fatalf("Unable to connect to database: %v", err)
	}

	// Create router
	mux := http.NewServeMux()

	// Serve static files from assets directory
	fs := http.FileServer(http.Dir("assets"))
	mux.Handle("/assets/", http.StripPrefix("/assets/", fs))

	// Login page (public)
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		}

		component := view.Login()
		err := component.Render(context.Background(), w)
		if err != nil {
			log.Printf("error rendering login page: %v", err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	})

	// Handle login form submission
	mux.HandleFunc("/auth/login", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodPost {
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
			return
		}

		email := r.FormValue("email")
		password := r.FormValue("password")

		user, err := authenticateUser(db, email, password)
		if err != nil {
			log.Printf("authentication failed: %v", err)
			http.Redirect(w, r, "/?error=invalid_credentials", http.StatusSeeOther)
			return
		}

		// Set auth cookie
		http.SetCookie(w, &http.Cookie{
			Name:     "auth",
			Value:    user.Email, // In production, use a secure session token instead
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
	mux.HandleFunc("/dashboard", requireAuth(db, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(*User)
		
		component := view.Home(user.Name, user.Email)
		err := component.Render(context.Background(), w)
		if err != nil {
			log.Printf("error rendering dashboard: %v", err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
		}
	}))

	// Determine port from environment or use default
	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}

	addr := fmt.Sprintf(":%s", port)
	log.Printf("Starting server on http://localhost%s", addr)
	
	if err := http.ListenAndServe(addr, mux); err != nil {
		log.Fatal(err)
	}
}
