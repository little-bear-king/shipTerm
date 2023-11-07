const std = @import("std");
const rand = @import("std").rand;

const Star = struct {
    name: []const u8,
    x: f64,
    y: f64,
};

// Define a comptime function to generate star positions.
const fn generateStarPositions() []Star {
    const numStars = 100;
    var stars: [numStars]Star = undefined;

    var random = rand.DefaultPrng.init(0); // Initialize a random number generator.

    for (stars) |star, idx| {
        star.name = std.fmt.allocPrint(Allocator.heap(), "Star{}", .{@int(idx)});
        star.x = random.nextDouble() * 10.0; // Adjust the range as needed.
        star.y = random.nextDouble() * 10.0;
    }

    return stars;
}

pub fn main() void {
    // Generate star positions at compile time.
    const starPositions = generateStarPositions();

    // Perform additional procedural generation or runtime computations as needed.
    // This could include generating connections between stars or other dynamic aspects.

    // Access the precomputed star positions at runtime.
    for (starPositions) |star| {
        std.debug.print("Star: {}, x: {}, y: {}\n", .{star.name, star.x, star.y});
    }
}

