--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")

--- Helper function.
local function helper_f7a5d40a(arg0: any)
	local chara_id: s32 = 0
	monster.set_motion("立ち", -1, 4)
	while true do
		helper_0ba23e4e()
		chara_id = monster.get_player_transform_id() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.set_motion("歩き", 0.45, 0)
				helper_890ee63a(vm.f32(4.2))
			end
			monster.set_motion("立ち", -1, 0)
		end
	end
end

return helper_f7a5d40a
