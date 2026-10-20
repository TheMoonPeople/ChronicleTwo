--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_661d392d = require("@lib/monster/helper_661d392d")

--- Helper function.
local function helper_2c50af1c()
	local value: s32 = 0
	local value_2: s32 = 0
	local value_3: s32 = 0
	local value_4: s32 = 0
	value = monster.VPop(2) or value
	if value ~= -1 then
		value_2 = monster.VPop(3) or value_2
		value_3 = monster.VPop(4) or value_3
		monster.VPush(1, value)
		monster.VPush(2, value_2)
		monster.VPush(3, value_3)
		monster.VPush(4, -1)
		return
	end
	value_4 = monster.VPop(0) or value_4
	if bit32.band(value_4, 2) ~= 0 then
		if bit32.band(value_4, 192) == 192 then
			monster.VPush(1, 2)
			monster.VPush(2, 7)
			return
		end
		if bit32.band(value_4, 48) == 48 then
			monster.VPush(1, 1)
			monster.VPush(2, 7)
			return
		end
		return
	end
	if bit32.band(value_4, 4) ~= 0 then
		if helper_661d392d(180, 200) ~= 0 then
			monster.VPush(1, 9)
		else
			monster.VPush(1, 8)
		end
		return
	end
	monster.VPush(1, 7)
end

return helper_2c50af1c
