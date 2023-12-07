const std = @import("std");
const rand = @import("std").rand;

// var gpa = std.heap.GeneralPurposeAllocator(.{}){};
// var Allocator = gpa.allocator();

const Star = struct {
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

// Define a comptime function to generate star positions.
// fn generateStarPositions() !*[100]Star {
//     const numStars: u8 = 100;
//     var stars: [numStars]Star = undefined;
//
//     var random = rand.DefaultPrng.init(0); // Initialize a random number generator.random
//     for (1..numStars - 1) |i| {
//         // var starName = std.fmt.allocPrint(Allocator, "Star{any}", .{i});
//         var buffer: [7]u8 = undefined;
//         const starName = try std.fmt.bufPrint(&buffer, "Star{any}", .{i});
//         const scale_x: f32 = 10.0;
//         const scale_y: f32 = 10.0;
//         const x = random.random().float(f32) * scale_x; // Adjust the range as needed.
//         const y = random.random().float(f32) * scale_y;
//         stars[i] = Star.init(starName, x, y);
//     }
//
//     return &stars;
// }

pub fn main() !void {
    // Generate star positions at compile time.

    // const starPositions = generateStarPositions();
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const Alloc = gpa.allocator();
    const numStars: u32 = 1001;
    var stars = std.StringHashMap(Star).init(Alloc);
    defer stars.deinit();

    var random = rand.DefaultPrng.init(0); // Initialize a random number generator.random
    // var buffer: [7]u8 = undefined;
    for (1..numStars) |i| {
        const starName = try std.fmt.allocPrint(Alloc, "Star{}", .{i});
        // const starName = try std.fmt.bufPrint(&buffer, "Star{any}", .{i});
        const scale_x: f32 = 10.0;
        const scale_y: f32 = 10.0;
        const x = random.random().float(f32) * scale_x; // Adjust the range as needed.
        const y = random.random().float(f32) * scale_y;
        const starInit = Star.init(starName, x, y);
        try stars.put(starName, starInit);
    }
    for (1..numStars) |value| {
        const getKey = try std.fmt.allocPrint(Alloc, "Star{}", .{value});
        const getStar = stars.getPtr(getKey);
        std.debug.print("{any}\n", .{getStar});
    }
}
