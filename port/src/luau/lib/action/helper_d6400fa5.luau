--!strict
-- Shared action helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_d6400fa5()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local acumu_pad: s32 = 0
	local var8: f32 = 0
	prog = action.ProgGet() or prog
	var0 = action.GetBtn_2(56) or var0
	if prog == 1200 then
		action.SetMos("ためループ")
		acumu_pad = action.GetAcumuPad() or acumu_pad
		if acumu_pad == 20 then
			action.SetPallet(220, 255, 255, 1, 12)
		end
		if acumu_pad > 20 then
			action.ProgSet(prog + 1)
		end
		if acumu_pad == 0 then
			action.ProgSet(0)
			helper_bac4ec65(2)
		end
		action.RunTameMove()
		return
	end
	if prog == 1201 then
		if var0 == 0 then
			action.SetMuteki(30)
			action.SetMos("ため攻撃", -1, 6)
			action.GetPos()
			action.EsmCreate_1("ユリス溜め攻撃")
			action.ProgSet(prog + 1)
		else
			action.RunTameMove()
		end
		return
	end
	if prog == 1202 then
		var8 = action.NowMosWait() or var8
		if var8 >= vm.f32(0.202) and var8 <= vm.f32(0.472) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
			helper_bac4ec65(2)
		end
		return
	end
end

return helper_d6400fa5
