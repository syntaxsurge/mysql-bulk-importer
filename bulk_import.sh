#!/bin/bash

# Change to the directory containing your backups
cd /www/backup/database

# Prompt for password once
echo -n "Enter MySQL root password: "
read -s MYSQL_PWD
echo

# Process all matching files
for file in sql_*.sql.gz; do
    # Extract database name (retain the sql_ prefix)
    dbname=$(echo "$file" | sed -r 's/_[0-9]{8}_[0-9]{6}\.sql\.gz$//')
    
    echo "Processing file: $file"
    echo "Detected database name: $dbname"

    # Create the database if it doesn't exist
    mysql -u root -p"$MYSQL_PWD" -e "CREATE DATABASE IF NOT EXISTS \`$dbname\`;"

    # Import the SQL dump into the database
    gunzip < "$file" | mysql -u root -p"$MYSQL_PWD" "$dbname"

    echo "Imported $file into database: $dbname"
done

echo "All imports completed successfully."
