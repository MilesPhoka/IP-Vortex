#!/bin/bash
# IP Vortex - Advanced IP Rotation Tool
# Version 1.2
# Author: Miles Phoka
# GitHub: https://github.com/MilesPhoka/ip-vortex

# Minimum rotation time (seconds)
MIN_ROTATION_TIME=10

# ASCII Art
display_banner() {
    echo -e "\e[38;5;39m"
    echo "██████████████████████████████████████████████████████████████████████████████████████  "
    echo "████      ██       ████████   ██████  ██████████████████████ █████████████████████████  "
    echo "██████  ████  ████  ████████  █████   █████████████████████  █████████████████████████  "
    echo "██████  ████  ████   ████████  ████  ███       ████      █   █  ██       ███   ██  ███  "
    echo "██████  ████        █████████   ██  ███  █████  ███  ██████  █████ █████  ███     ████  "
    echo "██████  ████  ████████     ███  ██  ███  █████  ███  ██████  ████         ████   █████  "
    echo "██████  ████  █████████████████ █  ████   ███   ███  ██████  █████  ████████   █   ███  "
    echo "████      ██  █████████████████   ███████     █████  ███████    ███       █   ███   ██  "
    echo "██████████████████████████████████████████████████████████████████████████████████████  "
    echo -e "\e[0m"
    echo -e "\e[1;36mIP-Vortex v1.2 - Digital Identity Rotation Engine\e[0m"
    echo -e "\e[38;5;202mCreated by Miles Phoka • https://github.com/MilesPhoka/IP-Vortex\e[0m"
    echo -e "\e[38;5;39m===============================================================\e[0m"
    echo
}

# Cleanup function to restore network on exit
cleanup() {
    echo -e "\n\e[33m[!] Cleaning up and restoring network...\e[0m"
    
    # Bring interface up if it's down
    if [[ -n "$INTERFACE" ]]; then
        sudo ip link set dev "$INTERFACE" up >/dev/null 2>&1
        
        # Get new lease
        echo "  Requesting new IP address..."
        sudo dhclient -v "$INTERFACE" >/dev/null 2>&1
        
        # Verify internet connectivity
        echo -n "  Verifying internet access: "
        if check_internet; then
            echo -e "\e[32mRestored\e[0m"
        else
            echo -e "\e[31mFailed - You may need to reconnect manually\e[0m"
        fi
    fi
    
    exit 0
}

