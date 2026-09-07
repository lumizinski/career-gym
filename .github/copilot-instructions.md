# Project Instructions

## Development environment

* Rails runs directly on the developer's machine.
* PostgreSQL runs inside Docker.
* Rails connects to PostgreSQL over TCP.
* PostgreSQL should normally be available at `127.0.0.1:5432`.
* Do not assume PostgreSQL is installed or running natively on the host.

## Database

PostgreSQL is the primary database.

Before diagnosing database errors, inspect:

* `config/database.yml`
* `compose.yml`
* environment variables
* Docker container status

If Rails attempts to connect to:

`/tmp/.s.PGSQL.5432`

check whether the connection is missing an explicit host.

## Engineering goals

This project is also being used as a backend engineering learning project.

Favor implementations that demonstrate strong knowledge of:

* PostgreSQL
* SQL
* Rails internals
* query optimization
* indexes
* N+1 detection
* transactions
* concurrency
* caching
* background jobs
* observability
* testing

When a performance optimization is made, whenever practical provide a before/after measurement.

## Development philosophy

Prefer simple solutions first.

Do not introduce microservices, complex infrastructure, or unnecessary abstractions unless there is a concrete requirement for them.

The application should remain easy to run locally and easy for another developer to understand.
