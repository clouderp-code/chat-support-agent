#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    ALTER USER postgres WITH PASSWORD NULL;
    CREATE DATABASE chat_support;
    GRANT ALL PRIVILEGES ON DATABASE chat_support TO postgres;
EOSQL 