# Check internet connectivity
check_internet() {
    if ping -c 1 -W 3 8.8.8.8 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Display help information
display_help() {
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -I, --interface <iface>  Specify network interface (e.g., wlan0, eth0)"
    echo "  -t, --time <seconds>     Rotate IP every X seconds (minimum: $MIN_ROTATION_TIME)"
    echo "  -m, --mac                Randomize MAC address during rotation"
    echo "  -v, --verbose            Show detailed output"
    echo "  -V, --version            Show version information"
    echo "  -s, --status             Show current network status"
    echo "  -u, --update             Check for updates"
    echo "  -h, --help               Display this help message"
    echo
    echo "Examples:"
    echo "  $0 -I wlan0              Rotate IP on wlan0"
    echo "  $0 -t 60 -m              Rotate every 60s with MAC randomization"
    echo "  $0 -V                    Show version"
    echo "  $0 -s                    Show current network status"
    echo
}

# Display version information
display_version() {
    echo "IP-Vortex version 1.2"
    echo "Author: Miles Phoka"
    echo "https://github.com/MilesPhoka/IP-Vortex"
    exit 0
}

# Check for updates
check_updates() {
    echo -e "\e[36m[+] Checking for updates...\e[0m"
    latest_version=$(curl -s https://raw.githubusercontent.com/MilesPhoka/ip-vortex/main/version.txt)
    if [[ "$latest_version" != "1.2" ]]; then
        echo -e "\e[33m[!] Update available! Version $latest_version is available.\e[0m"
        echo -e "Run: git pull https://github.com/MilesPhoka/ip-vortex.git"
    else
        echo -e "\e[32m[√] You're running the latest version.\e[0m"
    fi
    exit 0
}

# Show current network status
show_status() {
    detect_os
    detect_interfaces
    echo -e "\n\e[1;34m===== Current Network Status =====\e[0m"
    
    for iface in "${active_interfaces[@]}"; do
        echo -e "\n\e[1;32mInterface: $iface\e[0m"
        echo "--------------------------------"
        
        # IP Address
        ip_addr=$(ip -4 addr show "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
        [[ -z "$ip_addr" ]] && ip_addr="None"
        echo -e "IP Address:\t$ip_addr"
        
        # MAC Address
        mac_addr=$(ip link show "$iface" | grep -oP '(?<=link/ether\s)[0-9a-f:]+')
        echo -e "MAC Address:\t$mac_addr"
        
        # Gateway
        gateway=$(ip route | grep default | grep "$iface" | grep -oP '(?<=via\s)\d+(\.\d+){3}')
        [[ -z "$gateway" ]] && gateway="None"
        echo -e "Gateway:\t$gateway"
        
        # DNS
        dns=$(grep nameserver /etc/resolv.conf | awk '{print $2}' | tr '\n' ' ')
        echo -e "DNS Servers:\t${dns:-None}"
        
        # Internet Connectivity
        echo -n "Internet Access: "
        if ping -c 1 -W 1 -I "$iface" 8.8.8.8 &> /dev/null; then
            echo -e "\e[32mYes\e[0m"
        else
            echo -e "\e[31mNo\e[0m"
        fi
    done
    
    echo -e "\n\e[1;34m=================================\e[0m"
    exit 0
}

# Install missing dependencies
install_dependencies() {
    local missing_tools=("$@")
    echo -e "\e[33m[!] Missing required tools: ${missing_tools[*]}\e[0m"
    echo -e "\e[36m[+] Attempting to install dependencies...\e[0m"
    
    # Map tool names to packages
    declare -A package_map=(
        [dhclient]="isc-dhcp-client"
        [macchanger]="macchanger"
    )
    
    packages_to_install=()
    for tool in "${missing_tools[@]}"; do
        packages_to_install+=("${package_map[$tool]:-$tool}")
    done

    if [[ "$OS" == *"Debian"* || "$OS" == *"Ubuntu"* || "$OS" == *"Kali"* ]]; then
        sudo apt update
        sudo apt install -y "${packages_to_install[@]}"
    elif [[ "$OS" == *"Arch"* ]]; then
        sudo pacman -Sy --noconfirm "${packages_to_install[@]}"
    elif [[ "$OS" == *"Fedora"* || "$OS" == *"CentOS"* ]]; then
        sudo dnf install -y "${packages_to_install[@]}"
    else
        echo -e "\e[31m[!] Unsupported OS for automatic installation. Please install manually:\e[0m"
        echo "    ${packages_to_install[*]}"
        exit 1
    fi
    
    # Verify installation
    for tool in "${missing_tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "\e[31m[!] Failed to install $tool. Please install manually.\e[0m"
            exit 1
        fi
    done
    
    echo -e "\e[32m[√] Dependencies installed successfully!\e[0m"
}

# Detect OS and dependencies
detect_os() {
    # shellcheck disable=SC1091
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        OS=$NAME
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
    else
        OS=$(uname -s)
    fi
    
    # Check required tools
    missing_tools=()
    for tool in ip dhclient macchanger iw sed awk grep; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    
    if [ ${#missing_tools[@]} -gt 0 ]; then
        install_dependencies "${missing_tools[@]}"
    fi
}

# Detect available network interfaces
detect_interfaces() {
    active_interfaces=()
    echo -e "\e[36m[+] Detecting network interfaces...\e[0m"
    
    # Get all interfaces
    all_interfaces=$(ip -o link show | awk -F': ' '{print $2}' | sort)
    
    while IFS= read -r iface; do
        # Skip loopback and docker interfaces
        [[ "$iface" == "lo" || "$iface" == docker* ]] && continue
        
        # Check if interface is up
        state=$(ip -o link show dev "$iface" | grep -oP '(?<=state\s)\w+')
        if [[ "$state" == "UP" ]]; then
            active_interfaces+=("$iface")
            echo -e "  \e[32m● $iface\e[0m (UP)"
        else
            echo -e "  \e[90m○ $iface\e[0m (DOWN)"
        fi
    done <<< "$all_interfaces"
    
    if [ ${#active_interfaces[@]} -eq 0 ]; then
        echo -e "\e[31m[!] No active network interfaces found!\e[0m"
        exit 1
    fi
}

# Rotate IP address
rotate_ip() {
    local iface=$1
    local change_mac=$2
    local verbose=$3
    
    [[ "$verbose" == "true" ]] && echo -e "\n\e[36m[+] Starting IP rotation on $iface...\e[0m"
    
    # Get current IP
    old_ip=$(ip -4 addr show dev "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    [[ "$verbose" == "true" ]] && echo "  Current IP: ${old_ip:-None}"
    
    # Release current lease
    [[ "$verbose" == "true" ]] && echo "  Releasing current DHCP lease..."
    sudo dhclient -r -v "$iface" &> /dev/null
    
    # Bring interface down
    [[ "$verbose" == "true" ]] && echo "  Bringing interface down..."
    sudo ip link set dev "$iface" down
    
    # Change MAC address if requested
    if [[ "$change_mac" == "true" ]]; then
        [[ "$verbose" == "true" ]] && echo "  Randomizing MAC address..."
        sudo macchanger -r "$iface" &> /dev/null
    fi
    
    # Bring interface up
    [[ "$verbose" == "true" ]] && echo "  Bringing interface up..."
    sudo ip link set dev "$iface" up
    
    # Get new lease
    [[ "$verbose" == "true" ]] && echo "  Requesting new IP address..."
    sudo dhclient -v "$iface" &> /dev/null
    
    # Get new IP
    new_ip=$(ip -4 addr show dev "$iface" 2>/dev/null | grep -oP '(?<=inet\s)\d+(\.\d+){3}')
    
    if [[ -n "$new_ip" && "$old_ip" != "$new_ip" ]]; then
        [[ "$verbose" == "true" ]] && echo -e "\e[32m  [+] Rotation successful! New IP: $new_ip\e[0m"
        
        # Verify internet connectivity
        [[ "$verbose" == "true" ]] && echo -n "  Internet connectivity: "
        if check_internet; then
            [[ "$verbose" == "true" ]] && echo -e "\e[32mActive\e[0m"
        else
            [[ "$verbose" == "true" ]] && echo -e "\e[31mDown - Waiting 5 seconds to recover...\e[0m"
            sleep 5
            if ! check_internet; then
                [[ "$verbose" == "true" ]] && echo -e "\e[31m  [!] Internet not recovered. Trying again...\e[0m"
                sudo dhclient -v "$iface" &> /dev/null
            fi
        fi
        
        return 0
    else
        [[ "$verbose" == "true" ]] && echo -e "\e[31m  [!] Rotation failed. Using same IP.\e[0m"
        return 1
    fi
}

# Main function
main() {
    # Check if running as root, relaunch with sudo if not
    if [[ $EUID -ne 0 ]]; then
        echo -e "\e[33m[!] Script requires root privileges. Relaunching with sudo...\e[0m"
        exec sudo "$0" "$@"
    fi

    # Setup trap for clean exit
    trap cleanup SIGINT

    display_banner

    # Default values
    INTERFACE=""
    ROTATE_TIME=0
    CHANGE_MAC=false
    VERBOSE=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -I|--interface)
                INTERFACE="$2"
                shift 2
                ;;
            -t|--time)
                ROTATE_TIME="$2"
                shift 2
                ;;
            -m|--mac)
                CHANGE_MAC=true
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
             -V|--version)
                display_version
                ;;
            -s|--status)
                show_status
                ;;
            -u|--update)
                check_updates
                ;;
            -h|--help)
                display_help
                exit 0
                ;;
            *)
                echo -e "\e[31m[!] Unknown option: $1\e[0m"
                display_help
                exit 1
                ;;
        esac
    done

    detect_os
    detect_interfaces

    # Validate interface selection
    if [[ -n "$INTERFACE" ]]; then
        if ! ip link show "$INTERFACE" &> /dev/null; then
            echo -e "\e[31m[!] Interface $INTERFACE not found!\e[0m"
            echo "Available interfaces:"
            for iface in "${active_interfaces[@]}"; do
                echo "  - $iface"
            done
            exit 1
        fi
    else
        # Use first active interface if not specified
        INTERFACE=${active_interfaces[0]}
        echo -e "\e[36m[+] Using auto-detected interface: $INTERFACE\e[0m"
    fi

    # Validate rotation time
    if [[ $ROTATE_TIME -gt 0 ]]; then
        if [[ $ROTATE_TIME -lt $MIN_ROTATION_TIME ]]; then
            echo -e "\e[33m[!] Rotation time $ROTATE_TIME is too low. Setting to minimum: $MIN_ROTATION_TIME seconds\e[0m"
            ROTATE_TIME=$MIN_ROTATION_TIME
        fi
        
        echo -e "\e[36m[+] Starting continuous rotation every ${ROTATE_TIME}s\e[0m"
        if [[ "$CHANGE_MAC" == "true" ]]; then
            echo -e "\e[36m[+] MAC randomization enabled\e[0m"
        fi
        
        COUNT=1
        while true; do
            echo -e "\n\e[1;34m===== Rotation Cycle #$COUNT =====\e[0m"
            rotate_ip "$INTERFACE" "$CHANGE_MAC" "$VERBOSE"
            echo -e "\e[36m[+] Next rotation in ${ROTATE_TIME}s...\e[0m"
            sleep "$ROTATE_TIME"
            ((COUNT++))
        done
    else
        # Single rotation
        rotate_ip "$INTERFACE" "$CHANGE_MAC" "$VERBOSE"
    fi
}

# Execute main function
main "$@"
