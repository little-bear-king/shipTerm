const std = @import("std");
const Space = @import("Space.zig");
const Galaxy = @import("Space.zig").Galaxy;

pub fn trimWindowsReturn(buffer: []u8) ![]const u8 {
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, buffer, "\r");
    } else {
        return buffer;
    }
}

pub fn goodBye() void {
    std.debug.print("Logging off...\n", .{});
    std.debug.print("Goodbye!\n", .{});
    std.process.exit(0);
}

pub fn exportJSON(galaxy: Galaxy) !void {
    const options = std.json.StringifyOptions{};
    if (@TypeOf(std.fs.cwd().openDir("json", .{})) == std.fs.Dir) {
        try std.fs.cwd().deleteTree("json");
    }
    std.fs.cwd().makeDir("json") catch |err| std.debug.print("Folder Exists: {}", .{err});
    var file = try std.fs.cwd().createFile("json/stars.json", .{});
    defer file.close();

    std.debug.print("EXPORTING STARS TO JSON", .{});
    for (0..Space.numStars) |value| {
        var buff: [15]u8 = undefined;
        const starName = try std.fmt.bufPrint(&buff, "Star{}", .{value});
        const star = galaxy.stars.getPtr(starName);
        if (star != null) {
            _ = try std.json.stringify(star, options, file.writer());
        }
        _ = try file.write("\n");
        if (value % 100 == 0) {
            std.debug.print("processed: {}/{}\n", .{ value, Space.numStars });
        }
    }
}

pub const ANSI_CODES = struct {
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

    pub const term_on = screen_buf_on ++ cursor_hide ++ cursor_home ++ screen_clear ++ color_def;
    pub const term_off = screen_buf_off ++ cursor_show ++ nl;
};
