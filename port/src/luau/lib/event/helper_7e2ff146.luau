--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_d16eef1e = require("@lib/event/helper_d16eef1e")
local helper_f9022bb8 = require("@lib/event/helper_f9022bb8")

--- Helper function.
local function helper_7e2ff146(arg0: s32, arg1: any)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMesOkuri(arg0, 0)
		event.TrgPakuAnim(1)
		event.TrgPakuMotion(0)
		var3 = 0
		while var3 < arg1 do
			var2 = helper_f9022bb8(arg0, 0)
			if var2 ~= 0 then
				var3 = vm.i32(var3 + 1)
				break
			else
				at = 1
				vm.wait(1)
				var3 = vm.i32(var3 + 1)
			end
		end
		event.ResetPakuMotion()
		event.TrgPakuAnim(0)
		event.ResetPakuAnim()
		event.SetMesOkuri(arg0, 1)
		helper_6992f518(arg0)
		return var3
	end, function(received: { any })
		if at <= 1 then
			var3 = var3 + 1
			helper_d16eef1e(arg0)
			return var3
		end
		return nil
	end)
end

return helper_7e2ff146
