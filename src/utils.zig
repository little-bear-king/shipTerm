const std = @import("std");

pub fn trimWindowsReturn(buffer: []u8) ![]const u8 {
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, buffer, "\r");
    } else {
        return buffer;
    }
}

pub fn goodBye() void {
    std.debug.print("Logging off...\n", .{});
    std.debug.print("Goodbye!\n", .{});
    std.process.exit(0);
}

pub fn print() !void {}
