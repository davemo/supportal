-- Users
INSERT INTO users (email, name, hashed_password, avatar_url, created_at, updated_at) VALUES
('admin@example.com', 'Admin User', '$2a$10$EKlcR.QlnAYkB9bqUX7pQerVBgBh/xObhU6HdLyt1Cl8CyNjYYGFS', 'https://randomuser.me/api/portraits/men/1.jpg', NOW() - INTERVAL '30 days', NOW()),
('john.doe@example.com', 'John Doe', '$2a$10$9fCguFzUn1ae/wFf.5zRQO4h78yS5atIHFIr5/aYuPZMjMcLQJ.6m', 'https://randomuser.me/api/portraits/men/2.jpg', NOW() - INTERVAL '25 days', NOW()),
('jane.smith@example.com', 'Jane Smith', '$2a$10$GBSaBRxwXHZG9n0u.TVHKepxjaI0CO2kGVVZtEkRVIj/WQndSUMFG', 'https://randomuser.me/api/portraits/women/3.jpg', NOW() - INTERVAL '22 days', NOW()),
('michael.brown@example.com', 'Michael Brown', '$2a$10$9EhevrbVZGc0tQy0KGMBIeiSGhXLAZnxJUIEMc5QOiOZ4XpUH3UdG', 'https://randomuser.me/api/portraits/men/4.jpg', NOW() - INTERVAL '20 days', NOW()),
('emily.johnson@example.com', 'Emily Johnson', '$2a$10$d5OG/Q3J3slcJAYN1Nl1UeqFKfycHvTRDKMUgJy.ogThW.UPqjzGu', 'https://randomuser.me/api/portraits/women/5.jpg', NOW() - INTERVAL '18 days', NOW()),
('david.wilson@example.com', 'David Wilson', '$2a$10$w8J28HKl5S730MFcgzZhA.mN9T3I2J27YPm5uJvxZO0EBF87riSLO', 'https://randomuser.me/api/portraits/men/6.jpg', NOW() - INTERVAL '15 days', NOW()),
('sarah.davis@example.com', 'Sarah Davis', '$2a$10$n6TFQTedLpuIOhyaUZSWTO4xVdL3PtPDRbpQsC1TM1qcm.wCUf8LW', 'https://randomuser.me/api/portraits/women/7.jpg', NOW() - INTERVAL '12 days', NOW()),
('robert.miller@example.com', 'Robert Miller', '$2a$10$TGR0vpe7GNkGbT.ixGKqueR.WgpbP51Rr/E3ImTFW9f/qQfJYX8Qq', 'https://randomuser.me/api/portraits/men/8.jpg', NOW() - INTERVAL '10 days', NOW()),
('lisa.taylor@example.com', 'Lisa Taylor', '$2a$10$qVQ50ZVqQ0VCIGJzR0rokuCqNWw.qlNiOKMIjrS.OgKUcCB/CPRAK', 'https://randomuser.me/api/portraits/women/9.jpg', NOW() - INTERVAL '8 days', NOW()),
('james.anderson@example.com', 'James Anderson', '$2a$10$QHUF56W4yg3CqO92sXSr8.fGzNhgAHGhSyRXqjLWFYSvvFU08XG1G', 'https://randomuser.me/api/portraits/men/10.jpg', NOW() - INTERVAL '5 days', NOW());

-- Roles
INSERT INTO roles (name, description) VALUES
('admin', 'Full system access with all privileges'),
('manager', 'Organization management with limited system access'),
('user', 'Standard user with basic access'),
('editor', 'Content creation and editing permissions'),
('viewer', 'Read-only access to content');

-- User Roles
INSERT INTO user_roles (user_id, role_id) VALUES
(1, 1), -- Admin User is admin
(2, 2), -- John Doe is manager
(3, 3), -- Jane Smith is user
(4, 4), -- Michael Brown is editor
(5, 3), -- Emily Johnson is user
(6, 2), -- David Wilson is manager
(7, 4), -- Sarah Davis is editor
(8, 3), -- Robert Miller is user
(9, 5), -- Lisa Taylor is viewer
(10, 3); -- James Anderson is user

-- Organizations
INSERT INTO organizations (name, slug, logo_url, settings, created_at) VALUES
('Acme Corporation', 'acme-corp', 'https://example.com/logos/acme.png', '{"theme": "dark", "features": {"analytics": true, "chat": true}}', NOW() - INTERVAL '28 days'),
('Globex Solutions', 'globex', 'https://example.com/logos/globex.png', '{"theme": "light", "features": {"analytics": true, "chat": false}}', NOW() - INTERVAL '24 days'),
('Initech', 'initech', 'https://example.com/logos/initech.png', '{"theme": "blue", "features": {"analytics": false, "chat": true}}', NOW() - INTERVAL '20 days');

