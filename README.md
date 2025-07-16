# IP-Vortex
This tool provides a sophisticated yet easy-to-use solution for maintaining anonymity during security testing. The timed rotation feature is particularly useful for avoiding IP-based rate limiting during fuzzing and vulnerability scanning.

# IP Vortex - Advanced IP Rotation Tool

![IP Vortex Banner](https://github.com/user-attachments/assets/1223fadd-7d67-4ea1-99a6-c9e8e5104eec)

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
```
## Version Check
```bash
# Display the current version of IP-Vortex
./ip-vortex.sh -V
```

 ## Comprehensive Usage Examples
- Basic IP Rotation
```bash
  # Single rotation on auto-detected interface
./ip-vortex.sh

# Rotate specific interface (wlan0) with verbose output
./ip-vortex.sh -I wlan0 -v

# Rotate with MAC randomization
./ip-vortex.sh -m
```

## Continuous Rotation for Bug Bounty
```bash
  # Rotate every 2 minutes with MAC randomization
./ip-vortex.sh -t 120 -m

# Rotate every 30 seconds (minimum is 10s) with verbose output
./ip-vortex.sh -t 30 -v

# Rotate Ethernet interface every 5 minutes
./ip-vortex.sh -I eth0 -t 300
```
## Network Diagnostics
```bash
# Show current network status
./ip-vortex.sh -s

# Check interface details while rotating
./ip-vortex.sh -I eth0 -t 60 -v
```

## Advanced Workflows
```bash
# Start rotation in background
./ip-vortex.sh -t 300 > rotation.log 2>&1 &

# Run security tools simultaneously
ffuf -w wordlist.txt -u https://target.com/FUZZ
nuclei -u https://target.com -t vulnerabilities/

# Monitor IP changes
tail -f rotation.log

# Stop rotation
pkill -f ip-vortex.sh
```

## Real-World Bug Bounty Scenarios
- Web Application Fuzzing with IP Rotation
```bash
# Rotate IP every 50 requests
./ip-vortex.sh -t 300 &
ffuf -w params.txt:PARAM -w values.txt:VAL \
  -u 'https://target.com/page?PARAM=VAL' \
  -p "0.3-1.2" -t 50 -rate 20
```

## API Rate Limit Bypass
```bash
# Rotate IP after each API call
for endpoint in $(cat api-endpoints.txt); do
  ./ip-vortex.sh
  curl -s "https://api.target.com/$endpoint" | jq .
  sleep 1
done
```

## Stealth Scanning
```bash
# Rotate IP between port scans
./ip-vortex.sh -t 120 -m &
while read ip; do
  nmap -T4 -Pn $ip
  sleep $((RANDOM % 30 + 10))
done < targets.txt
```
## Brute Force Protection Evasion
```bash
# Rotate IP every 10 login attempts
./ip-vortex.sh -t 60 &
hydra -L users.txt -P passwords.txt \
  target.com http-post-form "/login:username=^USER^&password=^PASS^:F=incorrect" \
  -t 10 -w 5
```

## Recovery Operations
```bash
# Reset network if script interrupted
./ip-vortex.sh --recover

# Verify internet connectivity
ping 8.8.8.8

# Full network restart (if needed)
sudo systemctl restart NetworkManager
```

# Technical Specifications
## Rotation Process
- Release current DHCP lease
- Bring interface down
- Randomize MAC address (if enabled)
- Bring interface up
- Request new DHCP lease
- Verify new IP assignment
- Confirm internet connectivity

# System Requirements
| Component   | Minimum Requirement              | Recommended            |
|-------------|----------------------------------|-------------------------|
| OS          | Linux (Kali, Ubuntu, Debian, Arch) | Kali Linux 2023+       |
| Memory      | 512 MB RAM                       | 2 GB RAM                |
| Storage     | 100 MB available                 | 1 GB available          |
| Network     | DHCP-enabled connection          | High-speed internet     |
| Privileges  | Root/sudo access                 | —                       |

# Performance Metrics
| Operation           | Average Time     | Notes                        |
|---------------------|------------------|------------------------------|
| Single rotation     | 2–5 seconds      | Varies by network            |
| MAC randomization   | +1–2 seconds     | Depends on hardware          |
| Internet recovery   | < 3 seconds      | After successful rotation    |
| Continuous rotation | 1000+ cycles     | Stable long-term operation   |

# Troubleshooting
## Common Issues & Solutions
| Issue                    | Solution                                                       |
|--------------------------|----------------------------------------------------------------|
| Rotation fails           | Run with `-v` for detailed output                              |
| "No active interfaces"   | Check interface status with `ip a`                             |
| MAC randomization fails  | Install latest macchanger: `sudo apt install --reinstall macchanger` |
| Internet not recovering  | Use `./ip-vortex.sh --recover`                                 |
| Slow rotation times      | Increase minimum time to 15+ seconds                           |
| Permission errors        | Ensure script is run with `sudo`   

## Debugging Tips
```bash
# Enable verbose mode
./ip-vortex.sh -I wlan0 -t 60 -v

# Check system logs
journalctl -u NetworkManager -f

# Verify IP changes
watch -n 1 'curl -s ifconfig.me'

# Test interface directly
sudo dhclient -r wlan0
sudo dhclient -v wlan0
```
# Ethical security testing where IP rotation provides value
+-----------------+---------------------+
| Scenario        | Usefulness (1-5★) |
+-----------------+---------------------+
| Web App Scanning| ★★★★☆              |
| API Testing     | ★★★★☆              |
| Network Probes  | ★★★☆☆              |
| Brute Force     | ★★☆☆☆ (risky)      |
| VPN Avoidance   | ★☆☆☆☆ (use VPN)    |
+-----------------+---------------------+

# Contribution Guidelines
## I welcome contributions! Here's how to help:
- Fork the repository
- Create a feature branch (`git checkout -b feature/improvement`)
- Commit your changes (`git commit -am 'Add new feature'`)
- Push to the branch (`git push origin feature/improvement`)
- Open a pull request

> ⚠️ *Ethical Notice*  
> Use this tool *only* on networks and systems you have *explicit permission* to test.  
> Unauthorized use may violate laws and regulations.  
> The developers *assume no liability* for misuse of this software.

---

*Author:* Miles Phoka  
*Version:* 1.2  
*GitHub:* [https://github.com/MilesPhoka](https://github.com/MilesPhoka)
