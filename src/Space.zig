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

pub const EmperialJumpShip = struct {
    hp: u32 = 100,
    shields: u32 = 100,
    fuel: u8 = 100,

    currentStar: ?*Star,

    pub fn init() EmperialJumpShip {
        return .{
            .hp = 100,
            .shields = 100,
            .fuel = 100,
        };
    }

    // Ship Functions
    pub fn setStar() !void {}

    pub fn setPlanet() !void {}

    pub fn takeDamage() !void {}

    pub fn jumpDrive() !void {}

    pub fn warpDrive() !void {}

    pub fn heal() !void {}

    pub fn scanPlanet() !void {}

    pub fn scanStar() !void {}

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("Class: Imperial Jump Ship\n\tHP: {}\nShields: {}\nFuel Levels: {}\n\nCurrent Star: {}\n", .{ self.hp, self.shields, self.fuel, self.currentStar.?.*.name });
    }

    pub fn deinit() !void {}
};

pub const VoidShip = struct {
    hp: u32 = 100,
    shields: u32 = 100,
    fuel: u8 = 100,

    currentStar: ?*Star,

    pub fn init(star: *Star) VoidShip {
        return .{
            .hp = 100,
            .shields = 100,
            .fuel = 100,

            .currentStar = star,
        };
    }

    // Ship Functions
    pub fn setStar() !void {}

    pub fn setPlanet() !void {}

    pub fn takeDamage() !void {}

    pub fn voidDrive(self: *VoidShip, dest: *Star) !void {
        self.currentStar = dest;
    }

    pub fn warpDrive() !void {}

    pub fn heal() !void {}

    pub fn scanPlanet() !void {}

    pub fn scanStar() !void {}

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;
        try writer.print("Class: Roazic Void Ship\n\tHP: {}\nShields: {}\nFuel Levels: {}\n\nCurrent Star: {s}\n", .{ self.hp, self.shields, self.fuel, self.currentStar.?.*.name });
    }

    pub fn deinit() !void {}
};
