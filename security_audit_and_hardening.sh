#!/bin/bash

# Function to check service status
check_service_status() {
    services=("httpd" "sshd" "network" "crond" "firewalld")

    echo "Checking service statuses:"
    for service in "${services[@]}"; do
        systemctl is-active --quiet $service
        if [ $? -eq 0 ]; then
            echo "$service is running."
        else
            echo "$service is not running."
        fi
    done
}

# Function to check system registration
check_system_registration() {
    if [ -x "$(command -v subscription-manager)" ]; then
        subscription-manager status
    else
        echo "subscription-manager is not installed."
    fi
}

# Function to check firewall rules
check_firewall_rules() {
    if [ -x "$(command -v firewall-cmd)" ]; then
        echo "Current firewall rules:"
        firewall-cmd --list-all
    else
        echo "firewalld is not installed or not running."
    fi
}

# Function to display system and network information
display_system_network_info() {
    echo "System Information:"
    uname -a

    echo "Network Interfaces:"
    ip addr show
}

# Function to classify IP addresses as public or private
classify_ip_addresses() {
    interfaces=$(ip -br addr show | awk '{print $1}')
    
    echo "Classifying IP addresses as public or private:"
    for interface in $interfaces; do
        ip_addresses=$(ip -o -4 addr show $interface | awk '{print $4}')
        for ip in $ip_addresses; do
            IFS='/' read -r address netmask <<< "$ip"
            IFS='.' read -r i1 i2 i3 i4 <<< "$address"
            case $i1 in
                10)
                    echo "$address is a private IP address."
                    ;;
                172)
                    if [ $i2 -ge 16 ] && [ $i2 -le 31 ]; then
                        echo "$address is a private IP address."
                    else
                        echo "$address is a public IP address."
                    fi
                    ;;
                192)
                    if [ $i2 -eq 168 ]; then
                        echo "$address is a private IP address."
                    else
                        echo "$address is a public IP address."
                    fi
                    ;;
                *)
                    echo "$address is a public IP address."
                    ;;
            esac
        done
    done
}

# Execute functions
check_service_status
check_system_registration
check_firewall_rules
display_system_network_info
classify_ip_addresses

