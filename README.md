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

1. Install VS Code if you haven't already: [Visual Studio Code](https://code.visualstudio.com/)

2. Install the "Database Client" extension:
   - Go to Extensions (Ctrl+Shift+X or Cmd+Shift+X)
   - Search for "Database Client" by Weijan Chen
   - Click Install

3. Configure Database Connection:
   - Click on the Database icon in the activity bar
   - Click the "+" button to add a new connection
   - Select MySQL
   - Enter your connection details:
     - Name: Transaction Demo
     - Host: 127.0.0.1
     - Port: 3306
     - Username: root (or your created user)
     - Password: (your password)
   - Click Connect

### 5. Running the SQL Scripts

1. **Initialize the Database:**
   - Open `main.sql` in VS Code
   - With the Database Client extension connected, click the "Run Current File" button or use the keyboard shortcut (usually F9)
   - This will create the database, tables, and stored procedures

2. **Run the Test Transactions:**
   - Open `test_transactions.sql` in VS Code
   - Click "Run Current File" again
   - You should see the results of each transaction test in the results panel

3. **Alternative Method:**
   - Right-click on the SQL file in the Explorer panel
   - Select "Run SQL File" or "Execute Current File"
   - The extension will execute the entire file

4. **Using Command Palette:**
   - Press F1 or Ctrl+Shift+P
   - Type "execute" or "run sql"
   - Select the option to execute the current file
