# Internet Ping Logger

A simple Windows batch-file tool for logging basic internet connection performance over time.

This script pings two targets at regular intervals:

1. The computer's default gateway, usually the home router
2. A public internet target, such as Google's `8.8.8.8`

It saves the results to a CSV file on the user's Desktop so the data can be opened in Excel, Google Sheets, LibreOffice Calc, OpenOffice Calc, or even Notepad.

## Changing the Ping Interval

The script waits a set number of seconds between each test cycle. By default, this may be set to something like 15 or 60 seconds.

To change how often the script runs, edit this line near the top of the batch file:

```bat
set INTERVAL_SECONDS=15
```

The number is the delay in seconds.

Examples:

```bat
set INTERVAL_SECONDS=15
```

Runs the test about every 15 seconds.

```bat
set INTERVAL_SECONDS=60
```

Runs the test about once per minute.

```bat
set INTERVAL_SECONDS=300
```

Runs the test about once every 5 minutes.

Do not add spaces around the equals sign. In Windows batch files, variable assignments should be written like this:

```bat
set NAME=value
```

## What This Is For

This tool is meant for basic troubleshooting when an internet connection feels slow, unreliable, or inconsistent.

It helps answer a simple question:

> Is the problem inside the local network, or somewhere between the router and the internet?

This is useful when troubleshooting problems like:

* Slow video calls
* Laggy remote work sessions
* Intermittent disconnects
* High latency
* Possible Wi-Fi problems
* Possible ISP problems

It is not a full network diagnostic suite. It is a simple logging tool meant to show trends over time.

## How It Works

The script automatically looks for the computer's default gateway. In most homes, this is the Wi-Fi router.
It uses a 'route print' command to retrieve the computer's network information and parses the response to identify the default gateway IP.

Then it pings:

* The router/default gateway
* A public internet server

Each result is written to a CSV log file.

Example log output:

```csv
"Date","Time","Target","Status","Latency_ms"
"05/28/2026","18:29:38","192.168.x.x","OK","32"
"05/28/2026","18:29:38","8.8.8.8","OK","35"
```

## Basic Interpretation

| Router Ping                               | Internet Ping                          | Likely Meaning                                           |
| ----------------------------------------- | -------------------------------------- | -------------------------------------------------------- |
| OK                                        | OK                                     | Connection was working at that moment                    |
| FAIL                                      | FAIL                                   | Possible Wi-Fi, device, router, or local network problem |
| OK                                        | FAIL                                   | Possible modem, ISP, or internet-side problem            |
| High latency                              | High latency                           | Possible local congestion, Wi-Fi issue, or ISP issue     |
| Low router latency, high internet latency | Possible ISP or upstream routing issue |                                                          |

## Simple Network View

```mermaid
flowchart LR
    A[Computer] -->|Ping default gateway| B[Home Router]
    B -->|Ping public internet target| C[Internet Server]

    A -. log result .-> D[CSV Log File]
    B -. latency / fail .-> D
    C -. latency / fail .-> D
```

## Why Ping Both the Router and the Internet?

Pinging only the internet can show that something is wrong, but it does not always show where the problem is.

By checking both the router and the internet, the log can help separate local problems from internet-side problems.

For example:

* If the router ping fails, the problem may be Wi-Fi, Ethernet, the computer, or the router.
* If the router ping works but the internet ping fails, the problem may be the modem, ISP, or upstream connection.
* If both work but latency is very high, the connection may be overloaded or unstable.

## How to Use

1. Download the `.bat` file.
2. Double-click it to start logging.
3. Leave the window open while testing.
4. Close the window to stop logging.
5. Open the CSV file created on the Desktop.

The log file can be imported into a spreadsheet and charted to visualize performance over time.

## Output File

By default, the script creates:

```text
internet_ping_log.csv
```

on the current user's Desktop.

## Notes

* This script is intended for Windows.
* It does not require installation.
* It does not require administrator privileges.
* It does not change network settings.
* It only runs ping commands and writes the results to a local CSV file.
* Some networks may block ping traffic.
* A failed ping does not always mean the internet is down; it means that specific ping test did not receive a reply.

## Privacy Note

The default gateway is usually a private local network address, such as `192.168.x.x`, `10.x.x.x`, or `172.16.x.x`.

These addresses are common on home and business networks. They are not public internet addresses, but they can reveal small details about the internal network layout. Avoid posting full logs publicly unless you are comfortable sharing that information.

## Limitations

This tool does not test specific websites, video-call services, company portals, VPNs, DNS performance, bandwidth, packet jitter, or application-level problems.

It is only meant to provide a basic trend log showing whether ping replies were received and how long they took.
