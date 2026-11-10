--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_f50d89ab(arg0: f32)
	local var1: f32 = 0
	monster.call_command(75, var1) -- retail: the handler rejects 1 arguments
	monster.call_command(69, var1, arg0) -- retail: command 69 is not registered
end

return helper_f50d89ab
