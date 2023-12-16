const std = @import("std");
const Star = @import("Space.zig").Star;
const GalaxyGraph = @import("graph.zig").GalaxyGraph;
const utils = @import("utils.zig");

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

pub fn scanStar(alloc: std.mem.Allocator, writer: anytype, reader: anytype, galaxy: GalaxyGraph) !void {
    try writer.writeAll("What's the name of the star?: ");

    const userInput: []u8 = try reader.readUntilDelimiterAlloc(alloc, '\n', 512);
    try writer.writeAll("\n");
    defer alloc.free(userInput);
    if (@TypeOf(userInput) == []u8) {
        const processed = try utils.trimWindowsReturn(userInput);
        const hmm = galaxy.nodes.getEntry(processed);
        if (hmm == null) {
            std.debug.print("Star not found in our database. Remember Capitalization is Important\n ", .{});
            return;
        }
        const answer = galaxy.nodes.getPtr(processed);
        try writer.print("{}\n", .{answer.?.*});
        try writer.print("ENTER TO CONTINUE\n", .{});
        if (@import("builtin").os.tag == .windows) {
            _ = try reader.readUntilDelimiterAlloc(alloc, '\r', 8);
            return;
        } else {
            _ = try reader.readUntilDelimiterAlloc(alloc, '\n', 8);
            return;
        }
    }
    return;
}
