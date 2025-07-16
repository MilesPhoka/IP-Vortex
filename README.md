# IP-Vortex
This tool provides a sophisticated yet easy-to-use solution for maintaining anonymity during security testing. The timed rotation feature is particularly useful for avoiding IP-based rate limiting during fuzzing and vulnerability scanning.

# IP Vortex - Advanced IP Rotation Tool

![IP Vortex Banner](https://content.kaspersky-labs.com/fm/press-releases/c9/c9dc177db2511f60a8f41232029d11c0/processed/what-is-an-ip-address1-q75.jpg)

**IP Vortex** is a powerful network utility designed for security professionals, penetration testers, and bug bounty hunters. This tool provides sophisticated IP rotation capabilities to help you maintain anonymity and bypass IP-based restrictions during security testing activities.

## Key Features

- 🔁 **Automatic IP Rotation**: Change your public IP address on demand
- ⏱️ **Timed Rotations**: Set rotation intervals (every 30s, 5m, etc.)
- 📶 **Multi-Interface Support**: Works with WiFi (wlan), Ethernet (eth), and USB tethering
- 🆔 **MAC Address Randomization**: Optional MAC spoofing for enhanced anonymity
- 📊 **Network Status Monitoring**: Real-time interface and connection information
- 🔄 **Auto-Dependency Installation**: Automatically installs required packages
- 🔒 **Smart Privilege Management**: Automatically handles sudo requirements
- 📜 **Comprehensive Logging**: Detailed rotation history and system events

## Installation

```bash
# Clone the repository
git clone https://github.com/MilesPhoka/IP-Vortex.git

# Navigate to project directory
cd IP-Vortex

# Make script executable
chmod +x ip-vortex.sh

# Run the tool (will auto-install dependencies)
./ip-vortex.sh --help
