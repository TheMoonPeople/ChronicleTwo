--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_af3c7344()
	monster.call_command(119, 1, 1) -- retail: the handler rejects 2 arguments
	monster.call_command(119, 2, 1) -- retail: the handler rejects 2 arguments
	monster.get_attack_power_0()
end

return helper_af3c7344
