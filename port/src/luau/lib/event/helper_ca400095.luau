--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_8980cad2 = require("@lib/event/helper_8980cad2")

--- Helper function.
local function helper_ca400095(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8980cad2(36)
		end
	end
	event.Initialize()
	event.DngPause(513, 1)
	event.SetCrossfade(15)
	event.SetTbStatus(0)
	event.CharaActive(0, 0)
	event.AssignStack(5)
	event.ClearStack(5)
	do
		local out1, out2, out3, out4 = event.GetDunWorldCoord(1)
		var2 = out1 or var2
		var3 = out2 or var3
		var4 = out3 or var4
		var5 = out4 or var5
	end
	event.SetWorldCoord(var2, var3, var4, var5)
	event.CopyMons2scnchr(5, arg0, 12)
	event.CharaActive(12)
	event.SetCharaPos(12, var2, var3, var4)
	event.SetCharaRot(12, 0.0, var5, 0.0)
	event.SetMotion(12, "閉め", 4)
	event.CmrsInit()
	event.CmrsSetPos(0.0, 29.0, 57.0)
	event.CmrsSetRef(0.0, 10.0, 0.0)
	event.CmrsMove(0.0, 22.27, 41.0, 0.0, 14.27, 0.0, 80)
	helper_8980cad2(15)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(12, "出現", 6)
	helper_8980cad2(36)
	if vm.skipping() then
		return skip(2)
	end
	event.DeleteChara(12, 0)
	event.CharaActive(0, 12)
	event.AutoSetMonster(arg0, var2, var3, var4, 0.0, var5, 0.0, arg1)
	event.CharaActive(1, 0)
	event.DngPause(513, 0)
	event.Finish()
end

return helper_ca400095
