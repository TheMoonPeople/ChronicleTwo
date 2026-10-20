--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_68e24e97 = require("@lib/monster/helper_68e24e97")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")

--- Helper function.
local function helper_492d4c39(arg0: any)
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	do
		local out1, _, out3 = monster.GetPos_3()
		pos_x = out1 or pos_x
		pos_z = out3 or pos_z
	end
	helper_68e24e97(pos_x, 25.0, pos_z, 1.0, 10.0, 5.0, 150)
	while true do
		helper_0ba23e4e()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(90.0) == 0 then
				monster.SetMos("歩き", -1, 0)
				helper_890ee63a(vm.f32(4.8))
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

return helper_492d4c39
