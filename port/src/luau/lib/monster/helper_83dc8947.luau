--!strict
-- Shared monster helper used by 16 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")

--- Helper function.
local function helper_83dc8947()
	local var0: s32 = 0
	local height: f32 = 0
	monster.ResetMove()
	helper_442b9962()
	monster.SetDeadStart()
	monster.SetAttrib(4, 0)
	monster.SetAttrib(256, 0)
	monster.SetAttrib(8, 0)
	monster.SetMos("ダメージ", -1, 0)
	var0 = 0
	while var0 < 900 do
		vm.wait()
		monster.GetPos_3()
		height = monster.GetHigh() or height
		if height <= 0.0 then
			break
		else
			var0 = var0 + 1
		end
	end
end

return helper_83dc8947
