--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_f81ccc21 = require("@lib/monster/helper_f81ccc21")

--- Helper function.
local function helper_37e24389()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_f81ccc21(monster_id)
	end
end

return helper_37e24389
