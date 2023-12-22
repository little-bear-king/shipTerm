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
const Galaxy = Space.Galaxy;
const Star = Space.Star;
const numStars = Space.numStars;

pub fn main() !void {
    // Create the Edges
    // How do I make the edges based off of distance?

    // Create Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const Alloc = gpa.allocator();

    // create the Galaxy to strore the Stars
    var Cascadia = Galaxy.init(Alloc);
    //Generate the Stars
    try Space.generateStars(Alloc, &Cascadia.stars, Cascadia);

    // Create the edges and add them to the star objects
    // Start the Shell
    try terminal.shiptermShell(Cascadia);
}
