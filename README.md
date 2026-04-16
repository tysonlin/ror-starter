# ror-starter

Ruby on Rails microservice scaffold with:
- REST JSON API (`GET /entities`, `POST /entities`)
- GraphQL (`POST /graphql`) query + mutation
- Kafka producer + consumer using Protobuf payloads
- PostgreSQL persistence
- Tests at interface/service level

## 1) Prerequisites

- Ruby `3.2.3`
- Bundler `2.5+`
- PostgreSQL (local) or Docker
- Kafka broker (local) or Docker (compose includes Redpanda)

## 2) Install dependencies

```bash
bundle install
```

## 3) Local configuration (without Docker)

Set env vars:

```bash
export POSTGRES_HOST=localhost
export POSTGRES_DB=ror_starter_development
export POSTGRES_USER=postgres
export POSTGRES_PASSWORD=postgres
export KAFKA_BROKERS=localhost:9092
export KAFKA_TOPIC=entity-events
export KAFKA_GROUP_ID=ror-starter-group
```

Prepare DB:

```bash
bundle exec rails db:prepare
```

Run API server:

```bash
bundle exec rails server
```

Run Kafka consumer (separate terminal):

```bash
bundle exec rails kafka:consume
```

## 4) Run with Docker Compose

```bash
docker compose up --build
```

This starts:
- `app` on `http://localhost:3000`
- `db` (PostgreSQL)
- `kafka` (Redpanda, Kafka-compatible)

## 5) Interface usage

### REST read

```bash
curl http://localhost:3000/entities
```

### REST write (async enqueue)

```bash
curl -X POST http://localhost:3000/entities \
  -H "Content-Type: application/json" \
  -d '{"entity":{"name":"Sample","description":"Created via REST"}}'
```

### GraphQL read

```bash
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"{ entities { id name description } }"}'
```

### GraphQL write (async enqueue)

```bash
curl -X POST http://localhost:3000/graphql \
  -H "Content-Type: application/json" \
  -d '{"query":"mutation { createEntity(input: { name: \"Sample\", description: \"Created via GraphQL\" }) { status } }"}'
```

## 6) How data flow works

1. REST/GraphQL write endpoints publish Protobuf bytes to Kafka.
2. Consumer reads Kafka messages.
3. Consumer decodes Protobuf and writes `Entity` records to PostgreSQL.
4. REST/GraphQL read endpoints query PostgreSQL via Active Record.

## 7) Rails concepts highlighted in this scaffold

- **Convention over configuration**: Rails autoloads classes by path (`app/services/...`).
- **Active Record**: `Entity < ApplicationRecord` maps directly to `entities` table.
- **Strong Parameters**: controller whitelists accepted fields with `permit`.
- **Routing DSL**: `resources :entities` creates RESTful route helpers.
- **Rake task integration**: `rails kafka:consume` wires background consumer behavior.

## 8) Tests

Run all tests:

```bash
bundle exec rails test
```

Included tests cover:
- REST interface behavior
- GraphQL interface behavior
- Kafka consumer payload-to-database behavior
- basic model validation
