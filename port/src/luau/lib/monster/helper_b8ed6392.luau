--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_ceea3a4f = require("@lib/monster/helper_ceea3a4f")

--- Helper function.
local function helper_b8ed6392()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_ceea3a4f(monster_id)
	end
end

return helper_b8ed6392
