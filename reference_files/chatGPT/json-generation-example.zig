const std = @import("std");
const json = @import("std").json;
const fs = std.fs;

pub const Star = struct {
    name: []const u8,
    x: f64,
    y: f64,
};

pub fn main() void {
    // Your star map generation code here...

    // Generate data files for each star.
    for (starMap.stars, 0..) |_, star| {
        const filename = "star_" ++ star.name ++ ".json";
        const file = try fs.cwd().openFile(filename, .{ .create = true, .write = true });

        const encoder = json.Encoder.init(file.outStream());
        try encoder.encode(star);
    }
}
