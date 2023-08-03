const std = @import("std");
const Ship = struct {
    hp: u32,
    shields: u32,

    pub fn take_damage(self: Ship, damage: u32) u32 {
        return self.hp - damage;
    }

    pub fn init(hp: u32, shields: u32) Ship {
        return Ship{
            .hp = hp,
            .shields = shields,
        };
    }
};
pub fn main() !void {
    const Capitol = Ship.init(100, 100);

    const hp = Capitol.hp;

    const current_hp: u32 = Capitol.take_damage(50);

    std.debug.print("Original HP: {}\nNew Hp: {}", .{ hp, current_hp });
    // A terminal application that tracks the values of the various systems on a starfield ship.
    // IDEA: A Server and Client program for collaboration, and ship combat.
    // IDEA: A Main menu that takes you to eeach of the system pages
    // IDEA: Very Old Fashioned with no graphics, the menu should be printed often
    // IDEA: A quick way to import new ship types, and info
    // IDEA: save data
    // IDEA: I want it to feel like a terminal deep in the bowels of an Artificers ship
    // IDEA:
    // IDEA:
    // IDEA: I could try to implement in C first and port it over?
    // IDEA:
    // TODO: Learn about build.zig and linking libraries
    // TODO: Learn about creating custom types for the Ships, Planets, Stars, and the Galaxy
    //
}
