const std = @import("std");
const rand = @import("std").rand;

const CharSet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"; // Define the character set for the string.

pub fn generateRandomString(rng: *rand.DefaultPrng, length: usize) []const u8 {
    var result: [length]u8 = undefined;

    for (result) |char, idx| {
        const randomIndex = rng.nextInt(0, CharSet.len);
        char = CharSet[randomIndex];
    }

    return result[0..length];
}

pub fn main() void {
    const rng = rand.DefaultPrng.init(0); // Initialize the random number generator.
    const randomString = generateRandomString(&rng, 8); // Generate an 8-character random string.
    
    std.debug.print("Random String: {}\n", .{randomString});
}

