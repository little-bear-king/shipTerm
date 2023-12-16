const std = @import("std");
const GalaxyGraph = @import("../graph.zig").GalaxyGraph;
const utils = @import("../utils.zig");
const Ship = @import("../Ship.zig");

pub fn shiptermShell(allocator: std.mem.Allocator, reader: anytype, writer: anytype, Galaxy: GalaxyGraph) !void {
    while (true) {
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
        try writer.writeAll(ANSI_CODES.term_on);
        const promptMain = "shipTerm Main > ";
        try writer.writeAll(mainOptions);
        try writer.writeAll("\n\n");

        try writer.writeAll(promptMain);
        const userInput: []u8 = try reader.readUntilDelimiterAlloc(allocator, '\n', 512);
        try writer.writeAll("\n\n");
        defer allocator.free(userInput);

        const input = try utils.trimWindowsReturn(userInput);

        if (input.len == 0) {
            try writer.writeAll("Please enter an Option\n\n\n");
        } else {
            const parsedIn = try std.fmt.parseInt(u8, input, 10);
            switch (parsedIn) {
                1 => try writer.writeAll("Option 1\n\n"), // Ship.jumpDrive(*Star); Set current_Location to new star;
                2 => try Ship.scanStar(allocator, writer, reader, Galaxy),
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
    std.debug.print("{}", .{ANSI_CODES.term_off});
    std.process.exit(0);
}

const ANSI_CODES = struct {
    const esc = "\x1B";
    const csi = esc ++ "[";

    const cursor_show = csi ++ "?25h"; //h=high
    const cursor_hide = csi ++ "?25l"; //l=low
    const cursor_home = csi ++ "1;1H"; //1,1

    const color_fg = "38;5;";
    const color_bg = "48;5;";
    const color_fg_def = csi ++ color_fg ++ "208m"; //
    //const color_bg_def = csi ++ color_bg ++ "58m"; //
    const color_def = color_fg_def;

    const screen_clear = csi ++ "2J";
    const screen_buf_on = csi ++ "?1049h"; //h=high
    const screen_buf_off = csi ++ "?1049l"; //l=low

    const nl = "\n";

    const term_on = screen_buf_on ++ cursor_hide ++ cursor_home ++ screen_clear ++ color_def;
    const term_off = screen_buf_off ++ cursor_show ++ nl;
};