-- Teams
INSERT INTO teams (org_id, name, description, created_at) VALUES
(1, 'Engineering', 'Technical development and infrastructure team', NOW() - INTERVAL '27 days'),
(1, 'Marketing', 'Brand management and customer acquisition', NOW() - INTERVAL '26 days'),
(2, 'Product', 'Product management and roadmap planning', NOW() - INTERVAL '23 days'),
(2, 'Design', 'UX/UI design and user experience', NOW() - INTERVAL '22 days'),
(3, 'Sales', 'Client relationships and revenue generation', NOW() - INTERVAL '19 days');

-- Team Members
INSERT INTO team_members (team_id, user_id, role) VALUES
(1, 1, 'lead'),
(1, 2, 'member'),
(1, 8, 'member'),
(2, 3, 'lead'),
(2, 5, 'member'),
(2, 9, 'member'),
(3, 6, 'lead'),
(3, 4, 'member'),
(4, 7, 'lead'),
(4, 10, 'member'),
(5, 6, 'lead'),
(5, 9, 'member');

-- Documents
INSERT INTO documents (title, content, author_id, status, published_at, created_at) VALUES
('Getting Started Guide', 'This guide helps new users get started with our platform...', 1, 'published', NOW() - INTERVAL '25 days', NOW() - INTERVAL '27 days'),
('API Documentation', 'Comprehensive API documentation for developers...', 2, 'published', NOW() - INTERVAL '23 days', NOW() - INTERVAL '24 days'),
('Product Roadmap', 'Our vision for the next 12 months of product development...', 6, 'draft', NULL, NOW() - INTERVAL '22 days'),
('Marketing Strategy', 'Q3 marketing strategy and campaign plans...', 3, 'published', NOW() - INTERVAL '20 days', NOW() - INTERVAL '21 days'),
('Design System Guidelines', 'Guidelines for maintaining consistency in our design system...', 7, 'published', NOW() - INTERVAL '18 days', NOW() - INTERVAL '19 days'),
('Quarterly Report', 'Financial and operational results for Q2...', 1, 'draft', NULL, NOW() - INTERVAL '15 days'),
('User Onboarding Flow', 'Documentation of the revised user onboarding process...', 4, 'published', NOW() - INTERVAL '12 days', NOW() - INTERVAL '14 days'),
('Security Best Practices', 'Guidelines for maintaining security in our applications...', 2, 'published', NOW() - INTERVAL '10 days', NOW() - INTERVAL '11 days'),
('Team Structure', 'Overview of our new team structure and responsibilities...', 6, 'draft', NULL, NOW() - INTERVAL '9 days'),
('Brand Guidelines', 'Official brand guidelines including logos and color palettes...', 7, 'published', NOW() - INTERVAL '7 days', NOW() - INTERVAL '8 days');

-- Media Assets
INSERT INTO media_assets (name, file_url, file_type, size_bytes, uploaded_by, created_at) VALUES
('company_logo.png', 'https://via.placeholder.com/400x200.png?text=Company+Logo', 'image/png', 256000, 1, NOW() - INTERVAL '26 days'),
('brand_icon.png', 'https://robohash.org/acme-brand.png?size=150x150&set=set1', 'image/png', 128000, 3, NOW() - INTERVAL '24 days'),
('product_screenshot.jpg', 'https://picsum.photos/800/600?random=1', 'image/jpeg', 350000, 2, NOW() - INTERVAL '22 days'),
('user_manual.pdf', 'https://mozilla.github.io/pdf.js/web/compressed.tracemonkey-pldi-09.pdf', 'application/pdf', 4200000, 4, NOW() - INTERVAL '20 days'),
('annual_report.pdf', 'https://mozilla.github.io/pdf.js/legacy/web/compressed.tracemonkey-pldi-09.pdf', 'application/pdf', 3800000, 1, NOW() - INTERVAL '18 days'),
('team_photo.jpg', 'https://picsum.photos/1200/800?random=2', 'image/jpeg', 2300000, 6, NOW() - INTERVAL '15 days'),
('profile_avatar.png', 'https://robohash.org/user-profile.png?size=300x300&set=set2', 'image/png', 180000, 3, NOW() - INTERVAL '12 days'),
('banner_image.jpg', 'https://picsum.photos/1920/600?random=3', 'image/jpeg', 870000, 7, NOW() - INTERVAL '10 days'),
('product_icon.png', 'https://via.placeholder.com/512x512.png?text=Product', 'image/png', 350000, 2, NOW() - INTERVAL '7 days'),
('help_guide.pdf', 'https://raw.githubusercontent.com/mozilla/pdf.js/master/web/compressed.tracemonkey-pldi-09.pdf', 'application/pdf', 3200000, 7, NOW() - INTERVAL '5 days');

