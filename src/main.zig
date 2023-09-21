const std = @import("std");
const fmt = std.fmt;
const zap = @import("zap");
const thread = std.Thread;
const semaphore = std.Thread.Semaphore;
const naemon = @import("./naemon.zig");

export const __neb_api_version: c_int = naemon.CURRENT_NEB_API_VERSION;

var broker_handle: ?*naemon.nebmodule = null;
var server: std.Thread = undefined;

export fn nebmodule_init(_: c_int, _: [*]c_char, handle: *naemon.nebmodule) c_int {
    broker_handle = handle;

    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_TITLE, @as([*c]u8, "Naemon Event Broker written in Zig"));
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_AUTHOR, "Contributors of Statusengine");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_VERSION, "1.0");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_LICENSE, "GNU General Public License, version 2");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_DESC, "Naemon Event Broker written in Zig");

    naemon.nm_log(naemon.NSLOG_INFO_MESSAGE, "Naemon Event Broker written in Zig");

    _ = naemon.neb_register_callback(naemon.NEBCALLBACK_SERVICE_CHECK_DATA, broker_handle, 0, handle_service_check_data);

    server = thread.spawn(.{}, startWebserver, .{}) catch {
        return 1;
    };

    return 0;
}

export fn nebmodule_deinit(_: c_int, reason: c_int) c_int {
    _ = naemon.neb_deregister_callback(naemon.NEBCALLBACK_SERVICE_CHECK_DATA, broker_handle);

    server.join();

    naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "bye from zig");
    _ = reason;
    return 0;
}

pub fn handle_service_check_data(_: c_int, data: ?*anyopaque) callconv(.C) c_int {
    var service_check: *naemon.nebstruct_service_check_data = @ptrCast(@alignCast(data.?));
    naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "Got service check from service: '%s'!", service_check.service_description);

    return 0;
}

fn startWebserver() !void {
    std.debug.print("This is THREAD!!", .{});

    var listener = zap.SimpleHttpListener.init(.{
        .port = 3000,
        .on_request = on_request,
        .public_folder = "examples/serve",
        .log = true,
    });
    try listener.listen();

    std.debug.print("Listening on 0.0.0.0:3000\n", .{});

    // start worker threads
    zap.start(.{
        .threads = 2,
        .workers = 2,
    });
}

fn on_request(r: zap.SimpleRequest) void {
    r.setStatus(.not_found);
    r.sendBody("<html><body><h1>404 - File not found</h1></body></html>") catch return;
}
