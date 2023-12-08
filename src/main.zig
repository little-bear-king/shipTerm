// A terminal application that tracks the values of the various systems on a starfield ship.
// IDEA: A Server and Client program for collaboration, and ship combat.
// IDEA: A Main menu that takes you to eeach of the system pages
// IDEA: Very Old Fashioned with no graphics, the menu should be printed often
// IDEA: A quick way to import new ship types, and info
// IDEA: save data
// IDEA: I want it to feel like a terminal deep in the bowels of an Artificers ship
// IDEA:
// IDEA:
// IDEA: I could try to implement in C first and port it over?
// IDEA:
// TODO: Learn about build.zig and linking libraries
// TODO: Learn about creating custom types for the Ships, Planets, Stars, and the Galaxy

const std = @import("std");
const rand = @import("std").rand;
const Allocator = std.mem.Allocator;
const Space = @import("Space");
const Star = Space.Star;

const numStars: u32 = 10001;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const Alloc = gpa.allocator();

    // Star Generation
    var random = rand.DefaultPrng.init(0); // Initialize a random number generator.random
    var my_hash_map = std.StringHashMap(Star).init(Alloc);
    defer my_hash_map.deinit();

    for (1..numStars) |i| {
        const starName = try std.fmt.allocPrint(Alloc, "Star{}", .{i});
        const stddev_x: f32 = 10.0;
        const stddev_y: f32 = 10.0;
        const x = random.random().floatNorm(f32) * stddev_x;
        const y = random.random().floatNorm(f32) * stddev_y;
        const starInit = Star.init(starName, x, y);
        try my_hash_map.put(starInit.name, starInit);
    }
    for (1..numStars) |value| {
        const getKey = try std.fmt.allocPrint(Alloc, "Star{}", .{value});
        const getStar = my_hash_map.getPtr(getKey);
        std.debug.print("{any}\n", .{getStar});
    }
}
