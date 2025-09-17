# pinglogger

A simple, colored ping logging tool for Linux terminals.
Monitors the connectivity and latency to a target host, displaying results in real-time using colored ASCII symbols and saving them to per-host log files.

## Features

Colored output: green dot (.), yellow colon (:), and red x, corresponding to fast, slow, and failed pings. From testing, the colors seem to look different depending on terminal settings. 

Configurable: Set the ping interval and latency threshold via flags.

Per-host logs: Each target gets its own log file for persistent history.

---

## Usage

bash
pinglogger [-i interval] [-t threshold] target
target: Hostname or IP to ping (required).

-i interval: Ping interval in seconds (optional, default is 5).

-t threshold: Latency threshold in milliseconds for "slow" pings (optional, default is 10).

## Examples

Ping google.com with default settings:

```bash
pinglogger google.com
```

Ping every 2 seconds with a threshold of 20ms:

```bash
pinglogger -i 2 -t 20 google.com
```

Output Legend
. Green: Successful ping under threshold

: Orange/Yellow: Successful ping over threshold (default 10ms)

x Red: Ping failed/lost

---

## Log Files

Each target host gets a log file named <target>.log (e.g., google_com.log).

On script startup, some of the last lines of that log (if it has been run before) are displayed for context.

---

## Installation

Place pinglogger.sh anywhere (e.g., ~/projects/pinglogger/).

Make it executable:

```bash
chmod +x ~/projects/pinglogger/pinglogger.sh
```

Optional: Add to your .bashrc:

```bash
alias pinglogger="~/projects/pinglogger/pinglogger.sh"
```

---

## Requirements

Bash (Tested on Linux)

Standard tools: ping, awk, sed, tail

---

## License

MIT License (see LICENSE file for details)
