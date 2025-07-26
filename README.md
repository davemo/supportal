# Supportal

A support ticket management prototype built with Go, Templ, and Tailwind CSS.

## Development

### Prerequisites
- Go 1.21+
- PostgreSQL
- Templ CLI (`go install github.com/a-h/templ/cmd/templ@latest`)
- Tailwind CSS CLI

### Setup
1. Clone the repository
2. Copy `.env.example` to `.env` and configure your database
3. Run database migrations: `make db-migrate`
4. Seed the database: `make db-seed`
5. Generate templates: `templ generate`
6. Build CSS: `make tailwind` (or use `make dev` for watch mode)
7. Run the server: `go run cmd/supportal.go`

### Test Credentials
- Email: `admin@example.com`
- Password: `1`

### Tech Stack
- **Backend**: Go with Templ templating
- **Frontend**: Tailwind Plus Elements (vanilla JS web components)
- **Database**: PostgreSQL with sqlc
- **Styling**: Tailwind CSS v4

### Available Routes
- `/` - Login page
- `/dashboard` - Home dashboard
- `/tickets` - Support ticket management
- `/customers` - Customer management
- `/knowledge-base` - Documentation and help articles
- `/reports` - Analytics and reporting
- `/settings` - Application settings
