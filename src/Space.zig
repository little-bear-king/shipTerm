const std = @import("std");

pub const Star = struct {
    allocator: std.mem.Allocator,
    name: []u8,
    planets: std.AutoHashMap(usize, Planet),
    x: f32,
    y: f32,
    neighbors: ?[]*Star = null,

    pub fn init(allocator: std.mem.Allocator, name: []u8, x: f32, y: f32) !Star {
        const planets = std.AutoHashMap(usize, Planet).init(allocator);
        return .{ .allocator = allocator, .name = try allocator.dupe(u8, name), .planets = planets, .x = x, .y = y };
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
    // Use to add a planet without an array
    pub fn addOnePlanet(self: *Star, planet: Planet) !void {
        self.planets.put(self.planets.count() + 1, planet);
    }
    // Use for multiple planets in an array
    pub fn addPlanets(self: *Star, planets: []Planet) !void {
        for (planets, 0..) |planet, i| {
            self.planets.put(i, planet);
        }
    }

    // pub fn getPlanets(self: *Star, planet: Planet) !void {
    //    self.planets.put(planet.name, planet);
    // }
    pub fn addNeighbor() !void {
        std.debug.print("NOT IMPLEMENTED: addNeighbor()", .{});
    }

    pub fn deinit(self: *Star) !void {
        self.allocator.free(self.name);
        self.planets.deinit();
    }
};

pub const Planet = struct {
    allocator: std.mem.Allocator,
    name: []u8,
    star: *Star,
    dist: u8,

    pub fn init(allocator: std.mem.Allocator, name: []u8, star: *Star, dist: u8) !Planet {
        return .{ .allocator = allocator, .name = try allocator.dupe(u8, name), .star = star, .dist = dist };
    }

    pub fn deinit(self: *Planet) !void {
        self.allocator.free(self.name);
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("Planet:\nname: \"{s}\"\tStar: {d}, distance from star: {d}\n", .{ self.name, self.star.name, self.dist });
    }
};

