package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"

	"supportal/pkg/view"
)

func main() {
	mux := http.NewServeMux()

	// Serve static files from assets directory
	fs := http.FileServer(http.Dir("assets"))
	mux.Handle("/assets/", http.StripPrefix("/assets/", fs))

	// Mount routes
	mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/" {
			http.NotFound(w, r)
			return
		}
		
		component := view.Home()
		err := component.Render(context.Background(), w)
		if err != nil {
			log.Printf("error rendering home page: %v", err)
			http.Error(w, "Internal Server Error", http.StatusInternalServerError)
			return
		}
	})

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
