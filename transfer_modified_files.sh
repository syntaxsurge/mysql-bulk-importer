#!/bin/bash

# ---------------------------------------------------
# Constants for Customization
# ---------------------------------------------------
SOURCE_DIR="/www/backup/database"     # Source directory containing the files
DEST_SERVER="root@1.1.1.1"            # Destination server (user@host)
DEST_PATH="/www/backup/database"      # Destination directory on the remote server
MODIFIED_DATE="Jan 16 2025"           # Date of the files to transfer (format: 'Mon DD YYYY')
LOG_FILE="/www/wwwlogs/rsync_transfer.log"
# ---------------------------------------------------

echo "Starting file transfer for files modified on: $MODIFIED_DATE"

# Change to the source directory so files are listed relative to it.
cd "$SOURCE_DIR" || {
  echo "ERROR: Could not change to $SOURCE_DIR. Exiting..."
  exit 1
}

# Explanation:
# 1. `find . -maxdepth 1 -type f ...` finds files **in this directory** that match the date range.
# 2. `-print0` produces a null-terminated list (safely handles filenames with spaces).
# 3. `rsync -avz -vv --progress --files-from=- --from0 . "$DEST_SERVER:$DEST_PATH"`
#    reads the list from stdin, uses the current directory (.) as the source for those files, 
#    and transfers them to DEST_SERVER:DEST_PATH.
# 4. `2>&1 | tee "$LOG_FILE"` captures both stdout and stderr, logging them to the console and the LOG_FILE.
# 5. We use `${PIPESTATUS[1]}` to check rsync's exit code (the second command in the pipeline).

find . -maxdepth 1 -type f \
  -newermt "$MODIFIED_DATE 00:00:00" \
  ! -newermt "$MODIFIED_DATE 23:59:59" \
  -print0 | \
rsync -avz -vv --progress \
      --files-from=- --from0 \
      . "$DEST_SERVER:$DEST_PATH" \
      2>&1 | tee "$LOG_FILE"

# Check the exit status of rsync (second command in the pipeline)
if [ ${PIPESTATUS[1]} -eq 0 ]; then
    echo "File transfer completed successfully."
    echo "Logs can be found at: $LOG_FILE"
else
    echo "File transfer failed. Check logs at $LOG_FILE for details."
fi