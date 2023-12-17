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

pub fn scanStar(galaxy: GalaxyGraph) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    while (true) {
        try writer.writeAll("What's the name of the star?: ");

        var input_buffer: [100]u8 = undefined;
        const userInput = (try reader.readUntilDelimiterOrEof(
            input_buffer[0..],
            '\n',
        )) orelse {
            //no input, probably CTRL-D. Pring new line and exit!
            try writer.print("Please enter a valid value\n", .{});
            continue;
        };
        try writer.writeAll("\n");
        if (@TypeOf(userInput) == []u8) {
            const processed = try utils.trimWindowsReturn(userInput);
            if (std.mem.eql(u8, processed, "exit")) {
                try writer.print("{s}", .{utils.ANSI_CODES.term_on});
                break;
            }
            const hmm = galaxy.nodes.getEntry(processed);
            if (hmm == null) {
                std.debug.print("Star not found in our database.\nRemember Capitalization is Important\n\n\n", .{});
                continue;
            }
            const answer = galaxy.nodes.getPtr(processed);
            try writer.print("{}\n", .{answer.?.*});
            try writer.print("ENTER TO CONTINUE\n", .{});
            input_buffer = undefined;
            var continue_buffer: [8]u8 = undefined;
            if (@import("builtin").os.tag == .windows) {
                _ = try reader.readUntilDelimiterOrEof(continue_buffer[0..], '\r');
                break;
            } else {
                _ = try reader.readUntilDelimiterOrEof(continue_buffer[0..], '\n');
                break;
            }
        }
    }
    return;
}
