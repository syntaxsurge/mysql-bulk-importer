# MySQL Bulk Importer

A simple shell script to bulk create and import multiple MySQL databases from gzipped SQL backups, along with an additional utility to transfer files based on their modified date.

## Overview

`mysql-bulk-importer` is a straightforward utility that automates the process of restoring multiple MySQL databases from `.sql.gz` backup files. If you've got a bunch of gzipped SQL dumps following a predictable naming pattern, this script will:

- Prompt for your MySQL root password once.
- Automatically detect database names from filenames.
- Create databases if they don't exist.
- Import each SQL dump into its corresponding database.

Additionally, the utility includes a **file transfer script** to copy files modified on a specific date to another server using `rsync`. This is particularly helpful for transferring recently created or updated database backups to a remote server for safe storage or further processing.

These features are especially useful for bulk migrations, automated restore tasks, or development environments where you need to recreate and transfer multiple databases quickly.

---

## Requirements

### For Database Import
- **MySQL/MariaDB Server**: The script uses standard MySQL command-line tools.
- **Bash Shell**: Common in most UNIX/Linux-like environments.
- **Gzip**: For decompressing `.sql.gz` files.
- **MySQL Credentials**: You need MySQL root access or another user with `CREATE DATABASE` and full import permissions.

### For File Transfer
- **Rsync**: The script uses `rsync` to transfer files.
- **SSH Access**: Ensure you have SSH access to the destination server.
- **Bash Shell**: Required for executing the file transfer script.

---

## File Naming Convention

Your backup files should follow this pattern:

```
sql_<dbname>_YYYYMMDD_HHMMSS.sql.gz
```

### Examples:
- `sql_myapp_20241210_093000.sql.gz`
- `sql_anotherdb_20240101_120500.sql.gz`

The script extracts `<dbname>` from the filename. The final database name will retain the `sql_` prefix. For example, `sql_myapp_20241210_093000.sql.gz` becomes a database named `sql_myapp`.

---

## Installation

### Clone the Repository:
```bash
git clone https://github.com/syntaxsurge/mysql-bulk-importer.git
cd mysql-bulk-importer
```

### Make the Scripts Executable:
```bash
chmod +x bulk_import.sh
chmod +x transfer_modified_files.sh
```

---

## Usage

### 1. Bulk Import Databases
1. **Place Your Backups**: Move your `.sql.gz` backup files into the directory where the script resides (or adjust the `cd` command inside the script to point to the directory containing the backups).

2. **Run the Script**:
    ```bash
    ./bulk_import.sh
    ```

3. **Enter MySQL Credentials**: Enter the MySQL root password when prompted. The script will:
   - Detect each database name.
   - Create the database if missing.
   - Import the corresponding `.sql.gz` file.

4. **Verify the Results**: After the script finishes, log into MySQL and ensure the databases and tables are present:
    ```sql
    mysql -u root -p
    SHOW DATABASES;
    USE sql_myapp;  # Example
    SHOW TABLES;
    ```

### 2. Transfer Files Based on Modified Date
1. **Prepare Files**: Ensure your files are in the correct directory (`/www/backup/database` by default).

2. **Customize the Script**: Open the `transfer_modified_files.sh` script and update the following constants:
   - `SOURCE_DIR`: The directory containing the files.
   - `DEST_SERVER`: The remote server in `user@hostname` format.
   - `DEST_PATH`: The destination path on the server.
   - `MODIFIED_DATE`: The specific date to filter files (e.g., `Jan 16 2025`).

3. **Run the Script**:
    ```bash
    ./transfer_modified_files.sh
    ```

4. **Verify the Transfer**: Check the destination server to confirm the files were copied successfully.

---

## Customization

### MySQL User & Credentials
- Change the `-u root` and adjust password handling if using a different user.
- You can also hardcode credentials or use a `.my.cnf` file for non-interactive imports.

### Database Name Extraction Logic
- If your filenames differ, modify the `sed` command in `bulk_import.sh` to correctly parse the database name.

### File Transfer Script
- **Directory Paths**: Update the `SOURCE_DIR` and `DEST_PATH` constants in `transfer_modified_files.sh` as needed.
- **Date Filter**: Adjust `MODIFIED_DATE` in `transfer_modified_files.sh` to filter files based on their modified date.

---

## License

This project is licensed under the [MIT License](LICENSE).

---

Happy importing and transferring! 🎉
