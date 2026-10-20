--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_9211acad = require("@lib/monster/helper_9211acad")

--- Helper function.
local function helper_3d0d0c5c()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_9211acad(monster_id)
	end
end

return helper_3d0d0c5c
