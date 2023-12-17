const std = @import("std");
const GalaxyGraph = @import("../graph.zig").GalaxyGraph;
const utils = @import("../utils.zig");
const Ship = @import("../Ship.zig");

const max_input = 512;

pub fn shiptermShell(Galaxy: GalaxyGraph) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    var loopTracker: u64 = 1;
    while (true) {
        if (loopTracker == 1) {
            try writer.writeAll(utils.ANSI_CODES.term_on);
        }
        const mainOptions =
            \\1. Jump Drive
            \\2. Scan Star
            \\3. Scan Planet
            \\4. Quit Nav System
            // manual shell mode
            // target star
            // target Planet
            // ship diagnostics
        ;
        const promptMain = "shipTerm Main > ";
        try writer.writeAll(mainOptions);
        try writer.writeAll("\n\n");

        var input_buffer: [max_input]u8 = undefined;

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
                2 => try Ship.scanStar(Galaxy),
                3 => try writer.writeAll("Option 3\n\n"),
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