#!/bin/bash

#!/bin/bash

# Function to get CPU usage
get_cpu_usage() {
    cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}')
    # Ensure we have a valid number before calculation
    if [[ $cpu_idle =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        cpu_usage=$(( 100 - ${cpu_idle%.*} ))
        echo $cpu_usage
    else
        echo 0
    fi
}

# Function to get memory usage
get_memory_usage() {
    memory_info=$(free | grep Mem)
    total_memory=$(echo $memory_info | awk '{print $2}')
    used_memory=$(echo $memory_info | awk '{print $3}')
    memory_usage=$(( (used_memory * 100) / total_memory ))
    echo $memory_usage
}

# Function to get disk usage
get_disk_usage() {
    disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    echo $disk_usage
}

# Get all metrics
cpu_usage=$(get_cpu_usage)
memory_usage=$(get_memory_usage)
disk_usage=$(get_disk_usage)

# Check health status
threshold=60
is_healthy=true
issues=()

if (( cpu_usage > threshold )); then
    is_healthy=false
    issues+=("CPU usage is high: ${cpu_usage}%")
fi

if (( memory_usage > threshold )); then
    is_healthy=false
    issues+=("Memory usage is high: ${memory_usage}%")
fi

if (( disk_usage > threshold )); then
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
