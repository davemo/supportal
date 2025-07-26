package main

import (
	"context"
	"database/sql"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
	_ "github.com/lib/pq"

	"supportal/pkg/auth"
	"supportal/pkg/db"
	"supportal/pkg/view"
)

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

	// Auth routes
	mux.HandleFunc("/auth/login", auth.HandleLogin(queries))
	mux.HandleFunc("/auth/logout", auth.HandleLogout())

	// Dashboard (protected)
	mux.HandleFunc("/dashboard", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Home(user.Email, user.Name.String, user.AvatarUrl.String)
		component.Render(context.Background(), w)
	}))

	// Tickets (protected)
	mux.HandleFunc("/tickets", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Tickets(user.Email, user.Name.String, user.AvatarUrl.String)
		component.Render(context.Background(), w)
	}))

	// Customers (protected)
	mux.HandleFunc("/customers", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Customers(user.Email, user.Name.String, user.AvatarUrl.String)
		component.Render(context.Background(), w)
	}))

	// Knowledge Base (protected)
	mux.HandleFunc("/knowledge-base", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.KnowledgeBase(user.Email, user.Name.String, user.AvatarUrl.String)
		component.Render(context.Background(), w)
	}))

	// Reports (protected)
	mux.HandleFunc("/reports", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Reports(user.Email, user.Name.String, user.AvatarUrl.String)
		component.Render(context.Background(), w)
	}))

	// Settings (protected)
	mux.HandleFunc("/settings", auth.RequireAuth(queries, func(w http.ResponseWriter, r *http.Request) {
		user := r.Context().Value("user").(db.User)
		component := view.Settings(user.Email, user.Name.String, user.AvatarUrl.String)
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
