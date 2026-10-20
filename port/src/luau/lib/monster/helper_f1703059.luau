--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_cf677cab = require("@lib/monster/helper_cf677cab")

--- Helper function.
local function helper_f1703059()
	local chara_id: s32 = 0
	local monster_id: s32 = 0
	monster_id = monster.GetMonsterIndex() or monster_id
	chara_id = monster.GetUserMonsId() or chara_id
	if chara_id > -1 then
		helper_cf677cab(monster_id)
	end
end

return helper_f1703059
