const std = @import("std");
const Allocator = std.mem.Allocator;
const HashMap = std.HashMap;
const Vec = std.ArrayList;
const rand = @import("std").rand;

pub const Star = struct {
    name: []const u8,
    x: f64,
    y: f64,
};

pub const StarConnection = struct {
    from: Star,
    to: Star,
    distance: f64,
};

pub const StarMap = struct {
    stars: HashMap([]const u8, Star, Allocator),
    connections: Vec(StarConnection, Allocator),
};

pub fn addStar(starMap: *StarMap, name: []const u8, x: f64, y: f64) void {
    const star = Star{name, x, y};
    starMap.stars.put(name, star);
}

pub fn addConnection(starMap: *StarMap, from: []const u8, to: []const u8, distance: f64) void {
    if (starMap.stars.containsKey(from) && starMap.stars.containsKey(to)) {
        const connection = StarConnection{.from = starMap.stars.get(from).?, .to = starMap.stars.get(to).?, .distance = distance};
        starMap.connections.append(connection);
    }
}

pub fn generateRandomStarMap(numStars: usize, maxCoordinate: f64, maxDistance: f64) StarMap {
    var starMap = StarMap{ .stars = HashMap([]const u8, Star, Allocator), .connections = Vec(StarConnection, Allocator) };

    const random = rand.DefaultPrng.init(0); // Initialize a random number generator.

    for (i in 0..numStars) {
        const name = std.fmt.allocPrint(Allocator.heap(), "Star{}", .{@int(i)});
        const x = random.nextDouble() * maxCoordinate;
        const y = random.nextDouble() * maxCoordinate;

        addStar(&starMap, name, x, y);

        // Generate connections to previous stars in the map.
        for (j in 0..i) {
            const otherStar = starMap.stars.values().at(j).?;
            const distance = random.nextDouble() * maxDistance;
            addConnection(&starMap, name, otherStar.name, distance);
        }
    }

    return starMap;
}

pub fn main() void {
    const numStars = 5;
    const maxCoordinate = 10.0;
    const maxDistance = 5.0;

    const starMap = generateRandomStarMap(numStars, maxCoordinate, maxDistance);

    // Print the generated star map.
    for (starMap.connections) |connection| {
        std.debug.print("Connection: {} -> {} (Distance: {})\n", .{connection.from.name, connection.to.name, connection.distance});
    }
}
