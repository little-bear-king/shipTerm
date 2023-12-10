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
const Space = @import("Space");
const Star = Space.Star;

const numStars: u32 = 10001;

pub fn main() !void {
    // Create Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const Alloc = gpa.allocator();

    // create hasmap for Star Generation
    var my_hash_map = std.StringHashMap(Star).init(Alloc);
    defer my_hash_map.deinit();

    //Generate the Stars
    try generateStars(&my_hash_map, Alloc);

    // Start the Shell
    try shiptermShell(Alloc);

    // Cleanup Hashmap after the program
    for (1..numStars) |value| {
        const getKey = try std.fmt.allocPrint(Alloc, "Star{}", .{value});
        const getStar = my_hash_map.getPtr(getKey);
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


fn shiptermShell(allocator: std.mem.Allocator) !void {
    const reader = std.io.getStdIn().reader();
    const writer = std.io.getStdOut().writer();

    while (true) {
        const mainOptions =  
                            \\1. Jump Drive
                            \\2. Scan Star
                            \\3. Scan Planet
                            \\4. Quit Nav System
        ;

        const promptMain = "shipTerm Main > ";
        try writer.writeAll(mainOptions);
        try writer.writeAll("\n\n");

        try writer.writeAll(promptMain);
        const input: []u8 = try reader.readUntilDelimiterAlloc(allocator, '\n', 512);
        try writer.writeAll("\n\n");
        defer allocator.free(input);

        if (input.len == 0) {
            try writer.writeAll("Please enter an Option\n\n\n");
        } else {
            const parsedIn = try std.fmt.parseInt(u8, input, 10);
            switch (parsedIn) {
                1 => try writer.writeAll("Option 1\n\n"),
                2 => try writer.writeAll("Option 2\n\n"),
                3 => try writer.writeAll("Option 3\n\n"),
                4 => try writer.writeAll("Option 4\n\n"),
                else => try writer.writeAll("Not an Option\n\n"),
            }
        }

    }
}

