--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_d1d9248d = require("@lib/monster/helper_d1d9248d")

--- Helper function.
local function helper_06e3d1fa()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_d1d9248d(monster_id)
	end
end

return helper_06e3d1fa
