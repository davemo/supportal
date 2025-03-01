CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255),
    hashed_password VARCHAR(255),
    avatar_url VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW (),
    updated_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE user_roles (
    user_id INT REFERENCES users (id),
    role_id INT REFERENCES roles (id),
    PRIMARY KEY (user_id, role_id)
);

CREATE TABLE organizations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    logo_url VARCHAR(255),
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE teams (
    id SERIAL PRIMARY KEY,
    org_id INT REFERENCES organizations (id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE team_members (
    team_id INT REFERENCES teams (id),
    user_id INT REFERENCES users (id),
    role VARCHAR(50) NOT NULL,
    PRIMARY KEY (team_id, user_id)
);

CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT,
    author_id INT REFERENCES users (id),
    status VARCHAR(50) DEFAULT 'draft',
    published_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE media_assets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    file_url VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    size_bytes BIGINT,
    uploaded_by INT REFERENCES users (id),
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id INT REFERENCES users (id),
    org_id INT REFERENCES organizations (id),
    status VARCHAR(50) DEFAULT 'active',
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects (id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    assignee_id INT REFERENCES users (id),
    status VARCHAR(50) DEFAULT 'todo',
    due_date TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    sender_id INT REFERENCES users (id),
    recipient_id INT REFERENCES users (id),
    content TEXT NOT NULL,
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users (id),
    title VARCHAR(255) NOT NULL,
    content TEXT,
    type VARCHAR(50),
    read_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE audit_logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users (id),
    action VARCHAR(50) NOT NULL,
    entity_type VARCHAR(50) NOT NULL,
    entity_id INT NOT NULL,
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE activity_feed (
    id SERIAL PRIMARY KEY,
    actor_id INT REFERENCES users (id),
    action VARCHAR(50) NOT NULL,
    target_type VARCHAR(50),
    target_id INT,
    org_id INT REFERENCES organizations (id),
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE feature_flags (
    name VARCHAR(255) PRIMARY KEY,
    description TEXT,
    enabled BOOLEAN DEFAULT false,
    rollout_percentage INT DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE app_settings (
    key VARCHAR(255) PRIMARY KEY,
    value JSONB NOT NULL,
    scope VARCHAR(50) DEFAULT 'global',
    updated_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    event_type VARCHAR(50) NOT NULL,
    user_id INT REFERENCES users (id),
    metadata JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW ()
);

CREATE TABLE metrics (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    value NUMERIC NOT NULL,
    dimensions JSONB DEFAULT '{}',
    timestamp TIMESTAMPTZ DEFAULT NOW ()
);
