const std = @import("std");
// const Galaxy = @import("Galaxy.zig");

const Star = @This();

name: []const u8,
x_pos: i32,
y_pos: i32,

pub fn init(name: []const u8, x_pos: i32, y_pos: i32) Star {
    return Star{
        .name = name,
        .x_pos = x_pos,
        .y_pos = y_pos,
    };
}
