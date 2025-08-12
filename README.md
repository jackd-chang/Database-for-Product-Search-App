# Login Database Schema

This project contains a PostgreSQL database schema for a basic user authentication system, including account management, email verification, and automatic timestamp updates.

## Overview

The schema includes:

- **`users` table** — stores user account details, hashed passwords, account status, and timestamps.
- **`email_verification_tokens` table** — stores one-time email verification tokens for user account confirmation.
- **Trigger & Function** — automatically updates the `updated_at` column whenever a user record changes.

---

## Tables & Structure

### 1. `users`
| Column         | Type                      | Constraints                                     | Description |
|----------------|---------------------------|-------------------------------------------------|-------------|
| `id`           | SERIAL PRIMARY KEY         | Unique, auto-increment                         | User ID |
| `username`     | VARCHAR(255)               | UNIQUE, NOT NULL                               | Chosen login name |
| `email`        | VARCHAR(255)               | UNIQUE, NOT NULL                               | User email address |
| `hashed_password` | VARCHAR(255)            | NOT NULL                                       | Securely hashed password |
| `is_active`    | BOOLEAN                    | DEFAULT `TRUE`                                 | Account status |
| `created_at`   | TIMESTAMPTZ                | DEFAULT `CURRENT_TIMESTAMP`                    | Creation time |
| `updated_at`   | TIMESTAMPTZ                | DEFAULT `CURRENT_TIMESTAMP`                    | Last update time |
| `is_verified`  | BOOLEAN                    | DEFAULT `FALSE`, NOT NULL                      | Email verification status |

### 2. `email_verification_tokens`
| Column         | Type            | Constraints                                     | Description |
|----------------|-----------------|-------------------------------------------------|-------------|
| `id`           | SERIAL PRIMARY KEY | Unique, auto-increment                       | Token ID |
| `user_email`   | VARCHAR(255)    | NOT NULL, FOREIGN KEY → `users.email` ON DELETE CASCADE | Associated email |
| `token`        | VARCHAR(255)    | UNIQUE, NOT NULL                               | Verification token |
| `expires_at`   | TIMESTAMPTZ     | NOT NULL                                       | Expiration time |

---

## Triggers & Functions

### `update_updated_at_column()`
A PostgreSQL function that updates the `updated_at` timestamp on every row update in the `users` table.

### Trigger: `trigger_users_updated_at`
- Fires **BEFORE UPDATE** on `users`.
- Calls `update_updated_at_column()`.

---

## Example Data

The SQL script includes example inserts for testing:
```sql
INSERT INTO users (username, email, hashed_password)
VALUES ('testuser', 'test@example.com', 'some_secure_hash_value');
