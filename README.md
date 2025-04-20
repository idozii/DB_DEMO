# Transaction Demo Database

This project demonstrates database transaction concepts (ACID properties) using MySQL with a sample e-commerce database schema. It includes SQL scripts for creating tables, stored procedures, and tests for demonstrating transaction behavior.

## Files in this Project

- `main.sql` - Creates the database schema, tables, and stored procedures
- `test_transactions.sql` - Script to test the various transaction scenarios

## Setup Instructions

### 1. Install MySQL Server

#### On Ubuntu/Debian

```bash
sudo apt update
sudo apt install mysql-server
sudo systemctl start mysql
sudo systemctl enable mysql
```

#### On macOS

```bash
brew install mysql
brew services start mysql
```

#### On Windows

Download and install MySQL from MySQL Official Website

### 2. Secure MySQL Installation

```bash
sudo mysql_secure_installation
```

Follow the prompts to set a root password and secure your installation.

### 3. Create a Database User (Optional but Recommended)

```bash
sudo mysql -u root -p
```

Then in MySQL prompt:

```sql
CREATE USER 'demo_user'@'localhost' IDENTIFIED BY 'your_password';
GRANT ALL PRIVILEGES ON *.* TO 'demo_user'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 4. Setting up VS Code with Database Client Extension
