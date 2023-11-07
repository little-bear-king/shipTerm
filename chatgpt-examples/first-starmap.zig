const std = @import("std");

const Allocator = std.mem.Allocator;
const HashMap = std.HashMap;
const Vec = std.ArrayList;

// Define a struct to represent a star.
pub const Star = struct {
    name: []const u8,
    x: f64,
    y: f64,
};

// Define a struct to represent a connection between two stars.
pub const StarConnection = struct {
    from: Star,
    to: Star,
    distance: f64,
};

// Define a struct to represent the star map, which is essentially a graph.
pub const StarMap = struct {
    stars: HashMap([]const u8, Star, Allocator),
    connections: Vec(StarConnection, Allocator),
};

// Function to add a star to the star map.
pub fn addStar(starMap: *StarMap, name: []const u8, x: f64, y: f64) void {
    const star = Star{name, x, y};
    starMap.stars.put(name, star);
}

// Function to add a connection between two stars with a given distance.
pub fn addConnection(starMap: *StarMap, from: []const u8, to: []const u8, distance: f64) void {
    if (starMap.stars.containsKey(from) && starMap.stars.containsKey(to)) {
        const connection = StarConnection{.from = starMap.stars.get(from).?, .to = starMap.stars.get(to).?, .distance = distance};
        starMap.connections.append(connection);
    } else {
        // Handle error: One or both stars do not exist.
        // You can add error handling code here.
    }
}

// Function to calculate the distance between two stars in the star map.
pub fn calculateDistance(starMap: *StarMap, from: []const u8, to: []const u8) f64 {
    for (starMap.connections) |connection| {
        if (connection.from.name == from && connection.to.name == to) {
            return connection.distance;
        }
    }
    // Handle error: No direct connection between the stars found.
    // You can add error handling code here.
    return 0.0;
}

pub fn main() void {
    var starMap = StarMap{ .stars = HashMap([]const u8, Star, Allocator), .connections = Vec(StarConnection, Allocator) };

    // Add some stars to the map.
    addStar(&starMap, "Sol", 0.0, 0.0);
    addStar(&starMap, "Alpha Centauri", 4.3, 3.2);
    addStar(&starMap, "Sirius", -1.7, 2.8);

    // Add connections between stars with distances.
    addConnection(&starMap, "Sol", "Alpha Centauri", 1.5);
    addConnection(&starMap, "Alpha Centauri", "Sirius", 2.0);

    // Calculate the distance between two stars.
    const distance = calculateDistance(&starMap, "Sol", "Alpha Centauri");
    std.debug.print("Distance from Sol to Alpha Centauri: {}\n", .{distance});
}
