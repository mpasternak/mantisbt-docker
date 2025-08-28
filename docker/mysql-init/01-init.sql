-- MantisBT MySQL initialization script
-- This script sets up the initial database configuration

-- Create database if it doesn't exist
CREATE DATABASE IF NOT EXISTS mantisbt DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges to the mantisbt user
GRANT ALL PRIVILEGES ON mantisbt.* TO 'mantisbt'@'%';
FLUSH PRIVILEGES;

-- Use the mantisbt database
USE mantisbt;

-- Set default charset and collation for better Unicode support
ALTER DATABASE mantisbt CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;