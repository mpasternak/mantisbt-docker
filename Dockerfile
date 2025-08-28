# Use official PHP with Apache - should work without proxy issues
FROM php:8.0-apache

# Configure and install only essential PHP extensions 
# (Skip system package installation due to proxy conflict)
RUN docker-php-ext-install mysqli pdo_mysql

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy MantisBT source code from extracted sources directory
COPY sources/ /var/www/html/

# Create config directory and set permissions
RUN mkdir -p /var/www/html/config \
    && chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Create MantisBT configuration file with Docker environment
RUN cat > /var/www/html/config/config_inc.php << 'EOF'
<?php
# MantisBT Docker Configuration

# Database Configuration
$g_hostname      = 'mysql';
$g_db_username   = 'mantisbt';
$g_db_password   = 'mantisbt_password';
$g_database_name = 'mantisbt';
$g_db_type       = 'mysqli';

# Security
$g_crypto_master_salt = 'docker-mantisbt-salt-change-in-production';

# Anonymous Access / Signup
$g_allow_signup = ON;
$g_allow_anonymous_login = OFF;
$g_anonymous_account = '';

# Email Configuration (basic setup)
$g_phpMailer_method = PHPMAILER_METHOD_MAIL;
$g_webmaster_email = 'webmaster@localhost';
$g_from_email = 'noreply@localhost';
$g_return_path_email = 'admin@localhost';

# File uploads
$g_allow_file_upload = ON;
$g_file_upload_method = DATABASE;
$g_max_file_size = 5000000;

# Branding
$g_window_title = 'MantisBT Docker';

# Default home page
$g_default_home_page = 'my_view_page.php';
EOF

# Set proper ownership
RUN chown www-data:www-data /var/www/html/config/config_inc.php

# Expose port 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]