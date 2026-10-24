--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_1e1681bf = require("@lib/event/helper_1e1681bf")

--- Helper function.
local function helper_c2b5f8fb(arg0: s32, arg1: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var5 = out2 or var5
	end
	var6 = vm.f32(arg1 - var5)
	if var6 < vm.f32(-3.1415927) then
		var6 = vm.f32(var6 + vm.f32(6.2831855))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(6.2831855))
	end
	if -0.5 < var6 and var6 < 0.5 then
	else
		event.SetMotion(arg0, "歩き")
	end
	var7 = 0.0
	var8 = vm.f32(helper_05ce8bed(var6) * 8.0)
	while var7 < var8 do
		var9 = helper_1e1681bf(0.0, var6, var7, var8)
		var9 = vm.f32(var9 + var5)
		event.SetCharaRot(arg0, 0.0, var9, 0.0)
		var7 = vm.f32(var7 + 1.0)
		vm.wait(1)
	end
	event.GetCharaRot(arg0) -- retail: argument 2 is a value where the handler writes an output; the output is discarded; argument 3 is a value where the handler writes an output; the output is discarded; argument 4 is a value where the handler writes an output; the output is discarded
	event.SetMotion(arg0, "立ち")
end

return helper_c2b5f8fb
