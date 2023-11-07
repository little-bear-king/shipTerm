const std = @import("std");
const Allocator = std.mem.Allocator;
const HashMap = std.HashMap;

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
    connections: HashMap([]const u8, StarConnection, Allocator),
};

pub fn addStar(starMap: *StarMap, name: []const u8, x: f64, y: f64) void {
    const star = Star{name, x, y};
    starMap.stars.put(name, star);
}

pub fn addConnection(starMap: *StarMap, from: []const u8, to: []const u8, distance: f64) void {
    if (starMap.stars.containsKey(from) && starMap.stars.containsKey(to)) {
        const connection = StarConnection{.from = starMap.stars.get(from).?, .to = starMap.stars.get(to).?, .distance = distance};
        starMap.connections.put(from ++ to, connection);
    }
}

pub fn main() void {
   var starMap = StarMap{ .stars = HashMap([]const u8, Star, Allocator), .connections = HashMap([]const u8, StarConnection, Allocator) };

    // Add some stars to the map.
    addStar(&starMap, "Sol", 0.0, 0.0);
    addStar(&starMap, "Alpha Centauri", 4.3, 3.2);
    addStar(&starMap, "Sirius", -1.7, 2.8);

    // Add connections between stars with distances.
    addConnection(&starMap, "Sol", "Alpha Centauri", 1.5);
    addConnection(&starMap, "Alpha Centauri", "Sirius", 2.0);

    // Accessing a connection by key.
    const connection = starMap.connections.get("Sol" ++ "Alpha Centauri");
    if (connection != null) {
        std.debug.print("Distance from Sol to Alpha Centauri: {}\n", .{connection.distance});
    }
}
