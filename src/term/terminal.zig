const std = @import("std");
const Galaxy = @import("../Space.zig").Galaxy;
const utils = @import("../utils.zig");
const Ship = @import("../Ship.zig");

const max_input = 512;

pub fn shiptermShell(galaxy: Galaxy, allocator: std.mem.Allocator) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    var loopTracker: u64 = 1;
    while (true) {
        if (loopTracker == 1) {
            try writer.writeAll(utils.ANSI_CODES.term_on);
            var input_buffer: [max_input]u8 = undefined;

            const setStar = "Please enter the current star: ";
            try writer.writeAll(setStar);
            const userSetStar = (try reader.readUntilDelimiterOrEof(
                &input_buffer,
                '\n',
            )) orelse {
                //no input, probably CTRL-D. Pring new line and exit!
                try writer.print("\n", .{});
                continue;
            };

            Ship.setStar(Ship, userSetStar);
            std.debug.print("{}\n", .{Ship.currentStar});
        }
        const mainOptions =
            \\1. Jump Drive
            \\2. Scan Star
            \\3. Export JSON
            \\4. Quit Nav System
            // manual shell mode
            // target star
            // target Planet
            // ship diagnostics
        ;

        var input_buffer: [max_input]u8 = undefined;
        const promptMain = "shipTerm Main > ";
        try writer.writeAll(mainOptions);
        try writer.writeAll("\n\n");

        try writer.writeAll(promptMain);
        loopTracker += 1;
        const userInput = (try reader.readUntilDelimiterOrEof(
            &input_buffer,
            '\n',
        )) orelse {
            //no input, probably CTRL-D. Pring new line and exit!
            try writer.print("\n", .{});
            continue;
        };
        try writer.print("\n\n", .{});

        const input = try utils.trimWindowsReturn(userInput);

        if (input.len == 0) {
            try writer.writeAll("Please enter an Option\n\n\n");
        } else {
            const parsedIn = try std.fmt.parseInt(u8, input, 10);
            switch (parsedIn) {
                1 => try writer.writeAll("Option 1\n\n"), // Ship.jumpDrive(*Star); Set current_Location to new star;
                2 => try Ship.scanStar(galaxy),
                3 => try utils.exportJSON(galaxy, allocator),
                4 => utils.goodBye(),
                else => try writer.writeAll("Not an Option\n\n"),
            }
        }
    }
}

pub fn goodBye() void {
    std.debug.print("Logging off...\n", .{});
    std.debug.print("Goodbye!\n", .{});
    std.debug.print("{}", .{utils.ANSI_CODES.term_off});
    std.process.exit(0);
}
