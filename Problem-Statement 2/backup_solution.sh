#!/bin/bash

# ---------- Configuration ----------
SOURCE_DIR="/path/to/source"                
REMOTE_USER="backupuser"                    
REMOTE_HOST="backup-server-ip-or-hostname"  
REMOTE_DIR="/tmp/other-system-backup"       
REPORT_DIR="/home/ubuntu/backup-reports"
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
REPORT_FILE="${REPORT_DIR}/backup_report_${DATE}.log"
SSH_OPTIONS="-o StrictHostKeyChecking=no -o ConnectTimeout=10"

# ---------- Ensure report directory exists ----------
mkdir -p "$REPORT_DIR"

# ---------- Start Backup ----------
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting backup of $SOURCE_DIR to $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" >> "$REPORT_FILE"

# ---------- Perform Backup Using rsync ----------
rsync -avz -e "ssh $SSH_OPTIONS" "$SOURCE_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR" >> "$REPORT_FILE" 2>&1
BACKUP_STATUS=$?

# ---------- Check Backup Status ----------
if [ $BACKUP_STATUS -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup completed successfully." >> "$REPORT_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup FAILED! Check the log above for details." >> "$REPORT_FILE"
fi

# ---------- Optional: Keep only last 10 reports ----------
ls -1t ${REPORT_DIR}/backup_report_*.log 2>/dev/null | tail -n +11 | xargs -r rm -f

# ---------- Script Completed ----------
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Backup script finished." >> "$REPORT_FILE"