-- Projects
INSERT INTO projects (name, description, owner_id, org_id, status, created_at) VALUES
('Website Redesign', 'Complete overhaul of the company website with new branding', 1, 1, 'active', NOW() - INTERVAL '25 days'),
('Mobile App Development', 'Creating native mobile applications for iOS and Android', 2, 1, 'active', NOW() - INTERVAL '23 days'),
('Customer Portal', 'Self-service portal for customers to manage their accounts', 6, 2, 'planning', NOW() - INTERVAL '20 days'),
('Analytics Dashboard', 'Internal analytics dashboard for tracking key metrics', 4, 2, 'active', NOW() - INTERVAL '18 days'),
('E-commerce Integration', 'Integrating e-commerce functionality into the main product', 6, 3, 'on_hold', NOW() - INTERVAL '15 days');

-- Tasks
INSERT INTO tasks (project_id, title, description, assignee_id, status, due_date, created_at) VALUES
(1, 'Design Homepage', 'Create wireframes and mockups for the new homepage', 7, 'completed', NOW() + INTERVAL '5 days', NOW() - INTERVAL '24 days'),
(1, 'Implement Homepage', 'Develop the homepage based on approved designs', 2, 'in_progress', NOW() + INTERVAL '10 days', NOW() - INTERVAL '23 days'),
(1, 'Content Migration', 'Migrate content from old site to new site', 3, 'todo', NOW() + INTERVAL '15 days', NOW() - INTERVAL '22 days'),
(2, 'iOS Development', 'Build the iOS version of the mobile app', 8, 'in_progress', NOW() + INTERVAL '20 days', NOW() - INTERVAL '22 days'),
(2, 'Android Development', 'Build the Android version of the mobile app', 4, 'todo', NOW() + INTERVAL '25 days', NOW() - INTERVAL '22 days'),
(2, 'User Testing', 'Conduct user testing for the mobile apps', 5, 'todo', NOW() + INTERVAL '30 days', NOW() - INTERVAL '21 days'),
(3, 'Requirements Gathering', 'Collect and document requirements for the customer portal', 6, 'completed', NOW() - INTERVAL '5 days', NOW() - INTERVAL '19 days'),
(3, 'Database Design', 'Design the database schema for the customer portal', 2, 'in_progress', NOW() + INTERVAL '5 days', NOW() - INTERVAL '18 days'),
(3, 'Authentication System', 'Implement user authentication and authorization', 8, 'todo', NOW() + INTERVAL '15 days', NOW() - INTERVAL '17 days'),
(4, 'Data Modeling', 'Define the data model for analytics tracking', 4, 'completed', NOW() - INTERVAL '3 days', NOW() - INTERVAL '17 days'),
(4, 'Dashboard UI', 'Design the user interface for the analytics dashboard', 7, 'in_progress', NOW() + INTERVAL '7 days', NOW() - INTERVAL '16 days'),
(4, 'API Integration', 'Integrate with data sources via APIs', 10, 'todo', NOW() + INTERVAL '12 days', NOW() - INTERVAL '15 days'),
(5, 'Payment Gateway Research', 'Research and select payment gateway options', 6, 'completed', NOW() - INTERVAL '2 days', NOW() - INTERVAL '14 days'),
(5, 'Shopping Cart Design', 'Design the shopping cart functionality', 7, 'on_hold', NOW() + INTERVAL '20 days', NOW() - INTERVAL '13 days'),
(5, 'Inventory Management', 'Design and implement inventory management system', 8, 'on_hold', NOW() + INTERVAL '25 days', NOW() - INTERVAL '12 days');

