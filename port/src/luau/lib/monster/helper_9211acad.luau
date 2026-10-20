--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0b6e560f = require("@lib/monster/helper_0b6e560f")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_f5727415 = require("@lib/monster/helper_f5727415")

--- Helper function.
local function helper_9211acad(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_0b6e560f(pos_x, 25.0, pos_z, 0.875, 10.0, 5.0, 150)
	while true do
		helper_461f64ff()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.SetMos("歩き", -1, 0)
				helper_f5727415(vm.f32(4.8))
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

return helper_9211acad
