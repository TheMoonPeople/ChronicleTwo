--!strict
-- Shared monster helper used by 16 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_83dc8947()
	local var0: s32 = 0
	local height: f32 = 0
	monster.stop_moving()
	helper_442b9962()
	monster.start_death()
	monster.set_monster_attributes(4, 0)
	monster.set_monster_attributes(256, 0)
	monster.set_monster_attributes(8, 0)
	monster.set_motion("ダメージ", -1, 0)
	var0 = 0
	while var0 < 900 do
		vm.wait()
		monster.get_position_3()
		height = monster.get_height_above_ground() or height
		if height <= 0.0 then
			break
		else
			var0 = var0 + 1
		end
	end
end

return helper_83dc8947
