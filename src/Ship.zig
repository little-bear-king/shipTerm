const std = @import("std");
const Space = @import("Space.zig");
const Galaxy = Space.Galaxy;
const Star = Space.Star;
const utils = @import("utils.zig");

pub var currentStar: Space.StarId = 1;

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

pub fn setStar(firstStar: Space.StarId, userStar: []u8) void {
    const answer = std.fmt.parseInt([]u8, userStar, 10);
    firstStar = answer;
}

pub fn scanStar(galaxy: Galaxy) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    while (true) {
        try writer.writeAll("What's the StarId of the star?: ");

        var input_buffer: [15]u8 = undefined;
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
            const preprocess = try utils.trimWindowsReturn(userInput);
            if (std.mem.eql(u8, preprocess, "exit")) {
                try writer.print("{s}", .{utils.ANSI_CODES.term_on});
                break;
            }
            const processed = try std.fmt.parseInt(u64, preprocess, 10);
            const hmm = galaxy.stars.getEntry(processed);
            if (hmm == null) {
                std.debug.print("Star not found in our database.\nRemember Capitalization is Important\n\n\n", .{});
                continue;
            }
            const answer = galaxy.stars.getPtr(processed);
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
