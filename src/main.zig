// A terminal application that tracks the values of the various systems on a starfield ship.
// IDEA: A Server and Client program for collaboration, and ship combat.
// IDEA: A Main menu that takes you to eeach of the system pages
// IDEA: Very Old Fashioned with no graphics, the menu should be printed often
// IDEA: A quick way to import new ship types, and info
// IDEA: save data
// IDEA: I want it to feel like a terminal deep in the bowels of an Artificers ship

const std = @import("std");
const rand = @import("std").rand;
const Allocator = std.mem.Allocator;
const utils = @import("utils.zig");
const Space = @import("Space.zig");
const GalaxyGraph = @import("graph.zig").GalaxyGraph;
const Star = Space.Star;

const numStars: u32 = 10001;

pub fn main() !void {

    // Create the GalaxyGraph
    // Create A Star
    // Add Star to the Graph
    // Have all Stars Created
    // Create the Edges
    // How do I make the edges based off of distance?
    // Start the Shell

    // Create Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const Alloc = gpa.allocator();

    // create the Galaxy to strore the Stars
    var Galaxy = GalaxyGraph.init(Alloc);
    //Generate the Stars
    try generateStars(&Galaxy.nodes, Alloc);

    // Start the Shell
    try shiptermShell(Alloc, Galaxy);

    // Cleanup Hashmap after the program
    for (1..numStars) |value| {
        const getKey = try std.fmt.allocPrint(Alloc, "Star{}", .{value});
        const getStar = Galaxy.nodes.getPtr(getKey);
        try getStar.?.deinit();
    }
}

fn generateStars(self: *std.StringHashMap(Star), alloc: std.mem.Allocator) !void {
    var random = rand.DefaultPrng.init(0);
    for (1..numStars) |i| {
        const starName = try std.fmt.allocPrint(alloc, "Star{}", .{i});
        const stddev_x: f32 = 10.0;
        const stddev_y: f32 = 10.0;
        const x = random.random().floatNorm(f32) * stddev_x;
        const y = random.random().floatNorm(f32) * stddev_y;
        const starInit = try Star.init(alloc, starName, x, y);
        try self.put(starInit.name, starInit);
    }
}

fn shiptermShell(allocator: std.mem.Allocator, Galaxy: GalaxyGraph) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    while (true) {
        const mainOptions =
            \\1. Jump Drive
            \\2. Scan Star
            \\3. Scan Planet
            \\4. Quit Nav System
            // target star
            // target Planet
            // ship diagnostics
        ;

        const promptMain = "shipTerm Main > ";
        try writer.writeAll(mainOptions);
        try writer.writeAll("\n\n");

        try writer.writeAll(promptMain);
        const userInput: []u8 = try reader.readUntilDelimiterAlloc(allocator, '\n', 512);
        try writer.writeAll("\n\n");
        defer allocator.free(userInput);

        const input = try trimWindowsReturn(userInput);

        if (input.len == 0) {
            try writer.writeAll("Please enter an Option\n\n\n");
        } else {
            const parsedIn = try std.fmt.parseInt(u8, input, 10);
            switch (parsedIn) {
                1 => try writer.writeAll("Option 1\n\n"),
                2 => try scanStar(allocator, writer, reader, Galaxy),
                3 => try writer.writeAll("Option 3\n\n"),
                4 => goodBye(),
                else => try writer.writeAll("Not an Option\n\n"),
            }
        }
    }
}

fn trimWindowsReturn(buffer: []u8) ![]const u8 {
    if (@import("builtin").os.tag == .windows) {
        return std.mem.trimRight(u8, buffer, "\r");
    } else {
        return buffer;
    }
}
fn scanStar(alloc: std.mem.Allocator, writer: anytype, reader: anytype, galaxy: GalaxyGraph) !void {
    try writer.writeAll("What's the name of the star?: ");

    const userInput: []u8 = try reader.readUntilDelimiterAlloc(alloc, '\n', 512);
    try writer.writeAll("\n");
    defer alloc.free(userInput);
    if (@TypeOf(userInput) == []u8) {
        const processed = try trimWindowsReturn(userInput);
        const hmm = galaxy.nodes.getEntry(processed);
        if (hmm == null) {
            std.debug.print("Star not found in our database. Remember Capitalization is Important\n ", .{});
            return;
        }
        const answer = galaxy.nodes.getPtr(processed);
        try writer.print("{}\n", .{answer.?.*});
        try writer.print("ENTER TO CONTINUE\n", .{});
        _ = try reader.readUntilDelimiterAlloc(alloc, '\n', 512);
    }
    return;
}
fn goodBye() void {
    std.debug.print("Logging off...\n", .{});
    std.debug.print("Goodbye!\n", .{});
    std.process.exit(0);
}
