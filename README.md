# MantisBT Docker Setup

This directory contains Docker configuration to run MantisBT with MySQL in containers.

## Quick Start

```bash
# Build and start all services
make install

# Access MantisBT at http://localhost:8000
# Complete the web-based installation
```

## What's Included

- **MantisBT**: PHP 8.0 with Apache on port 8000
- **MySQL 8.0**: Database server on port 3306
- **Pre-configured**: Database connection settings already configured
- **Persistent storage**: Database and uploads are preserved between restarts

## Database Configuration

The Docker setup includes pre-configured database settings:

- **Host**: mysql (container name)
- **Database**: mantisbt
- **Username**: mantisbt  
- **Password**: mantisbt_password
- **Root password**: root_password

## Available Commands

```bash
make help        # Show all available commands
make build       # Build the Docker image  
make up          # Start all services
make down        # Stop all services
make restart     # Restart all services
make logs        # View all logs
make logs-app    # View MantisBT logs only
make logs-db     # View MySQL logs only
make shell-app   # Open shell in MantisBT container
make shell-db    # Open MySQL command line
make status      # Show container status
make backup      # Backup database to backup.sql
make restore     # Restore database from backup.sql
make clean       # Remove containers (keeps data)
make clean-all   # Remove everything including data
```

## Installation Process

1. **Start services**: `make install`
2. **Wait for database**: Monitor with `make logs-db` until ready
3. **Open browser**: Go to http://localhost:8000
4. **Run installer**: Follow the web-based setup wizard
5. **Database settings**: Already configured, just click through
6. **Create admin account**: Set up your administrator user

## File Structure

```
├── Dockerfile              # MantisBT container definition
├── docker-compose.yml      # Multi-container setup
├── Makefile               # Management commands
├── .dockerignore          # Files excluded from build
└── docker/
    └── mysql-init/
        └── 01-init.sql    # Database initialization
```

## Security Notes

- **Change passwords**: Update database passwords for production use
- **Remove admin directory**: The installer will remind you to remove `/admin` after setup
- **SSL**: Consider adding SSL termination for production deployments
- **Firewall**: Restrict port access as needed

## Troubleshooting

- **Container won't start**: Check logs with `make logs`
- **Database connection failed**: Ensure MySQL container is ready with `make logs-db`
- **Permission issues**: The containers run as www-data user
- **Port conflicts**: Change port mappings in docker-compose.yml if needed

## Data Persistence

- **Database**: Stored in Docker volume `mysql_data`
- **Uploads**: Stored in Docker volume `mantisbt_uploads`
- **Configuration**: Mounted from local `config/` directory

To completely remove all data: `make clean-all` (⚠️ This deletes everything!)