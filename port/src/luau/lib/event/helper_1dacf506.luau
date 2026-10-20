--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_590ef7b4 = require("@lib/event/helper_590ef7b4")
local helper_aa1b62ae = require("@lib/event/helper_aa1b62ae")

--- Helper function.
local function helper_1dacf506(arg0: s32, arg1: any)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg1 = arg1
			var3 = 0
			var2 = helper_aa1b62ae(arg0, 0)
			var3 = var3 + 1
		end
		var3 = vm.i32(var3 + 1)
		helper_590ef7b4(arg0)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 > 0 then
		arg1 = arg1
	end
	event.SetMesOkuri(arg0, 0)
	event.TrgPakuAnim(1)
	event.TrgPakuMotion(0)
	var3 = 0
	while var3 < arg1 do
		var2 = helper_aa1b62ae(arg0, 0)
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
	helper_590ef7b4(arg0)
	return var3
end

return helper_1dacf506
