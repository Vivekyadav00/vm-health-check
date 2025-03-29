# System Health Monitor

A bash script to monitor system health metrics (CPU, Memory, and Disk usage) on Ubuntu systems. The script provides a simple way to check if your system resources are being utilized within acceptable thresholds.

## Features

- Monitors CPU usage
- Monitors Memory usage
- Monitors Disk usage
- Configurable threshold (default: 60%)
- Detailed explanation mode
- Easy to understand output

## Requirements

- Ubuntu-based system
- `bc` command (for floating-point calculations)
- `top` command
- `free` command
- `df` command

Most of these commands come pre-installed on Ubuntu systems. If `bc` is missing, you can install it using:

```bash
sudo apt-get update
sudo apt-get install bc
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/system-health-monitor.git
cd system-health-monitor
```

2. Make the script executable:
```bash
chmod +x health-check.sh
```

## Usage

### Basic Health Check

To perform a basic health check that only shows the overall status:

```bash
./health-check.sh
```

Example output:
```
Health Status: HEALTHY
```

### Detailed Explanation

To get detailed information about system metrics and any issues found:

```bash
./health-check.sh explain
```

Example output:
```
Current Metrics:
CPU Usage: 25.75%
Memory Usage: 45.30%
Disk Usage: 72.00%

Health Status: NOT HEALTHY

Issues Found:
- Disk usage is high: 72.00%
```

## How It Works

The script considers a system healthy if all monitored metrics (CPU, Memory, and Disk usage) are below 60% utilization. If any metric exceeds this threshold, the system is considered not healthy.

### Metrics Calculation

1. **CPU Usage**: Calculated using the `top` command, measuring the percentage of CPU time not in idle
2. **Memory Usage**: Calculated using the `free` command, showing the percentage of used memory compared to total memory
3. **Disk Usage**: Calculated using the `df` command, showing the percentage of used disk space on the root partition

## Customization

You can modify the threshold value (default: 60%) by changing the `threshold` variable in the script:

```bash
threshold=60  # Change this value to adjust the threshold
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

Your Name

## Acknowledgments

- Thanks to the Linux community for the robust command-line tools that make this script possible