-- Messages
INSERT INTO messages (sender_id, recipient_id, content, read_at, created_at) VALUES
(1, 2, 'Can you share an update on the website redesign project?', NOW() - INTERVAL '22 days', NOW() - INTERVAL '23 days'),
(2, 1, 'Sure, we''ve completed the design phase and started implementation.', NOW() - INTERVAL '22 days', NOW() - INTERVAL '22 days'),
(3, 4, 'When will the content migration task be assigned to me?', NULL, NOW() - INTERVAL '21 days'),
(4, 3, 'I''ll add you to the task this week.', NOW() - INTERVAL '20 days', NOW() - INTERVAL '20 days'),
(6, 7, 'The customer portal project needs your design input.', NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),
(7, 6, 'I''ll review the requirements and get back to you.', NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),
(8, 9, 'Can you help test the iOS app this Friday?', NULL, NOW() - INTERVAL '15 days'),
(2, 5, 'Meeting tomorrow at 10 AM to discuss the analytics dashboard.', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
(5, 2, 'I''ll be there, thanks for the reminder.', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
(1, 10, 'Welcome to the team! Let me know if you need any help getting started.', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days');

-- Notifications
INSERT INTO notifications (user_id, title, content, type, read_at, created_at) VALUES
(2, 'Task Assigned', 'You have been assigned to the "Implement Homepage" task.', 'task_assignment', NOW() - INTERVAL '23 days', NOW() - INTERVAL '23 days'),
(3, 'Document Published', 'The "Marketing Strategy" document has been published.', 'document_update', NULL, NOW() - INTERVAL '20 days'),
(4, 'Task Due Soon', 'The "Android Development" task is due in 3 days.', 'task_reminder', NOW() - INTERVAL '18 days', NOW() - INTERVAL '18 days'),
(5, 'Meeting Invitation', 'You have been invited to the Analytics Dashboard project meeting.', 'meeting', NOW() - INTERVAL '10 days', NOW() - INTERVAL '10 days'),
(6, 'Project Status Change', 'The "E-commerce Integration" project has been put on hold.', 'project_update', NULL, NOW() - INTERVAL '15 days'),
(7, 'Task Completed', 'The "Design Homepage" task has been marked as completed.', 'task_update', NOW() - INTERVAL '15 days', NOW() - INTERVAL '15 days'),
(8, 'New Message', 'You have a new message from Robert Miller.', 'message', NULL, NOW() - INTERVAL '15 days'),
(9, 'Team Addition', 'You have been added to the Marketing team.', 'team_update', NOW() - INTERVAL '26 days', NOW() - INTERVAL '26 days'),
(10, 'Welcome', 'Welcome to the platform! Complete your profile to get started.', 'system', NOW() - INTERVAL '5 days', NOW() - INTERVAL '5 days'),
(1, 'System Update', 'The system will be undergoing maintenance tonight from 2-4 AM.', 'system', NOW() - INTERVAL '7 days', NOW() - INTERVAL '7 days');

-- Audit Logs
INSERT INTO audit_logs (user_id, action, entity_type, entity_id, metadata, created_at) VALUES
(1, 'create', 'user', 10, '{"ip": "192.168.1.100", "browser": "Chrome"}', NOW() - INTERVAL '26 days'),
(1, 'update', 'document', 1, '{"changes": {"status": ["draft", "published"]}}', NOW() - INTERVAL '25 days'),
(2, 'create', 'project', 1, '{"ip": "192.168.1.101", "browser": "Firefox"}', NOW() - INTERVAL '25 days'),
(6, 'create', 'project', 3, '{"ip": "192.168.1.102", "browser": "Safari"}', NOW() - INTERVAL '20 days'),
(4, 'update', 'task', 10, '{"changes": {"status": ["in_progress", "completed"]}}', NOW() - INTERVAL '17 days'),
(1, 'delete', 'media_asset', 3, '{"ip": "192.168.1.100", "browser": "Chrome"}', NOW() - INTERVAL '15 days'),
(3, 'create', 'document', 4, '{"ip": "192.168.1.103", "browser": "Edge"}', NOW() - INTERVAL '21 days'),
(6, 'update', 'project', 5, '{"changes": {"status": ["active", "on_hold"]}}', NOW() - INTERVAL '15 days'),
(2, 'update', 'user', 5, '{"changes": {"name": ["Emily J.", "Emily Johnson"]}}', NOW() - INTERVAL '12 days'),
(1, 'create', 'team', 1, '{"ip": "192.168.1.100", "browser": "Chrome"}', NOW() - INTERVAL '27 days');

-- Activity Feed
INSERT INTO activity_feed (actor_id, action, target_type, target_id, org_id, created_at) VALUES
(1, 'created', 'document', 1, 1, NOW() - INTERVAL '27 days'),
(2, 'updated', 'project', 1, 1, NOW() - INTERVAL '24 days'),
(3, 'commented', 'document', 4, 1, NOW() - INTERVAL '21 days'),
(4, 'completed', 'task', 10, 2, NOW() - INTERVAL '17 days'),
(6, 'created', 'project', 3, 2, NOW() - INTERVAL '20 days'),
(7, 'shared', 'document', 5, 2, NOW() - INTERVAL '19 days'),
(1, 'mentioned', 'user', 2, 1, NOW() - INTERVAL '18 days'),
(6, 'updated', 'project', 5, 3, NOW() - INTERVAL '15 days'),
(7, 'completed', 'task', 1, 1, NOW() - INTERVAL '15 days'),
(2, 'uploaded', 'media_asset', 9, 1, NOW() - INTERVAL '7 days');

-- Feature Flags
INSERT INTO feature_flags (name, description, enabled, rollout_percentage, created_at) VALUES
('dark_mode', 'Enable dark mode UI across the application', true, 100, NOW() - INTERVAL '30 days'),
('new_dashboard', 'New analytics dashboard with enhanced visualizations', true, 50, NOW() - INTERVAL '25 days'),
('chat_feature', 'Real-time chat functionality between users', false, 0, NOW() - INTERVAL '20 days'),
('advanced_search', 'Enhanced search with filters and saved searches', true, 25, NOW() - INTERVAL '15 days'),
('ai_suggestions', 'AI-powered content suggestions', false, 0, NOW() - INTERVAL '10 days');

-- App Settings
INSERT INTO app_settings (key, value, scope, updated_at) VALUES
('email_notifications', '{"enabled": true, "daily_digest": true, "marketing": false}', 'global', NOW() - INTERVAL '29 days'),
('security', '{"two_factor_auth": true, "session_timeout_minutes": 30}', 'global', NOW() - INTERVAL '28 days'),
('appearance', '{"default_theme": "light", "custom_css": false}', 'global', NOW() - INTERVAL '27 days'),
('uploads', '{"max_file_size_mb": 50, "allowed_types": ["image", "document", "video"]}', 'global', NOW() - INTERVAL '26 days'),
('performance', '{"cache_ttl_minutes": 15, "pagination_limit": 20}', 'global', NOW() - INTERVAL '25 days');

-- Events
INSERT INTO events (event_type, user_id, metadata, created_at) VALUES
('login', 1, '{"ip": "192.168.1.100", "device": "desktop"}', NOW() - INTERVAL '23 days'),
('logout', 1, '{"ip": "192.168.1.100", "device": "desktop"}', NOW() - INTERVAL '23 days'),
('login', 2, '{"ip": "192.168.1.101", "device": "mobile"}', NOW() - INTERVAL '22 days'),
('document_view', 3, '{"document_id": 4, "time_spent_seconds": 120}', NOW() - INTERVAL '21 days'),
('project_create', 6, '{"project_id": 3, "template": "default"}', NOW() - INTERVAL '20 days'),
('task_update', 4, '{"task_id": 10, "status_change": "completed"}', NOW() - INTERVAL '17 days'),
('login', 5, '{"ip": "192.168.1.103", "device": "tablet"}', NOW() - INTERVAL '15 days'),
('document_download', 2, '{"document_id": 8, "format": "pdf"}', NOW() - INTERVAL '10 days'),
('password_reset', 9, '{"ip": "192.168.1.105", "device": "desktop"}', NOW() - INTERVAL '8 days'),
('login', 10, '{"ip": "192.168.1.110", "device": "mobile"}', NOW() - INTERVAL '5 days');

-- Metrics
INSERT INTO metrics (name, value, dimensions, timestamp) VALUES
('active_users', 126, '{"period": "daily"}', NOW() - INTERVAL '1 day'),
('active_users', 845, '{"period": "weekly"}', NOW() - INTERVAL '1 day'),
('active_users', 1423, '{"period": "monthly"}', NOW() - INTERVAL '1 day'),
('page_views', 5231, '{"page": "homepage"}', NOW() - INTERVAL '1 day'),
('page_views', 3120, '{"page": "dashboard"}', NOW() - INTERVAL '1 day'),
('api_requests', 28561, '{"endpoint": "all"}', NOW() - INTERVAL '1 day'),
('document_count', 145, '{"status": "published"}', NOW() - INTERVAL '1 day'),
('document_count', 87, '{"status": "draft"}', NOW() - INTERVAL '1 day'),
('avg_response_time', 256, '{"unit": "ms"}', NOW() - INTERVAL '1 day'),
('error_count', 23, '{"type": "api"}', NOW() - INTERVAL '1 day');