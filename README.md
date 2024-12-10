# MySQL Bulk Importer

**A simple shell script to bulk create and import multiple MySQL databases from gzipped SQL backups.**

## Overview

`mysql-bulk-importer` is a straightforward utility that automates the process of restoring multiple MySQL databases from `.sql.gz` backup files. If you've got a bunch of gzipped SQL dumps following a predictable naming pattern, this script will:

- Prompt for your MySQL root password once.
- Automatically detect database names from filenames.
- Create databases if they don't exist.
- Import each SQL dump into its corresponding database.

This is especially useful for bulk migrations, automated restore tasks, or development environments where you need to recreate multiple databases quickly.

## Requirements

- **MySQL/MariaDB Server**: The script uses standard MySQL command-line tools.
- **Bash Shell**: Common in most UNIX/Linux-like environments.
- **Gzip**: For decompressing `.sql.gz` files.
- **MySQL Credentials**: You need MySQL root access or another user with `CREATE DATABASE` and full import permissions.

## File Naming Convention

Your backup files should follow this pattern:

```
sql\_<dbname>\_YYYYMMDD\_HHMMSS.sql.gz
```

**Examples:**
- `sql_myapp_20241210_093000.sql.gz`
- `sql_anotherdb_20240101_120500.sql.gz`

The script extracts `<dbname>` from the filename. The final database name will retain the `sql_` prefix. For example, `sql_myapp_20241210_093000.sql.gz` becomes a database named `sql_myapp`.

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/syntaxsurge/mysql-bulk-importer.git
   cd mysql-bulk-importer
   ```

2.  **Make the Script Executable:**
    ```bash
    chmod +x bulk_import.sh
    ```

## Usage

1.  **Place Your Backups:** Move your `.sql.gz` backup files into the directory where the script resides (or adjust `cd` command inside the script to point to the directory containing the backups).
    
2.  **Run the Script:**
    
    ```bash
    ./bulk_import.sh
    ```
    
    Enter the MySQL root password when prompted. The script will then:
    *   Detect each database name.
    *   Create the database if missing.
    *   Import the corresponding `.sql.gz` file.

3.  **Verify the Results:** After the script finishes, log into MySQL and ensure the databases and tables are present:
    
    ```bash
    mysql -u root -p
    SHOW DATABASES;
    USE sql_myapp;  # Example
    SHOW TABLES;
    ```
    

## Customization

*   **MySQL User & Credentials:**  
    Change the `-u root` and adjust password handling if using a different user.  
    You can also hardcode credentials or use a `.my.cnf` file for non-interactive imports.
    
*   **Database Name Extraction Logic:**  
    If your filenames differ, modify the `sed` command in `bulk_import.sh` to correctly parse the database name.
    
*   **Directory Paths:**  
    Update the `cd /www/backup/database` line in `bulk_import.sh` if your backups are stored elsewhere.
    

## License

This project is licensed under the [MIT License](LICENSE).

* * *

**Happy importing!**
