--!strict
-- Shared monster helper used by 17 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_4403befa()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local height: f32 = 0
	do
		local out1, out2, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	height = monster.GetHigh() or height
	if height < 0.0 then
		height = vm.f32(height * -1.0)
		height = vm.f32(height + 1.0)
		pos_y = vm.f32(pos_y + height)
	end
	if height == 0.0 then
		pos_y = vm.f32(pos_y + 1.0)
	end
	monster.SetPos(pos_x, pos_y, pos_z)
end

return helper_4403befa
