--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_3fb0bb95()
	local var0: f32 = 0
	monster.call_command(75, var0) -- retail: the handler rejects 1 arguments
	monster.call_command(68, 0.0, var0, 0.0) -- retail: command 68 is not registered
end

return helper_3fb0bb95
