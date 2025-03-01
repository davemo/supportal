package main

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"

	_ "github.com/lib/pq"
)

const (
	defaultDBName = "supportal"
	defaultDBHost = "localhost"
	defaultDBPort = 5432
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Available commands:")
		fmt.Println("  create  - Create the database")
		fmt.Println("  drop    - Drop the database")
		fmt.Println("  migrate - Run database migrations")
		fmt.Println("  seed    - Seed the database with sample data")
		fmt.Println("  reset   - Drop and recreate the database with migrations")
		fmt.Println("  full    - Reset and seed the database (full setup)")
		os.Exit(1)
	}

	cmd := os.Args[1]

	// Parse flags after the command
	dbName := flag.String("db", defaultDBName, "Database name")
	dbHost := flag.String("host", defaultDBHost, "Database host")
	dbPort := flag.Int("port", defaultDBPort, "Database port")
	flag.CommandLine.Parse(os.Args[2:])

	switch cmd {
	case "create":
		if err := createDB(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	case "drop":
		if err := dropDB(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	case "migrate":
		if err := runMigrations(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	case "seed":
		if err := seedDB(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	case "reset":
		if err := resetDB(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	case "full":
		if err := fullSetup(*dbName, *dbHost, *dbPort); err != nil {
			log.Fatal(err)
		}
	default:
		log.Fatalf("Unknown command: %s", cmd)
	}
}

func createDB(name, host string, port int) error {
	// Connect to postgres database to create our database
	connStr := fmt.Sprintf("host=%s port=%d dbname=postgres sslmode=disable", host, port)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("error connecting to postgres: %v", err)
	}
	defer db.Close()

	_, err = db.Exec(fmt.Sprintf("CREATE DATABASE %s", name))
	if err != nil {
		return fmt.Errorf("error creating database: %v", err)
	}

	fmt.Printf("Database '%s' created successfully\n", name)
	return nil
}

func dropDB(name, host string, port int) error {
	// Connect to postgres database to drop our database
	connStr := fmt.Sprintf("host=%s port=%d dbname=postgres sslmode=disable", host, port)
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		return fmt.Errorf("error connecting to postgres: %v", err)
	}
	defer db.Close()

	_, err = db.Exec(fmt.Sprintf("DROP DATABASE IF EXISTS %s", name))
	if err != nil {
		return fmt.Errorf("error dropping database: %v", err)
	}

	fmt.Printf("Database '%s' dropped successfully\n", name)
	return nil
}

func runMigrations(name, host string, port int) error {
	// Get the project root directory
	projectRoot, err := findProjectRoot()
	if err != nil {
		return fmt.Errorf("error finding project root: %v", err)
	}

	// Path to schema file
	schemaPath := filepath.Join(projectRoot, "sql", "schema.sql")

	// Use psql to run the schema file
	cmd := exec.Command("psql", 
		"-h", host,
		"-p", fmt.Sprintf("%d", port),
		"-d", name,
		"-f", schemaPath,
	)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error running migrations: %v", err)
	}

	fmt.Println("Migrations completed successfully")
	return nil
}

func seedDB(name, host string, port int) error {
	// Get the project root directory
	projectRoot, err := findProjectRoot()
	if err != nil {
		return fmt.Errorf("error finding project root: %v", err)
	}

	// Path to seed file
	seedPath := filepath.Join(projectRoot, "sql", "seed.sql")

	// Use psql to run the seed file
	cmd := exec.Command("psql", 
		"-h", host,
		"-p", fmt.Sprintf("%d", port),
		"-d", name,
		"-f", seedPath,
	)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr

	if err := cmd.Run(); err != nil {
		return fmt.Errorf("error seeding database: %v", err)
	}

	fmt.Println("Database seeded successfully")
	return nil
}

func resetDB(name, host string, port int) error {
	if err := dropDB(name, host, port); err != nil {
		return err
	}
	if err := createDB(name, host, port); err != nil {
		return err
	}
	if err := runMigrations(name, host, port); err != nil {
		return err
	}
	return nil
}

func fullSetup(name, host string, port int) error {
	if err := resetDB(name, host, port); err != nil {
		return err
	}
	if err := seedDB(name, host, port); err != nil {
		return err
	}
	fmt.Println("Full database setup completed successfully")
	return nil
}

func findProjectRoot() (string, error) {
	// Start from the current working directory
	dir, err := os.Getwd()
	if err != nil {
		return "", err
	}

	// Look for go.mod file to identify project root
	for {
		if _, err := os.Stat(filepath.Join(dir, "go.mod")); err == nil {
			return dir, nil
		}
		parent := filepath.Dir(dir)
		if parent == dir {
			return "", fmt.Errorf("could not find project root (no go.mod file found)")
		}
		dir = parent
	}
}
