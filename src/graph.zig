// Because I want only neighbor stars to have paths to them, I do not want to
// use the Adj Matrix. This data structure holds info for each node just in case one is connected
// to all other nodes
//
// I will use Adjacency Lists, which invovle linked lists for each node.
// An Array of Lists is used to store edges between two verticies
//
const std = @import("std");
const Star = @import("Space.zig").Star;
const ArrayList = std.ArrayList;
const AutoArrayHashMap = std.AutoArrayHashMap;

pub const GraphError = error{ NodeExists, EdgeExists, NodesDoNotExist, EdgesDoNotExist };

pub const GalaxyGraph = struct {
    nodes: std.StringHashMap(Star),
    edges: u8,

    pub fn init(Allocator: std.mem.Allocator) GalaxyGraph {
        const node = std.StringHashMap(Star).init(Allocator);
        return .{
            .nodes = node,
            .edges = 0,
        };
    }

    pub fn addNode() !void {}
    pub fn addEdge() !void {}

    pub fn getNodeData() !void {}
    pub fn getEdgeData() !void {}

    pub fn removeNode() !void {}
    pub fn removeEdge() !void {}

    pub fn bfs() !void {}
    pub fn dfs() !void {}

    pub fn format() !void {}
    pub fn deinit() !void {}
};
