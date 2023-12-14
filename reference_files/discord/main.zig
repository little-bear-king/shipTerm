const std = @import("std");

const Allocator = std.mem.Allocator;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer std.debug.assert(gpa.deinit() == .ok);

    const allocator = gpa.allocator();

    var galaxy = Galaxy.init(allocator);
    defer galaxy.deinit();

    const star_a = try galaxy.addStar(.{ .name = "A" });
    const star_b = try galaxy.addStar(.{ .name = "B" });
    const star_c = try galaxy.addStar(.{ .name = "C" });

    _ = try galaxy.addJump(star_a, star_b, .{ .distance = 1 });
    _ = try galaxy.addJump(star_b, star_c, .{ .distance = 3 });
    _ = try galaxy.addJump(star_a, star_c, .{ .distance = 2 });

    const sa = galaxy.getStar(star_a).?;
    const sb = galaxy.getStar(star_b).?;
    const sc = galaxy.getStar(star_c).?;

    std.debug.print("{s}: {any}\n", .{ sa.name, sa.jumps.items });
    std.debug.print("{s}: {any}\n", .{ sb.name, sb.jumps.items });
    std.debug.print("{s}: {any}\n", .{ sc.name, sc.jumps.items });
}

const Galaxy = struct {
    allocator: Allocator,
    stars: StarMap,

    fn init(allocator: Allocator) Galaxy {
        return Galaxy{
            .allocator = allocator,
            .stars = StarMap.init(allocator),
        };
    }

    fn deinit(galaxy: *Galaxy) void {
        var stars_iter = galaxy.stars.iterator();

        while (stars_iter.next()) |star| {
            star.value_ptr.jumps.deinit(galaxy.allocator);
        }

        galaxy.stars.deinit();
        galaxy.* = undefined;
    }

    fn addStar(galaxy: *Galaxy, star: Star) Allocator.Error!StarId {
        const star_id = galaxy.stars.count();
        try galaxy.stars.put(star_id, star);
        return star_id;
    }

    fn addJump(
        galaxy: *Galaxy,
        from: StarId,
        to: StarId,
        jump: Jump,
    ) Allocator.Error!bool {
        if (galaxy.stars.getEntry(from)) |from_star| {
            if (galaxy.stars.getEntry(to)) |to_star| {
                try from_star.value_ptr.jumps.append(galaxy.allocator, .{
                    .to = to,
                    .extra = jump,
                });
                try to_star.value_ptr.jumps.append(galaxy.allocator, .{
                    .to = from,
                    .extra = jump,
                });
                return true;
            }
        }

        return false;
    }

    fn getStar(galaxy: *Galaxy, star_id: StarId) ?*Star {
        return galaxy.stars.getPtr(star_id);
    }

    const Star = struct {
        name: []const u8,
        jumps: std.ArrayListUnmanaged(struct {
            to: StarId,
            extra: Jump,
        }) = .{},
    };

    const Jump = struct {
        distance: usize,
    };

    const StarId = u32;
    const StarMap = std.AutoHashMap(StarId, Star);
};
