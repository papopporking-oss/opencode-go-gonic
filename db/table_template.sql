CREATE TABLE table_template (
    id bigserial PRIMARY KEY NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    value_varchar VARCHAR(255) NOT NULL,
    value_text TEXT NOT NULL,
    value_int8 int8 NOT NULL,
    value_float8 float8 NOT NULL,
    value_bool BOOLEAN NOT NULL
);