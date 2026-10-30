--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_5576abe5 = require("@lib/monster/helper_5576abe5")

--- Helper function.
local function helper_9070bf34()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.get_monster_kind() or monster_id
	chara_id = monster.get_player_transform_id() or chara_id
	if chara_id > -1 then
		helper_5576abe5(monster_id)
	end
end

return helper_9070bf34
