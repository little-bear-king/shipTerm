const std = @import("std");
pub const numStars: u64 = 1000001;
pub const GraphError = error{ NodeExists, EdgeExists, starsDoNotExist, EdgesDoNotExist };
pub const StarId = u64;

pub const Galaxy = struct {
    allocator: std.mem.Allocator,
    stars: std.AutoHashMap(StarId, Star),

    pub fn init(Allocator: std.mem.Allocator) Galaxy {
        const stars = std.AutoHashMap(StarId, Star).init(Allocator);
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

    pub fn generateStars(galaxy: *Galaxy, alloc: std.mem.Allocator) !void {
        var random = std.rand.DefaultPrng.init(0);
        var prev_Star: Star = undefined;
        for (1..numStars) |i| {
            if (i == 1) {
                const starName = try std.fmt.allocPrint(alloc, "Star{}", .{i});
                const stddev_x: f32 = 1.0;
                const stddev_y: f32 = 1.0;
                const x = random.random().floatNorm(f32) * stddev_x;
                const y = random.random().floatNorm(f32) * stddev_y;
                const starInit = try Star.init(i, starName, x, y, galaxy);
                try galaxy.stars.put(starInit.id, starInit);
                prev_Star = starInit;
                continue;
            } else {
                const starName = try std.fmt.allocPrint(alloc, "Star{}", .{i});
                const stddev_x: f32 = 1.0;
                const stddev_y: f32 = 1.0;
                const prevStarMeanX = prev_Star.x;
                const prevStarMeanY = prev_Star.y;
                const x = random.random().floatNorm(f32) * stddev_x + prevStarMeanX;
                const y = random.random().floatNorm(f32) * stddev_y + prevStarMeanY;
                const starInit = try Star.init(i, starName, x, y, galaxy);
                const jump = Star.Jump{
                    .distance = random.random().uintLessThan(usize, 10),
                };
                try galaxy.stars.put(starInit.id, starInit);
                _ = try galaxy.addJump(starInit.id, prev_Star.id, jump);
                prev_Star = starInit;
            }
        }
    }

    pub fn addJump(
        galaxy: *Galaxy,
        from: StarId,
        to: StarId,
        jump: Star.Jump,
    ) !bool {
        if (galaxy.stars.getEntry(from)) |from_star| {
            if (galaxy.stars.getEntry(to)) |to_star| {
                try from_star.value_ptr.*.jumps.append(galaxy.allocator, .{
                    .to = to,
                    .extra = jump,
                });
                try to_star.value_ptr.*.jumps.append(galaxy.allocator, .{
                    .to = from,
                    .extra = jump,
                });
                return true;
            }
        }

        return false;
    }
};

pub const Star = struct {
    // allocator: std.mem.Allocator,
    id: StarId,
    name: []u8,
    x: f32,
    y: f32,
    jumps: std.ArrayListUnmanaged(struct {
        to: StarId,
        extra: Jump,
    }) = .{},
    galaxy: *Galaxy,

    pub fn init(id: StarId, name: []u8, x: f32, y: f32, galaxy: *Galaxy) !Star {
        return .{ //.allocator = allocator,
            .id = id,
            .name = name,
            .x = x,
            .y = y,
            .galaxy = galaxy,
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

        try writer.print("star:\nid: {}\nname: \"{s}\"\tx: {d:1.1}, y: {d:1.1}\n", .{ self.id, self.name, self.x, self.y });
        try writer.print("\tjumps:\n", .{});
        for (self.jumps.items) |item| {
            const star = self.galaxy.stars.getEntry(item.to);
            const name = star.?.value_ptr.*.name;
            try writer.print("\t\tto: {s}\n", .{name});
            try writer.print("\t\tdistance: {}\n\n", .{item.extra.distance});
        }
    }

    pub fn deinit(self: *Star) !void {
        _ = self;
    }

    pub const Jump = struct {
        distance: usize,
    };
};
