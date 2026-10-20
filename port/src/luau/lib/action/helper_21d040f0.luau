--!strict
-- Shared action helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_21d040f0()
	local var0: s32 = 0
	local var1: s32 = 0
	local prog: s32 = 0
	local var4: f32 = 0
	local acumu_pad: s32 = 0
	local var6: f32 = 0
	prog = action.ProgGet() or prog
	if prog == 100 then
		action.SetMos("5剣1", -1, 6)
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.26) and var4 <= vm.f32(0.45) then
			action.SetBlowMove(1.2, 0.0, 1)
		end
		if var4 >= vm.f32(0.6) and var4 <= 1.0 then
			action.SetBlowMove(0.92, 0.0, 1)
		end
		acumu_pad = action.GetAcumuPad() or acumu_pad
		if acumu_pad > 10 then
			action.ResetAcumuPad()
			action.ProgSet(1200)
			return
		end
		if var4 >= vm.f32(0.45) and var4 <= vm.f32(0.63) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣2", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 101 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.238) and var4 <= vm.f32(0.418) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		if var4 >= vm.f32(0.38) and var4 <= vm.f32(0.58) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				var6 = action.CheckFrontKey() or var6
				if var6 > vm.f32(0.6) then
					action.SetMos("ふっとばし", -1, 6)
					action.SetTrgAngle(40.0, 2.0)
					action.ProgSet(105)
				else
					action.SetMos("5剣3", -1, 6)
					action.SetTrgAngle(40.0, 2.0)
					action.ProgSet(prog + 1)
					action.ResetPadHistory()
					action.SetMurderous(0, 3)
				end
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 102 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.39) and var4 <= vm.f32(0.53) then
			action.SetBlowMove(2.5, 0.0, 1)
		end
		if var4 >= vm.f32(0.64) and var4 <= 1.0 then
			action.SetBlowMove(-0.919, 0.0, 1)
		end
		if var4 >= vm.f32(0.51) and var4 <= vm.f32(0.64) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣4", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 103 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.35) and var4 <= vm.f32(0.55) then
			action.SetBlowMove(2.0, 0.0, 1)
		end
		if var4 >= 0.5 and var4 <= vm.f32(0.7) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣5", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 104 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.28) and var4 <= vm.f32(0.45) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		if var4 >= vm.f32(0.609) and var4 <= 1.0 then
			action.SetBlowMove(0.57, 0.0, 1)
		end
		if var4 >= vm.f32(0.48) and var4 <= vm.f32(0.64) then
			var0 = action.GetPadHistory() or var0
			if var0 ~= 0 then
				action.SetMos("5剣6", -1, 6)
				action.SetTrgAngle(40.0, 2.0)
				action.ProgSet(prog + 1)
				action.ResetPadHistory()
				action.SetMurderous(0, 3)
			end
		else
			var1 = action.GetMosStatus() or var1
			if var1 == 4 then
				action.ProgSet(0)
			end
		end
		return
	end
	if prog == 105 then
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.14) and var4 <= vm.f32(0.45) then
			action.SetBlowMove(2.2, 0.0, 1)
		end
		if var4 >= vm.f32(0.66) and var4 <= 1.0 then
			action.SetBlowMove(0.825, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
	if prog == 105 then
		var1 = action.GetMosStatus() or var1
		var4 = action.NowMosWait() or var4
		if var4 >= vm.f32(0.1) and var4 <= vm.f32(0.4) then
			action.SetBlowMove(1.5, 0.0, 1)
		end
		var1 = action.GetMosStatus() or var1
		if var1 == 4 then
			action.ProgSet(0)
		end
		return
	end
end

return helper_21d040f0
