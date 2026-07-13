# @epc-al-anifiyat/api-design

This is the API-first design workspace for the `epc-al-anifiyat` project. It contains the OpenAPI specifications and provides tools for linting, mocking, and viewing the API documentation.

## Features

- **OpenAPI 3.0 Specifications**: Single source of truth for the API surface (located in `src/console/openapi.yaml`).
- **Linting**: Ensures API quality and standard compliance using **Stoplight Spectral** and **Redocly CLI**.
- **Swagger UI**: Browse the API documentation interactively on a local web interface.
- **Prism Mock Server**: Spin up a mock server that simulates API responses based on the OpenAPI specs.

## Prerequisites

- [Node.js](https://nodejs.org/) and `pnpm`
- [Docker](https://www.docker.com/) and Docker Compose
- `make` (Make build automation tool)

## Getting Started

1. **Install dependencies**:
   ```bash
   pnpm install
   # or
   make install
   ```

2. **Start Everything (Docs + Mocks)**:
   This will spin up both the Swagger UI and the Prism mock server in Docker containers.
   ```bash
   make up
   ```
   - **Swagger UI**: Available at [http://localhost:8080](http://localhost:8080)
   - **Console Mock Server**: Available at [http://localhost:4010](http://localhost:4010)

## Available Commands

This workspace provides a `Makefile` to simplify common operations. Run `make help` to see all available commands.

### Linting
Validate the OpenAPI specifications against defined rules (via `.spectral.yaml` and Redocly defaults).
- `make lint` : Run all OpenAPI linters (Spectral & Redocly).
- `make lint-spectral` : Lint specs with Stoplight Spectral.
- `make lint-redocly` : Lint specs with Redocly CLI.

### Swagger UI
- `make swagger-ui` : Start the Swagger UI container only.
- `make swagger-ui-stop` : Stop the Swagger UI container.

### Mock Server
- `make console` : Start the Prism mock server for the console API.
- `make console-stop` : Stop the console mock server.

### Lifecycle Management
- `make up` : Start all services in detached mode.
- `make stop` : Stop all services (preserves containers for fast restart).
- `make down` : Stop and remove every container and network.
- `make restart` : Restart all services.
- `make logs` : Tail logs from running services.
- `make ps` : Show the status of running containers.
- `make clean` : Stop services and prune volumes/orphans.

## Architecture

```text
api-design/
├── src/
│   └── console/
│       └── openapi.yaml   # Main API specification
├── .spectral.yaml         # Spectral linting rules configuration
├── redocly.yaml           # Redocly linting/bundling configuration
├── docker-compose.yml     # Container setup for Swagger UI & Prism
└── Makefile               # Task runner for developers
```
