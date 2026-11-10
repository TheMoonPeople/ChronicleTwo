--!strict
-- Shared monster helper used by 57 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_65eb2b74(value: s32)
	monster.set_secondary_variable(5, value)
	if value == 0 then
		monster.set_monster_escape_rate(-1, 1.0)
		monster.set_monster_guard_rate(-1, 1.0)
	end
end

return helper_65eb2b74
