--!strict
-- Shared monster helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4de07275 = require("@lib/monster/helper_4de07275")
local helper_abe18b40 = require("@lib/monster/helper_abe18b40")

--- Helper function.
local function helper_b2d758a4()
	local var0: s32 = 0
	local var1: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var9: f32 = 0
	local var10: f32 = 0
	local result: f32 = 0
	local var13: f32 = 0
	local var14: s32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var25: f32 = 0
	monster.call_command(100, "飛行") -- retail: the handler rejects 1 arguments
	monster.stop_sound(1, 0, "飛行")
	var0 = 1
	while var0 ~= 0 do
		do
			local out1, _, out3 = monster.get_status_ailments()
			var1 = out1 or var1
			var3 = out3 or var3
		end
		monster.get_event_info_3(var4) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
		monster.call_command(50, var7, var8, var9) -- retail: the handler rejects 3 arguments
		do
			local out1, _ = monster.get_pause_flags(var10) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			result = vm.bits_float(out1) or result
		end
		var14 = helper_4de07275(var7, var9, result, 0.5, 800.0, var1, var3)
		if var14 ~= 0 then
			monster.stop_sound(1, 1, "ハッケーン！")
			var15 = helper_abe18b40(var7, var9, result, var1, var3)
			if var15 < vm.f32(-0.005) or vm.f32(0.005) < var15 then
				if 0 < var15 then
					var13 = var15
					if vm.f32(0.025) < var13 then
						var13 = vm.f32(0.025)
					end
				else
					var13 = var15
					if var13 < vm.f32(-0.025) then
						var13 = vm.f32(-0.025)
					end
				end
			else
				var13 = 0.0
				var0 = 0
			end
		else
			monster.stop_sound(1, 1, "いないよぅ～")
			var16 = helper_abe18b40(var7, var9, result, vm.f32(268.8), vm.f32(-322.4))
			if true then
				if 0 < var16 then
					var13 = var16
					if vm.f32(0.025) < var13 then
						var13 = vm.f32(0.025)
					end
				else
					var13 = var16
					if var13 < vm.f32(-0.025) then
						var13 = vm.f32(-0.025)
					end
				end
			else
				var13 = 0.0
			end
		end
		var18 = 800.0
		var20 = vm.f32(vm.sin(vm.f32(result + var13)) * 1.0)
		var21 = vm.f32(vm.cos(vm.f32(result + var13)) * 1.0)
		var17 = vm.f32(var7 + var20)
		var19 = vm.f32(var9 + var21)
		var22 = vm.f32(result + var13)
		if var22 > vm.f32(3.1415927) then
			var22 = vm.f32(var22 - vm.f32(6.2831855))
		end
		if var22 <= vm.f32(-3.1415927) then
			var22 = vm.f32(var22 + vm.f32(6.2831855))
		end
		monster.set_pause_flags(var17, var18, var19)
		do
			local _, out2 = monster.get_pause_flags(var23) -- retail: argument 1 passes a reference where the handler reads a value, the low bits of the variable's address; the variable's value is passed
			var25 = out2 or var25
		end
		monster.is_save_flag_set(var23, var22, var25)
		vm.wait()
	end
end

return helper_b2d758a4
