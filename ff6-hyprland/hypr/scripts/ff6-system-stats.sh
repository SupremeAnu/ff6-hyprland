#!/bin/bash

# FF6 System Stats Script for Waybar
# This script outputs system stats in a format that resembles FF6 character stats

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}' | cut -d. -f1)
cpu_level=$((cpu_usage / 10 + 1))
if [ $cpu_level -gt 12 ]; then
    cpu_level=12
fi

# Get memory usage
mem_total=$(free -m | awk '/^Mem:/ {print $2}')
mem_used=$(free -m | awk '/^Mem:/ {print $3}')
mem_percent=$((mem_used * 100 / mem_total))
mem_level=$((mem_percent / 10 + 1))
if [ $mem_level -gt 12 ]; then
    mem_level=12
fi

# Get disk usage
disk_usage=$(df -h / | awk '/\// {print $(NF-1)}' | sed 's/%//')
disk_level=$((disk_usage / 10 + 1))
if [ $disk_level -gt 12 ]; then
    disk_level=12
fi

# Get network info
network_info=$(ip -o -4 addr show up primary scope global | awk '{print $4}' | cut -d/ -f1)
if [ -z "$network_info" ]; then
    network_info="Disconnected"
fi

# Get battery info if available
battery_percent="100"
if [ -d "/sys/class/power_supply/BAT0" ]; then
    battery_percent=$(cat /sys/class/power_supply/BAT0/capacity)
fi

# Format the output as JSON for Waybar
echo "{\"text\": \"$cpu_level $mem_used/$mem_total $mem_percent/$mem_total | $disk_level $disk_usage/$disk_usage | $mem_level $mem_percent/$mem_percent\", \"tooltip\": \"CPU: ${cpu_usage}%\\nMemory: ${mem_percent}%\\nDisk: ${disk_usage}%\\nNetwork: ${network_info}\\nBattery: ${battery_percent}%\"}"
