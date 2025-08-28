# MantisBT Docker Makefile
# Provides convenient commands for managing the MantisBT Docker environment

.PHONY: help build up down restart logs shell-app shell-db clean install status backup restore download-sources extract-sources admin-info

# Default target
help:
	@echo "MantisBT Docker Management"
	@echo "=========================="
	@echo ""
	@echo "Available commands:"
	@echo "  build     - Build the MantisBT Docker image"
	@echo "  up        - Start all services"
	@echo "  down      - Stop all services"
	@echo "  restart   - Restart all services"
	@echo "  logs      - Show logs from all services"
	@echo "  logs-app  - Show logs from MantisBT application only"
	@echo "  logs-db   - Show logs from MySQL database only"
	@echo "  shell-app - Open shell in MantisBT container"
	@echo "  shell-db  - Open MySQL shell"
	@echo "  status    - Show status of all containers"
	@echo "  clean     - Remove containers and images (keeps volumes)"
	@echo "  clean-all - Remove everything including volumes (DANGER!)"
	@echo "  install   - First-time setup (build + up + show access info)"
	@echo "  backup    - Backup database to backup.sql"
	@echo "  restore   - Restore database from backup.sql"
	@echo "  download-sources - Download latest MantisBT sources from SourceForge"
	@echo "  extract-sources  - Download and extract MantisBT sources to sources/ directory"
	@echo "  admin-info - Show default administrator credentials"
	@echo ""
	@echo "URLs after startup:"
	@echo "  MantisBT: http://localhost:8000"
	@echo "  MySQL: localhost:3306 (user: mantisbt, password: mantisbt_password)"

# Build the Docker image
build: extract-sources
	@echo "Building MantisBT Docker image..."
	docker-compose build --no-cache

# Start all services
up:
	@echo "Starting MantisBT services..."
	docker-compose up -d
	@echo ""
	@echo "Services started! MantisBT will be available at http://localhost:8000"
	@echo "It may take a moment for the database to initialize..."

# Stop all services
down:
	@echo "Stopping MantisBT services..."
	docker-compose down

# Restart all services
restart: down up

# Show logs from all services
logs:
	docker-compose logs -f

# Show logs from MantisBT app only
logs-app:
	docker-compose logs -f mantisbt

# Show logs from MySQL only  
logs-db:
	docker-compose logs -f mysql

# Open shell in MantisBT container
shell-app:
	docker-compose exec mantisbt /bin/bash

# Open MySQL shell
shell-db:
	docker-compose exec mysql mysql -u mantisbt -pmantisbt_password mantisbt

# Show container status
status:
	@echo "Container Status:"
	@echo "=================="
	docker-compose ps
	@echo ""
	@echo "Docker Images:"
	@echo "==============="
	docker images | grep -E "(mantisbt|mysql)"

# Remove containers and images (keep volumes)
clean:
	@echo "Stopping and removing containers..."
	docker-compose down
	@echo "Removing MantisBT image..."
	docker rmi mantisbt-2271_mantisbt 2>/dev/null || true
	@echo "Cleanup complete. Volumes preserved."

# Remove everything including volumes (DANGEROUS!)
clean-all:
	@echo "WARNING: This will remove ALL data including the database!"
	@read -p "Are you sure? (y/N): " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		docker-compose down -v; \
		docker rmi mantisbt-2271_mantisbt 2>/dev/null || true; \
		echo "Complete cleanup done."; \
	else \
		echo "Cleanup cancelled."; \
	fi

# First-time installation
install: build up
	@echo ""
	@echo "🎉 MantisBT Docker installation complete!"
	@echo ""
	@echo "Next steps:"
	@echo "1. Wait for the database to initialize (check with 'make logs-db')"
	@echo "2. Open http://localhost:8000 in your browser"
	@echo "3. Follow the MantisBT installation wizard"
	@echo "4. Database connection is pre-configured:"
	@echo "   - Host: mysql"
	@echo "   - Database: mantisbt"  
	@echo "   - Username: mantisbt"
	@echo "   - Password: mantisbt_password"
	@echo ""
	@echo "Useful commands:"
	@echo "  make logs     - View all logs"
	@echo "  make restart  - Restart services"
	@echo "  make shell-app - Access app container"

# Backup database
backup:
	@echo "Creating database backup..."
	docker-compose exec mysql mysqldump -u mantisbt -pmantisbt_password mantisbt > backup.sql
	@echo "Database backed up to backup.sql"

# Restore database from backup
restore:
	@if [ ! -f backup.sql ]; then \
		echo "ERROR: backup.sql file not found!"; \
		exit 1; \
	fi
	@echo "Restoring database from backup.sql..."
	docker-compose exec -T mysql mysql -u mantisbt -pmantisbt_password mantisbt < backup.sql
	@echo "Database restored from backup.sql"

# Download latest MantisBT sources from SourceForge
download-sources: 
	@if [ -f mantisbt-latest.tar.gz ]; then \
		echo "File mantisbt-latest.tar.gz already exists, skipping download."; \
	else \
		echo "Downloading latest MantisBT sources from SourceForge..."; \
		curl -L -o mantisbt-latest.tar.gz "https://sourceforge.net/projects/mantisbt/files/latest/download"; \
		echo "Download complete: mantisbt-latest.tar.gz"; \
	fi
	@echo ""
	@echo "To extract the sources:"
	@echo "  tar -xzf mantisbt-latest.tar.gz"

# Download and extract MantisBT sources to sources/ directory
extract-sources: download-sources
	@if [ -z "$$(find sources/ -name '*.php' 2>/dev/null)" ]; then \
		echo "Extracting MantisBT sources..."; \
		rm -rf sources/; \
		mkdir -p sources/; \
		tar -xzf mantisbt-latest.tar.gz -C sources/ --strip-components=1; \
		echo "Sources extracted to sources/ directory"; \
		echo ""; \
		echo "MantisBT sources are now available in the sources/ directory"; \
	else \
		echo "PHP files already exist in sources/ directory, skipping extraction."; \
	fi

# Show default administrator credentials
admin-info:
	@echo "MantisBT Default Administrator Credentials"
	@echo "=========================================="
	@echo ""
	@echo "Username: administrator"
	@echo "Password: root"
	@echo ""
	@echo "⚠️  IMPORTANT: Change these credentials immediately after first login!"
	@echo ""
	@echo "After installation, you can log in at:"
	@echo "  http://localhost:8000/login_page.php"
