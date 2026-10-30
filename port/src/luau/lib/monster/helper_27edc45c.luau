--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_27edc45c()
	local timer: s32 = 0
	timer = monster.get_dungeon_timer() or timer
	monster.set_variable(5, timer)
end

return helper_27edc45c
