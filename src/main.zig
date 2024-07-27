const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    const allocator = arena.allocator();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 3 and args.len != 4) {
        std.debug.print("Usage: {s} <ip> <port-range> [timeout-ms]\n", .{args[0]});
        return;
    }

    const ip = args[1];
    const port_range = args[2];
    var start_end_iter = std.mem.splitSequence(u8, port_range, "-");

    const start_port = try std.fmt.parseInt(u16, start_end_iter.next() orelse return error.InvalidPortRange, 10);
    const end_port = try std.fmt.parseInt(u16, start_end_iter.next() orelse return error.InvalidPortRange, 10);

    if (start_end_iter.next() != null) {
        return error.InvalidPortRange;
    }

    const timeout_ms = if (args.len == 4)
        try parseTimeout(args[3])
    else
        5000;

    var port: u16 = start_port;
    while (port <= end_port) : (port += 1) {
        const is_open = is_port_open(ip, port, timeout_ms) catch |err| {
            std.debug.print("Error checking port {d}: {}\n", .{ port, err });
            continue;
        };
        if (is_open) {
            std.debug.print("Port {d} is open\n", .{port});
        } else {
            std.debug.print("Port {d} is closed\n", .{port});
        }
    }
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
