const std = @import("std");
const naemon = @import("./naemon.zig");

export const __neb_api_version: c_int = naemon.CURRENT_NEB_API_VERSION;

export fn nebmodule_init(_: c_int, _: [*]c_char, handle: *naemon.nebmodule) c_int {
    naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "hello from zig");
    _ = handle;
    return 0;
}

export fn nebmodule_deinit(_: c_int, reason: c_int) c_int {
    naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "bye from zig");
    _ = reason;
    return 0;
}
