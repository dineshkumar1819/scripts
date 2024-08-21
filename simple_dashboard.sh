#!/bin/bash

# Function to display CPU usage
show_cpu() {
    echo "CPU Usage:"
    top -bn1 | grep "Cpu(s)"
}

# Function to display memory usage
show_memory() {
    echo "Memory Usage:"
    free -h
}

# Function to display network statistics
show_network() {
    echo "Network Statistics:"
    netstat -i
}

# Function to display disk usage
show_disk() {
    echo "Disk Usage:"
    df -h
}

# Display all information
show_all() {
    echo "Full Dashboard:"
    show_cpu
    echo
    show_memory
    echo
    show_network
    echo
    show_disk
    echo
}

# Main script logic
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 {-cpu|-memory|-network|-disk|-all} [interval]"
    exit 1
fi

# Interval for refreshing the data
interval=5
if [ "$2" ]; then
    interval=$2
fi

while true; do
    case $1 in
        -cpu)
            show_cpu
            ;;
        -memory)
            show_memory
            ;;
        -network)
            show_network
            ;;
        -disk)
            show_disk
            ;;
        -all)
            show_all
            ;;
        *)
            echo "Invalid option. Use -cpu, -memory, -network, -disk, or -all."
            exit 1
            ;;
    esac
    sleep $interval
done

