--!strict
-- Shared monster helper used by 4 scripts, translated by tools/luau/stb2luau.

local helper_0ba23e4e = require("@lib/monster/helper_0ba23e4e")
local helper_890ee63a = require("@lib/monster/helper_890ee63a")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")

--- Helper function.
local function helper_cf677cab(arg0: any)
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	while true do
		helper_0ba23e4e()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.SetMos("歩き", -1.0, 0)
				helper_890ee63a(3.0)
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

return helper_cf677cab
