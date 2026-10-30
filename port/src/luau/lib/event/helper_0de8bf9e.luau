--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_0de8bf9e(arg0: s32)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-0", if arg0 == 0 then 1 else 0)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-1", arg0)
	event.set_function_point_enabled("p01_e01a04-1", "invent_15-2", arg0)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-0", if arg0 == 0 then 1 else 0)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-1", arg0)
	event.set_function_point_enabled("p01_e01a04-2", "invent_15-2", arg0)
end

return helper_0de8bf9e
