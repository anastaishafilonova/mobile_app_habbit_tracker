CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS users (
    id            UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email         VARCHAR(255) NOT NULL UNIQUE,
    username      VARCHAR(255) NOT NULL,
    score         INTEGER      NOT NULL DEFAULT 0,
    avatar_image  VARCHAR(512)
);


CREATE TABLE IF NOT EXISTS logins (
    user_id         UUID        PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
    login           VARCHAR(255) NOT NULL UNIQUE,
    hashed_password VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS challenge_library (
    id          UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title       VARCHAR(255) NOT NULL,
    description TEXT,
    photo       VARCHAR(512),
    frequency   VARCHAR(50)  NOT NULL
);


CREATE TABLE IF NOT EXISTS challenges (
    id               UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title            VARCHAR(255) NOT NULL,
    description      TEXT,
    status           VARCHAR(50) NOT NULL,
    start_time       TIMESTAMPTZ NOT NULL,
    end_time         TIMESTAMPTZ NOT NULL,
    frequency        VARCHAR(50) NOT NULL,
    aim              INTEGER     NOT NULL,
    current_progress INTEGER     NOT NULL DEFAULT 0,
    push_on          BOOLEAN     NOT NULL DEFAULT TRUE,

    template_id      UUID REFERENCES challenge_library(id),
    created_by       UUID REFERENCES users(id),

    created_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    icon             TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS challenge_user (
    challenge_id UUID NOT NULL REFERENCES challenges(id) ON DELETE CASCADE,
    user_id      UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (challenge_id, user_id)
);
