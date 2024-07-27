
# Zig Port Scanner

A simple port scanner written in Zig. This tool allows you to scan a range of ports on a specified IP address to check whether they are open or closed. It provides configurable timeout options to customize the scanning process. In the future, I'm looking to add more robust functionality while I learn Zig.

## Features

- Scan a range of ports on a specified IP address.
- Configurable timeout for connection attempts.
- Detailed output showing open and closed ports.
- Efficient and fast scanning using Zig's concurrency features.

## Prerequisites

- [Zig](https://ziglang.org/) (version 0.12.0 or higher)

## Installation

1. **Clone the repository:**

   ```sh
   git clone https://github.com/your-username/zig-portscanner.git
   cd zig-portscanner
   ```

2. **Build the project:**

   ```sh
   zig build
   ```

## Usage

1. **Running the port scanner:**

   ```sh
   zig-out/bin/zig-portscanner <ip> <port-range> [timeout-ms]
   ```

   - `<ip>`: The IP address to scan.
   - `<port-range>`: The range of ports to scan in the format `<start>-<end>`.
   - `[timeout-ms]`: Optional. Timeout in milliseconds for each connection attempt (default is 5000ms).

2. **Example:**

   Scan ports 20 to 80 on the IP address `192.168.1.10` with a timeout of 5000 milliseconds:

   ```sh
   zig-out/bin/zig-portscanner 192.168.1.10 20-80 5000
   ```

## Project Structure

- `src/main.zig`: The main entry point of the application. Contains the logic for parsing arguments, iterating through port ranges, and invoking the port scan function.
- `src/root.zig`: Contains unit tests for the functions used in the port scanner.
- `build.zig`: The build script for the Zig project.
- `build.zig.zon`: Additional build configuration for the Zig project.
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `README.md`: This file.

## Running Tests

To run the unit tests defined in `src/root.zig`, use the following command:

```sh
zig build test
```

This will compile and run the tests, providing output indicating whether the tests passed or failed.

## Contributing

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin feature/my-new-feature`).
5. Create a new Pull Request.

## Legal Disclaimer

This port scanner is intended for educational and legitimate purposes only. Unauthorized port scanning can be illegal and unethical. Always obtain proper authorization before using this tool on any network or system that you do not own or have explicit permission to test.

### Responsible Use

- **Educational Use:** This tool is designed to help users learn about network security and port scanning techniques.
- **Authorized Testing:** Use this tool only on networks and systems that you own or have explicit permission to test.
- **Compliance:** Ensure your use of this tool complies with all applicable laws and regulations.

By using this tool, you agree to take full responsibility for your actions and acknowledge that the author(s) of this tool are not liable for any misuse or damages caused by using this software.

## Acknowledgements

- Thanks to the Zig programming language community for their support and contributions.
