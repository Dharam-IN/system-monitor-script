#!/bin/bash

source "$(dirname "$0")/config.sh"
mkdir -p "$LOG_DIR"

# --- disk block  → diskusage ---
diskusage=$(df | grep "/$" | awk '{print $5}' | tr -d "%")




# --- cpu block   → cpuusage  (the /proc/stat two-reading + sleep math) ---
totalcpu1=$(cat /proc/stat | head -1 | awk '{print $2+$3+$4+$5+$6+$7+$8+$9+$10+$11}')
idlecpu1=$(cat /proc/stat | head -1 | awk '{print $5}')
sleep 1
totalcpu2=$(cat /proc/stat | head -1 | awk '{print $2+$3+$4+$5+$6+$7+$8+$9+$10+$11}')
idlecpu2=$(cat /proc/stat | head -1 | awk '{print $5}')

totalcpuminus=$((totalcpu2 - totalcpu1))
totalidleminus=$((idlecpu2 - idlecpu1))

totalusage=$((totalcpuminus - totalidleminus))
cpuusage=$((100 * totalusage / totalcpuminus))





# --- memory block → memusage ---
memusage=$(free | awk '/Mem/ {print int($3/$2*100)}')

check() {
if [ "$1" -gt "$THRESHOLD" ]
then
	echo "Warning: $2 is $1"
else
	echo "$2 Is Healthy"
fi
}

check "$diskusage" "Disk Usage"
check "$cpuusage" "CPU Usage"
check "$memusage" "Memory Usage"
echo "$(date '+%Y-%m-%d %H:%M:%S') disk=$diskusage% cpu=$cpuusage% mem=$memusage%" >> "$LOG_DIR/monitor.log"