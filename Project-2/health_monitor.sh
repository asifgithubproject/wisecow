#!/bin/bash

# ---------- Thresholds ----------
CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=80
PROC_THRESHOLD=300   

# ---------- Log File ----------
LOG_FILE="/home/ubuntu/logs/system_health.log"

# ---------- Get Metrics ----------
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}' | cut -d. -f1)
MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
PROC_COUNT=$(ps aux | wc -l)

# ---------- Current Time ----------
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# ---------- Monitoring ----------
echo "[$DATE] Health Check Running..." >> $LOG_FILE

if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    echo "[$DATE] WARNING: CPU usage is at ${CPU_USAGE}%!" >> $LOG_FILE
fi

if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    echo "[$DATE] WARNING: Memory usage is at ${MEM_USAGE}%!" >> $LOG_FILE
fi

if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "[$DATE] WARNING: Disk usage is at ${DISK_USAGE}%!" >> $LOG_FILE
fi

if [ "$PROC_COUNT" -gt "$PROC_THRESHOLD" ]; then
    echo "[$DATE] WARNING: Process count is at ${PROC_COUNT}!" >> $LOG_FILE
fi

echo "[$DATE] Health Check Completed." >> $LOG_FILE
