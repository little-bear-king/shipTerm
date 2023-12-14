const std = @import("std");

const Star = struct {
    name: []const u8,
    x: f64,
    y: f64,

    fn init(name: []const u8, x: f64, y: f64) !Star {
        return Star{
            .name = name,
            .x = x,
            .y = y,
        };
    }
};

// const Stars = {
//     var stars: []Star = {
//         Star.init("Sol", 0.0, 0.0);
//         Star.init("Alpha Centauri", 4.3, 3.2);
//         Star.init("Sirius", -1.7, 2.8);
//         // Add more stars here...
//     };
//     stars;
// };

pub fn main() void {
    const Stars = {
        var stars: []Star = {
            const star1 = try Star.init("Sol", 0.0, 0.0);
            _ = star1;
            const star2 = try Star.init("Alpha Centauri", 4.3, 3.2);
            _ = star2;
            const star3 = try Star.init("Sirius", -1.7, 2.8);
            _ = star3;
        };
        stars;
    };
    // Access the precomputed star data at runtime.
    for (Stars) |star| {
        std.debug.print("Star: {}, x: {}, y: {}\n", .{ star.name, star.x, star.y });
    }
}
