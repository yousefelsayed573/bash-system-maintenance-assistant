#!/bin/bash

echo "      System Maintenance Assistant"

# Part 1: Welcome Message
read -r -p "Enter your name: " NAME

if [ -z "$NAME" ]; then
    echo "Error: Name cannot be empty."
    exit 1
fi

echo "Hello, $NAME!"

# Part 2: Root Check
if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

echo "Root check passed."

# Part 3: Backup Folder Creation
CURRENT_DATE=$(date +%y-%m-%d)
BACKUP_DIR="/tmp/backup-$CURRENT_DATE"

if [ -d "$BACKUP_DIR" ]; then
    echo "Backup directory already exists: $BACKUP_DIR"
else
    mkdir -p "$BACKUP_DIR"
    echo "Backup directory created: $BACKUP_DIR"
fi

# Part 4: Source File Validation
read -r -p "Enter the source log file path: " SOURCE_FILE

if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file does not exist."
    exit 1
fi

if [ ! -s "$SOURCE_FILE" ]; then
    echo "Error: Source file is empty."
    exit 1
fi

echo "Source file is valid."

# Part 5: Backup Process
BACKUP_FILE="$BACKUP_DIR/$(basename "$SOURCE_FILE").bak"

cp "$SOURCE_FILE" "$BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "Backup successful: $BACKUP_FILE"
else
    echo "Error: Backup failed."
    exit 1
fi

# Part 6: Service Control
SERVICE="httpd"

case "$1" in

    start)
        systemctl start "$SERVICE"
        echo "$SERVICE started."
        ;;

    stop)
        systemctl stop "$SERVICE"
        echo "$SERVICE stopped."
        ;;

    restart)
        systemctl restart "$SERVICE"
        echo "$SERVICE restarted."
        ;;

    status)
        systemctl status "$SERVICE" --no-pager
        ;;

    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;

esac

echo "System maintenance task completed."
