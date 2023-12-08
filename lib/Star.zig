const std = @import("std");

pub const Star = struct {
    name: []u8,
    x: f32,
    y: f32,

    pub fn init(name: []u8, x: f32, y: f32) Star {
        return Star{ .name = name, .x = x, .y = y };
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("star:\nname: \"{s}\"\tx: {d:1.1}, y: {d:1.1}\n", .{ self.name, self.x, self.y });
    }
};
