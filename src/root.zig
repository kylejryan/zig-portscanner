const std = @import("std");
const testing = std.testing;

test "parseTimeout function" {
    const timeout = try parseTimeout("5000");
    try testing.expect(timeout == 5000);

    const invalid_timeout = try parseTimeout("invalid");
    try testing.expect(invalid_timeout == 5000);
}

test "is_port_open function (mocked)" {
    // Note: This test assumes you are able to mock or simulate the network environment.
    // Here, we assume is_port_open returns true for a mock address and port.

    const ip = "127.0.0.1";
    const port: u16 = 8080;
    const timeout_ms: u32 = 1000;

    // Simulating an open port
    const is_open = try is_port_open(ip, port, timeout_ms);
    try testing.expect(is_open == true);

    // Simulating a closed port
    // For actual implementation, you might need to modify is_port_open to allow injection of a mock or simulate a real scenario.
}

fn parseTimeout(arg: []const u8) !u32 {
    return std.fmt.parseInt(u32, arg, 10) catch |err| {
        std.debug.print("Invalid timeout value: {}. Using default 5000ms.\n", .{err});
        return 5000;
    };
}

fn is_port_open(ip: []const u8, port: u16, timeout_ms: u32) !bool {
    const address = try std.net.Address.parseIp4(ip, port);

    const start_time = std.time.milliTimestamp();
    const end_time = start_time + timeout_ms;

    while (std.time.milliTimestamp() < end_time) {
        var socket = std.net.tcpConnectToAddress(address) catch |err| switch (err) {
            error.ConnectionRefused => return false,
            error.NetworkUnreachable, error.ConnectionTimedOut => {
                if (std.time.milliTimestamp() >= end_time) {
                    return false;
                }
                continue;
            },
            else => |e| return e,
        };
        defer socket.close();

        return true;
    }

    return false;
}
