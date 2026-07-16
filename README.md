# System Monitor Script

A lightweight Bash script that reports CPU, memory, and disk usage,
warns when any crosses a threshold, and logs each run.

## Requirements
- Linux, Bash
- Standard tools: df, free, awk, /proc/stat

## Usage
Run `chmod +x monitor.sh` once, then `./monitor.sh`.

## Configuration
Edit config.sh — `THRESHOLD` (alert %, default 80),
`LOG_DIR` (log location, default ./logs).

## Output
Prints a health line per metric; appends a timestamped
record to logs/monitor.log.