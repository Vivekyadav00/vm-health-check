#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    cpu_usage=$(echo "100 - $cpu_idle" | bc)
    printf "%.2f" $cpu_usage
}

# Function to get memory usage
get_memory_usage() {
    memory_info=$(free | grep Mem)
    total_memory=$(echo $memory_info | awk '{print $2}')
    used_memory=$(echo $memory_info | awk '{print $3}')
    memory_usage=$(echo "scale=2; ($used_memory / $total_memory) * 100" | bc)
    printf "%.2f" $memory_usage
}

# Function to get disk usage
get_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    printf "%.2f" $disk_usage
}

# Get all metrics
cpu_usage=$(get_cpu_usage)
memory_usage=$(get_memory_usage)
disk_usage=$(get_disk_usage)

# Check health status
threshold=60
is_healthy=true
issues=()

if (( $(echo "$cpu_usage > $threshold" | bc -l) )); then
    is_healthy=false
    issues+=("CPU usage is high: ${cpu_usage}%")
fi

if (( $(echo "$memory_usage > $threshold" | bc -l) )); then
    is_healthy=false
    issues+=("Memory usage is high: ${memory_usage}%")
fi

if (( $(echo "$disk_usage > $threshold" | bc -l) )); then
    is_healthy=false
    issues+=("Disk usage is high: ${disk_usage}%")
fi

# Output results
if [[ "$1" == "explain" ]]; then
    echo -e "\nCurrent Metrics:"
    echo "CPU Usage: ${cpu_usage}%"
    echo "Memory Usage: ${memory_usage}%"
    echo "Disk Usage: ${disk_usage}%"
    echo -e "\nHealth Status: $(if $is_healthy; then echo "HEALTHY"; else echo "NOT HEALTHY"; fi)"
    
    if ! $is_healthy; then
        echo -e "\nIssues Found:"
        for issue in "${issues[@]}"; do
            echo "- $issue"
        done
    fi
else
    echo "Health Status: $(if $is_healthy; then echo "HEALTHY"; else echo "NOT HEALTHY"; fi)"
fi
