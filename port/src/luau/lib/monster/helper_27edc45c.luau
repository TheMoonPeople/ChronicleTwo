--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_27edc45c()
	local timer: s32 = 0
	timer = monster.GetTimer() or timer
	monster.VPush(5, timer)
end

return helper_27edc45c
