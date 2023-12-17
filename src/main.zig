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
const terminal = @import("term/terminal.zig");
const Ship = @import("Ship.zig");
const Space = @import("Space.zig");
const GalaxyGraph = @import("graph.zig").GalaxyGraph;
const Star = Space.Star;
const numStars = Space.numStars;

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
    try Space.generateStars(&Galaxy.nodes, Alloc);

    // Start the Shell
    try terminal.shiptermShell(Galaxy);

    // Cleanup Hashmap after the program
    for (1..numStars) |value| {
        var buff: [15]u8 = undefined;
        const getKey = try std.fmt.bufPrint(&buff, "Star{}", .{value});
        const getStar = Galaxy.nodes.getPtr(getKey);
        try getStar.?.deinit();
    }
}
