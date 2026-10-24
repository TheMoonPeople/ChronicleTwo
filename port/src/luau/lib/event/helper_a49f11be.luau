--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local helper_cfca3481 = require("@lib/event/helper_cfca3481")

--- Helper function.
local function helper_a49f11be(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_cfca3481(arg0, var8)
	event.SetCharaRot(arg0, 0.0, var8, 0.0)
	event.SetMotion(arg0, "立ち")
end

return helper_a49f11be
