--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_fe018488(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_b9fff8e1()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", 0.45, 0)
				helper_83e135e0(vm.f32(4.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

return helper_fe018488
