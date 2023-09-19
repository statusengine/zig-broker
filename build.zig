const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running zig build to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running zig build to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    //const naemon_header = b.option([]const u8, "naemon_header", "Path to naemon header") orelse "/opt/naemon/include/naemon/naemon.h";
    //const glib_include_path = b.option([]const u8, "glib_include_path", "Path to glib2.0 include dir") orelse "/usr/include/glib-2.0/";

    //const naemon_module = b.addTranslateC(.{
    //    .optimize = optimize,
    //    .target = target,
    //    .source_file = .{ .path = naemon_header },
    //});
    //try naemon_module.include_dirs.append(glib_include_path);

    const lib = b.addSharedLibrary(.{
        .name = "zig-broker",
        // In this case the main source file is merely a path, however, in more
        // complicated build scripts, this could be a generated file.
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.linkLibC();

    //lib.addModule("naemon", naemon_module.createModule());

    // This declares intent for the library to be installed into the standard
    // location when the user invokes the "install" step (the default step when
    // running zig build).
    b.installArtifact(lib);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const main_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_main_tests = b.addRunArtifact(main_tests);

    // This creates a build step. It will be visible in the zig build --help menu,
    // and can be selected like this: zig build test
    // This will evaluate the test step rather than the default, which is "install".
    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&run_main_tests.step);
}
