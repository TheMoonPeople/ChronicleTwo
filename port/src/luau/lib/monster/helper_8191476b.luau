--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_492d4c39 = require("@lib/monster/helper_492d4c39")

--- Helper function.
local function helper_8191476b()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_492d4c39(monster_id)
	end
end

return helper_8191476b
