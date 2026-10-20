--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_57b569a8 = require("@lib/monster/helper_57b569a8")
local helper_68e24e97 = require("@lib/monster/helper_68e24e97")

--- Helper function.
local function helper_6958e50d()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local var3: f32 = 0
	monster.SetMos("歩き", -1, 0)
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	var3 = helper_57b569a8(var3)
	helper_68e24e97(pos_x, pos_y, pos_z, 2.0, 35.0, 38.0, 120)
end

return helper_6958e50d
