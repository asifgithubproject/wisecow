#!/bin/bash
# ------------------------------------------------------------------
# File: /usr/local/bin/health_monitor.sh
# Description: Monitors Linux system health (CPU, Memory, Disk, Processes)
# Logs alerts if thresholds are exceeded with log rotation
# Keeps last 10 rotated logs
# ------------------------------------------------------------------

# ---------- Configuration ----------
CPU_THRESHOLD=80           # CPU usage percentage
MEMORY_THRESHOLD=80        # Memory usage percentage
DISK_THRESHOLD=80          # Disk usage percentage for root '/'
PROCESS_THRESHOLD=300      # Number of running processes

LOG_FILE="/home/ubuntu/logs/system_health.log"
MAX_LOG_SIZE=10485760      # 10MB in bytes
MAX_LOGS=10                # Keep last 10 rotated logs
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# ---------- Helper Functions ----------
rotate_log() {
    if [ -f "$LOG_FILE" ]; then
        LOG_SIZE=$(stat -c%s "$LOG_FILE")
        if [ "$LOG_SIZE" -ge "$MAX_LOG_SIZE" ]; then
            mv "$LOG_FILE" "$LOG_FILE.$(date '+%Y%m%d%H%M%S')"
            touch "$LOG_FILE"
            
            # Delete older logs beyond last $MAX_LOGS
            ls -1t ${LOG_FILE}.* 2>/dev/null | tail -n +$((MAX_LOGS+1)) | xargs -r rm -f
        fi
    else
        touch "$LOG_FILE"
    fi
}

log_alert() {
    local message="$1"
    echo "[$DATE] ALERT: $message" >> "$LOG_FILE"
}

log_info() {
    local message="$1"
    echo "[$DATE] INFO: $message" >> "$LOG_FILE"
}

# ---------- Rotate Log if Needed ----------
rotate_log

# ---------- CPU Usage Check ----------
CPU_USAGE=$(mpstat 1 1 | awk '/Average/ {printf "%.0f", 100-$NF}')
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_alert "High CPU usage detected: ${CPU_USAGE}%"
else
    log_info "CPU usage is normal: ${CPU_USAGE}%"
fi

# ---------- Memory Usage Check ----------
MEMORY_USAGE=$(free | awk '/Mem/ {printf "%.0f", $3/$2 * 100}')
if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    log_alert "High Memory usage detected: ${MEMORY_USAGE}%"
else
    log_info "Memory usage is normal: ${MEMORY_USAGE}%"
fi

# ---------- Disk Usage Check ----------
DISK_USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_alert "High Disk usage detected: ${DISK_USAGE}% on /"
else
    log_info "Disk usage is normal: ${DISK_USAGE}% on /"
fi

# ---------- Running Processes Check ----------
PROCESS_COUNT=$(ps -e --no-headers | wc -l)
if [ "$PROCESS_COUNT" -gt "$PROCESS_THRESHOLD" ]; then
    log_alert "High number of running processes detected: ${PROCESS_COUNT}"
else
    log_info "Number of running processes is normal: ${PROCESS_COUNT}"
fi

# ---------- Script Completed ----------
echo "[$DATE] Health check completed." >> "$LOG_FILE"
