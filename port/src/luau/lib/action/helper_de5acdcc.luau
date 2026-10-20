--!strict
-- Shared action helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_de5acdcc()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local acumu_pad: s32 = 0
	local var5: f32 = 0
	prog = action.ProgGet() or prog
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
		var0 = action.GetBtn_2(56) or var0
		if var0 == 0 then
			action.SetMuteki(30)
			action.SetMos("ため攻撃", -1, 6)
			action.EsmCreate_1("モニカ溜め攻撃")
			action.ProgSet(prog + 1)
		else
			action.RunTameMove()
		end
		return
	end
	if prog == 1202 then
		var1 = action.GetMosStatus() or var1
		var5 = action.NowMosWait() or var5
		if var5 >= vm.f32(0.12) and var5 < vm.f32(0.626) then
			action.SetBlowMove(0.6, 0.0, 1)
		end
		if var5 >= vm.f32(0.626) and var5 < vm.f32(0.67) then
			action.CameraQuake(6.0, 20)
		end
		if var1 == 4 then
			action.ProgSet(0)
			helper_bac4ec65(2)
		end
		return
	end
end

return helper_de5acdcc
