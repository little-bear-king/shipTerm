const std = @import("std");
const Star = @import("Space.zig").Star;

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
