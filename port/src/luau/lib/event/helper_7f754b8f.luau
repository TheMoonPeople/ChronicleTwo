--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_7f754b8f(arg0: s32)
	event.set_function_point_enabled("", "flame-1", arg0)
	event.set_function_point_enabled("", "func", arg0)
	event.set_function_point_enabled("", "func0", arg0)
	event.set_function_point_enabled("", "func1", arg0)
	event.set_function_point_enabled("", "func2", arg0)
	event.set_function_point_enabled("", "func3", arg0)
	event.set_function_point_enabled("", "func4", arg0)
	event.set_function_point_enabled("", "func5", arg0)
	event.set_function_point_enabled("", "func8", arg0)
	event.stop_environment_music()
end

return helper_7f754b8f
