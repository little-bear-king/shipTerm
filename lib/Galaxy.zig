const std = @import("std");
const Star = @import("Star.zig");
const Galaxy = @This();
name: []const u8,
x_Max: i32,
y_Max: i32,

stars: std.ArrayList(Star),

pub fn init(name: []const u8, x_Max: i32, y_Max: i32, stars: std.ArrayList(Star)) !void {
    return Galaxy{
        .name = name,
        .x_Max = x_Max,
        .y_Max = y_Max,
        .stars = stars,
    };
}
