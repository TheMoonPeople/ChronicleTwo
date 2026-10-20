--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3535925d = require("@lib/event/helper_3535925d")
local helper_7fcf204c = require("@lib/event/helper_7fcf204c")

--- Helper function.
local function helper_328835ce(arg0: any, arg1: any)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var3 = 0
			var2 = helper_7fcf204c(arg0, 0)
			var3 = var3 + 1
		end
		var3 = vm.i32(var3 + 1)
		helper_3535925d(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesOkuri(arg0, 0)
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var3 = 0
	while var3 < arg1 do
		var2 = helper_7fcf204c(arg0, 0)
		if var2 ~= 0 then
			var3 = vm.i32(var3 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			var3 = vm.i32(var3 + 1)
		end
	end
	event.ResetPakuMotion()
	event.TrgPakuAnim(0)
	event.ResetPakuAnim()
	event.SetMesOkuri(arg0, 1)
	helper_3535925d(arg0)
end

return helper_328835ce
