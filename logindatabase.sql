CREATE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN 
	NEW.updated_at = CURRENT_TIMESTAMP;
	RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE users (

id SERIAL PRIMARY KEY,

username VARCHAR(255) UNIQUE NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL,
hashed_password VARCHAR(255) NOT NULL,
is_active BOOLEAN DEFAULT TRUE,
created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
is_verified BOOLEAN DEFAULT FALSE NOT NULL
);

CREATE TRIGGER trigger_users_updated_at
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

COMMENT ON TABLE users IS 'Stores user account information, including credentials and status.';
COMMENT ON COLUMN users.id IS 'Unique identifier for the user (Primary Key).';
COMMENT ON COLUMN users.username IS 'User''s chosen login name, must be unique.';
COMMENT ON COLUMN users.email IS 'User''s email address, must be unique, used for login/communication.';
COMMENT ON COLUMN users.hashed_password IS 'Securely hashed password.';
COMMENT ON COLUMN users.is_active IS 'Indicates if the user account is currently active (TRUE) or disabled (FALSE).';
COMMENT ON COLUMN users.created_at IS 'Timestamp of when the user account was created.';
COMMENT ON COLUMN users.updated_at IS 'Timestamp of the last update to the user account information';

INSERT INTO users (username, email, hashed_password)
VALUES ('testuser', 'test@example.com', 'some_secure_hash_value');

SELECT * FROM users WHERE username = 'testuser';

UPDATE users SET email = 'new_test@example.com' WHERE username = 'testuser';

CREATE TABLE email_verification_tokens (

id SERIAL PRIMARY KEY,

user_email VARCHAR(255) NOT NULL REFERENCES users(email) ON DELETE CASCADE,
token VARCHAR(255) NOT NULL UNIQUE,
expires_at TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_verification_token ON email_verification_tokens(token);
CREATE INDEX idx_verification_user_email ON email_verification_tokens(user_email);

SELECT * FROM users;
SELECT * FROM email_verification_tokens WHERE id  = '1';