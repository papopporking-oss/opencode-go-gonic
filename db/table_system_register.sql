CREATE TABLE auth_user (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) UNIQUE,
    status VARCHAR(30) NOT NULL DEFAULT 'pending',
    email_verified_at TIMESTAMPTZ
);

CREATE TABLE auth_user_profiles (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    user_id BIGINT NOT NULL UNIQUE REFERENCES auth_user(id) ON DELETE RESTRICT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    display_name VARCHAR(150),
    phone VARCHAR(30),
    avatar_url TEXT
);

CREATE TABLE auth_user_credentials (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    user_id BIGINT NOT NULL UNIQUE REFERENCES auth_user(id) ON DELETE RESTRICT,
    password_hash TEXT NOT NULL
);

CREATE TABLE auth_user_sessions (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    user_id BIGINT NOT NULL REFERENCES auth_user(id) ON DELETE RESTRICT,
    refresh_token_hash TEXT NOT NULL UNIQUE,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ
);

CREATE TABLE auth_user_verification_tokens (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    user_id BIGINT NOT NULL REFERENCES auth_user(id) ON DELETE RESTRICT,
    token_hash TEXT NOT NULL UNIQUE,
    type VARCHAR(30) NOT NULL,
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ
);

CREATE TABLE auth_roles (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT
);

CREATE TABLE auth_user_roles (
    id BIGSERIAL PRIMARY KEY,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    user_id BIGINT NOT NULL REFERENCES auth_user(id) ON DELETE RESTRICT,
    role_id BIGINT NOT NULL REFERENCES auth_roles(id) ON DELETE RESTRICT,

    UNIQUE (user_id, role_id)
);