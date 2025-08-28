# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

MantisBT (Mantis Bug Tracker) is a web-based PHP bug tracking system using MySQL, PostgreSQL, or other supported databases. This is a mature codebase following traditional PHP architecture patterns.

## Development Commands

### Testing
- **Run all tests**: `phpunit` (uses phpunit.xml configuration)
- **Test suites available**:
  - `phpunit --testsuite=mantis` - Core MantisBT tests
  - `phpunit --testsuite=soap` - SOAP API tests  
  - `phpunit --testsuite=rest` - REST API tests
  - `phpunit --testsuite="mantis core formatting"` - Plugin tests

### Scripts
- **Send emails asynchronously**: `php scripts/send_emails.php`
- **Cron job runner**: `php scripts/cronjob.php`

## Architecture Overview

### Core Structure
- **Entry point**: `core.php` - initializes MantisBT, connects to database, starts plugins
- **Configuration**: 
  - `config_defaults_inc.php` - default values (don't modify)
  - `config/config_inc.php` - custom overrides (copy from config_inc.php.sample)
- **APIs**: All functionality organized in `core/*_api.php` files
- **Pages**: Viewable pages end with `_page.php`, include files with `_inc.php`

### Key Directories
- `api/` - SOAP and REST API endpoints
- `core/` - Core library functions and classes
- `plugins/` - Plugin system (Gravatar, MantisCoreFormatting, MantisGraph, XmlImportExport)
- `admin/` - Installation and administration tools (remove on production)
- `lang/` - Internationalization files
- `css/`, `js/`, `fonts/`, `images/` - Frontend assets

### Naming Conventions
- Global variables: `g_` prefix
- Function parameters: `p_` prefix (shouldn't be modified)
- Form variables: `f_` prefix
- Database-cleaned variables: `c_` prefix  
- Temporary variables: `t_` prefix
- Count variables: include "count" in name

### Database & Installation
- **Check compatibility**: Point browser to `admin/check/index.php`
- **Install/upgrade**: Point browser to `admin/install.php`
- **Requirements**: PHP 7.4.0+, MySQL 5.5.35+/PostgreSQL 9.2+

### Plugin System
MantisBT uses a plugin architecture with several core plugins included. Plugin files are organized under `plugins/[PluginName]/`.

## Docker Setup

### Commands
- **Build image**: `make build` 
- **Start services**: `make up` or `make install` (includes build)
- **Stop services**: `make down`
- **View logs**: `make logs`, `make logs-app`, `make logs-db`
- **Container shell**: `make shell-app`, `make shell-db`
- **Status check**: `make status`

### Configuration
- **Port**: MantisBT runs on port 8000 (changed from 8080 to avoid proxy conflicts)
- **Database**: Pre-configured connection to MySQL container
- **Access URLs**: 
  - Main: http://localhost:8000
  - Installer: http://localhost:8000/admin/install.php
  - System check: http://localhost:8000/admin/check/index.php

### Known Issues
- Build may fail if system has proxy on port 8080 - solution implemented by using port 8000
- Admin directory included in build (commented out in .dockerignore) for installation
- PHP extensions limited to essential ones (mysqli, pdo_mysql) due to network restrictions