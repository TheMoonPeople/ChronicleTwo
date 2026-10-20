--!strict
-- Shared monster helper used by 10 scripts, translated by tools/luau/stb2luau.

local helper_83e135e0 = require("@lib/monster/helper_83e135e0")
local helper_8cdd6198 = require("@lib/monster/helper_8cdd6198")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_69872d52(arg0: any)
	local chara_id: s32 = 0
	monster.SetMos("立ち", -1, 4)
	while true do
		helper_b9fff8e1()
		chara_id = monster.GetUserMonsId() or chara_id
		if chara_id == -1 then
			break
		else
			if helper_8cdd6198(60.0) == 0 then
				monster.SetMos("歩き", -1.0, 0)
				helper_83e135e0(3.0)
			end
			monster.SetMos("立ち", -1, 0)
		end
	end
end

return helper_69872d52
