const std = @import("std");
pub const numStars: u64 = 1000001;
pub const GraphError = error{ NodeExists, EdgeExists, starsDoNotExist, EdgesDoNotExist };

pub const Galaxy = struct {
    allocator: std.mem.Allocator,
    stars: std.StringHashMap(Star),

    pub fn init(Allocator: std.mem.Allocator) Galaxy {
        const stars = std.StringHashMap(Star).init(Allocator);
        return .{
            .allocator = Allocator,
            .stars = stars,
        };
    }

    pub fn deinit(self: *Galaxy) void {
        // Cleanup Hashmap after the program
        for (1..numStars) |value| {
            var buff: [15]u8 = undefined;
            const getKey = std.fmt.bufPrint(&buff, "Star{}", .{value}) catch unreachable;
            const getStar = self.stars.getPtr(getKey);
            try getStar.?.deinit();
        }
        self.* = undefined;
    }
};

pub const Star = struct {
    // allocator: std.mem.Allocator,
    id: u64,
    name: []u8,
    x: f32,
    y: f32,
    jumps: std.ArrayListUnmanaged([]u8) = .{},

    pub fn init(id: u64, name: []u8, x: f32, y: f32) !Star {
        return .{ //.allocator = allocator,
            .id = id,
            .name = name,
            .x = x,
            .y = y,
        };
    }

    pub fn format(
        self: @This(),
        comptime fmt: []const u8,
        options: std.fmt.FormatOptions,
        writer: anytype,
    ) !void {
        _ = fmt;
        _ = options;

        try writer.print("star:\nname: \"{s}\"\tx: {d:1.1}, y: {d:1.1}\n", .{ self.name, self.x, self.y });
    }

    pub fn deinit(self: *Star) !void {
        _ = self;
    }

    pub const Jump = struct {
        distance: usize,
    };
};

pub fn generateStars(alloc: std.mem.Allocator, self: *std.StringHashMap(Star), galaxy: Galaxy) !void {
    const Cascadia = galaxy;
    var random = std.rand.DefaultPrng.init(0);
    var prev_Star: Star = undefined;
    for (1..numStars) |i| {
        if (i == 1) {
            const starName = try std.fmt.allocPrint(alloc, "Star{}", .{i});
            const stddev_x: f32 = 1.0;
            const stddev_y: f32 = 1.0;
            const x = random.random().floatNorm(f32) * stddev_x;
            const y = random.random().floatNorm(f32) * stddev_y;
            const starInit = try Star.init(i, starName, x, y);
            try self.put(starInit.name, starInit);
            prev_Star = starInit;
            continue;
        } else {
            const starName = try std.fmt.allocPrint(alloc, "Star{}", .{i});
            const stddev_x: f32 = 10.0;
            const stddev_y: f32 = 10.0;
            const prevStarMeanX = prev_Star.x;
            const prevStarMeanY = prev_Star.y;
            const x = random.random().floatNorm(f32) * stddev_x + prevStarMeanX;
            const y = random.random().floatNorm(f32) * stddev_y + prevStarMeanY;
            var starInit = try Star.init(i, starName, x, y);
            // const jump = Star.Jump{
            //     .distance = random.random().uintLessThan(usize, 10),
            // };
            _ = try addJump(alloc, &prev_Star, &starInit, Cascadia);
            try self.put(starInit.name, starInit);
            prev_Star = starInit;
            continue;
        }
    }
}

pub fn addJump(allocator: std.mem.Allocator, from: *Star, to: *Star, galaxy: Galaxy) !void {
    if (galaxy.stars.getEntry(from.name)) |from_star| {
        try from_star.value_ptr.*.jumps.append(allocator, to.name);
        try to.jumps.append(allocator, from.name);
    } else {
        std.debug.print("no Entry Found", .{});
    }
}
