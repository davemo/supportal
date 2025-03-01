
-- name: GetUserByID :one
SELECT * FROM users WHERE id = $1 LIMIT 1;

-- name: GetUserByEmail :one
SELECT * FROM users WHERE email = $1 LIMIT 1;

-- name: CreateUser :one
INSERT INTO users (email, name, hashed_password, avatar_url)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: UpdateUser :one
UPDATE users
SET name = COALESCE($2, name),
    email = COALESCE($3, email),
    avatar_url = COALESCE($4, avatar_url),
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: ListUsersByOrganization :many
SELECT DISTINCT u.*
FROM users u
JOIN team_members tm ON tm.user_id = u.id
JOIN teams t ON t.id = tm.team_id
WHERE t.org_id = $1;

-- name: CreateOrganization :one
INSERT INTO organizations (name, slug, logo_url, settings)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetOrganizationBySlug :one
SELECT * FROM organizations WHERE slug = $1 LIMIT 1;

-- name: CreateTeam :one
INSERT INTO teams (org_id, name, description)
VALUES ($1, $2, $3)
RETURNING *;

-- name: AddTeamMember :one
INSERT INTO team_members (team_id, user_id, role)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetTeamMembers :many
SELECT u.*, tm.role as team_role
FROM team_members tm
JOIN users u ON u.id = tm.user_id
WHERE tm.team_id = $1;

-- name: CreateProject :one
INSERT INTO projects (name, description, owner_id, org_id, status)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: ListProjectsByOrg :many
SELECT p.*, u.name as owner_name
FROM projects p
JOIN users u ON u.id = p.owner_id
WHERE p.org_id = $1
ORDER BY p.created_at DESC;

-- name: CreateTask :one
INSERT INTO tasks (project_id, title, description, assignee_id, status, due_date)
VALUES ($1, $2, $3, $4, $5, $6)
RETURNING *;

-- name: ListTasksByProject :many
SELECT t.*, u.name as assignee_name
FROM tasks t
LEFT JOIN users u ON u.id = t.assignee_id
WHERE t.project_id = $1
ORDER BY t.due_date ASC NULLS LAST;

-- name: UpdateTaskStatus :one
UPDATE tasks
SET status = $2,
    updated_at = NOW()
WHERE id = $1
RETURNING *;

-- name: CreateMessage :one
INSERT INTO messages (sender_id, recipient_id, content)
VALUES ($1, $2, $3)
RETURNING *;

-- name: GetUnreadMessageCount :one
SELECT COUNT(*)
FROM messages
WHERE recipient_id = $1 AND read_at IS NULL;

-- name: MarkMessageAsRead :exec
UPDATE messages
SET read_at = NOW()
WHERE id = $1 AND recipient_id = $2;

-- name: CreateNotification :one
INSERT INTO notifications (user_id, title, content, type)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: GetUnreadNotifications :many
SELECT *
FROM notifications
WHERE user_id = $1 AND read_at IS NULL
ORDER BY created_at DESC;

-- name: LogAuditEvent :one
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, metadata)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: CreateActivityFeedEntry :one
INSERT INTO activity_feed (actor_id, action, target_type, target_id, org_id)
VALUES ($1, $2, $3, $4, $5)
RETURNING *;

-- name: GetActivityFeed :many
SELECT af.*, u.name as actor_name, u.avatar_url as actor_avatar
FROM activity_feed af
JOIN users u ON u.id = af.actor_id
WHERE af.org_id = $1
ORDER BY af.created_at DESC
LIMIT $2;

-- name: UpsertFeatureFlag :one
INSERT INTO feature_flags (name, description, enabled, rollout_percentage)
VALUES ($1, $2, $3, $4)
ON CONFLICT (name) DO UPDATE
SET description = EXCLUDED.description,
    enabled = EXCLUDED.enabled,
    rollout_percentage = EXCLUDED.rollout_percentage,
    created_at = NOW()
RETURNING *;

-- name: GetFeatureFlag :one
SELECT * FROM feature_flags WHERE name = $1;