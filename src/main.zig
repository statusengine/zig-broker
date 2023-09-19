const std = @import("std");
const fmt = std.fmt;
const naemon = @import("./naemon.zig");

export const __neb_api_version: c_int = naemon.CURRENT_NEB_API_VERSION;

var broker_handle: ?*naemon.nebmodule = null;

export fn nebmodule_init(_: c_int, _: [*]c_char, handle: *naemon.nebmodule) c_int {
    broker_handle = handle;

    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_TITLE, @as([*c]u8, "Naemon Event Broker written in Zig"));
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_AUTHOR, "Contributors of Statusengine");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_VERSION, "1.0");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_LICENSE, "GNU General Public License, version 2");
    //naemon.neb_set_module_info(broker_handle, naemon.NEBMODULE_MODINFO_DESC, "Naemon Event Broker written in Zig");

    naemon.nm_log(naemon.NSLOG_INFO_MESSAGE, "Naemon Event Broker written in Zig");

    _ = naemon.neb_register_callback(naemon.NEBCALLBACK_SERVICE_STATUS_DATA, broker_handle, 0, handle_service_check_data);

    return 0;
}

export fn nebmodule_deinit(_: c_int, reason: c_int) c_int {
    _ = naemon.neb_deregister_callback(naemon.NEBCALLBACK_SERVICE_STATUS_DATA, broker_handle);

    naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "bye from zig");
    _ = reason;
    return 0;
}

pub fn handle_service_check_data(event_type: c_int, data: ?*anyopaque) callconv(.C) c_int {
    _ = event_type;

    var service_check: ?*naemon.nebstruct_service_check_data = @ptrCast(@alignCast(data));

    if (service_check) |sc| {
        naemon.nm_log(naemon.NSLOG_RUNTIME_ERROR, "Got service check from service: '%s'!", sc.service_description);
    }

    return 0;
}
