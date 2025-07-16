# IP-Vortex
This tool provides a sophisticated yet easy-to-use solution for maintaining anonymity during security testing. The timed rotation feature is particularly useful for avoiding IP-based rate limiting during fuzzing and vulnerability scanning.

# IP Vortex - Advanced IP Rotation Tool

![IP Vortex Banner](https://blog.apnic.net/wp-content/uploads/2019/07/IP_banner.png?v=520cffb00b5dfb0272f17668f2693ff7ef0a6c9bf37aa9e22a0c709e9f41f79d)

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
