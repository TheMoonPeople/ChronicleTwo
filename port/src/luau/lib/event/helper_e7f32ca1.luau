--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cb99d2e8 = require("@lib/event/helper_cb99d2e8")
local helper_cde2edc7 = require("@lib/event/helper_cde2edc7")

--- Helper function.
local function helper_e7f32ca1(arg0: s32, arg1: any, sp: number)
	local junk = 0
	vm.stack(sp + 4)
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + junk + 6)
			arg1 = arg1
			vm.stack(sp + junk + 7)
			var3 = 0
			vm.stack(sp + junk + 8)
			local t1 = helper_cde2edc7(arg0, 0, sp + junk + 7)
			vm.stack(sp + junk + 6)
			var2 = t1
			vm.stack(sp + junk + 9)
			var3 = var3 + 1
			junk += 3
		end
		vm.stack(sp + junk + 6)
		var3 = vm.i32(var3 + 1)
		vm.stack(sp + junk + 6)
		helper_cb99d2e8(arg0, sp + junk + 4)
		vm.stack(sp + junk + 4)
		return var3
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + junk + 5)
	if arg1 > 0 then
		vm.stack(sp + junk + 5)
		arg1 = arg1
	end
	vm.stack(sp + junk + 6)
	event.SetMesOkuri(arg0, 0)
	vm.stack(sp + junk + 5)
	event.TrgPakuAnim(1)
	vm.stack(sp + junk + 5)
	event.TrgPakuMotion(0)
	vm.stack(sp + junk + 5)
	var3 = 0
	while true do
		vm.stack(sp + junk + 5)
		if not (var3 < arg1) then
			break
		end
		vm.stack(sp + junk + 6)
		local t0 = helper_cde2edc7(arg0, 0, sp + junk + 5)
		vm.stack(sp + junk + 4)
		var2 = t0
		vm.stack(sp + junk + 4)
		if var2 ~= 0 then
			vm.stack(sp + junk + 6)
			var3 = vm.i32(var3 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			vm.stack(sp + junk + 6)
			var3 = vm.i32(var3 + 1)
		end
	end
	vm.stack(sp + junk + 4)
	event.ResetPakuMotion()
	vm.stack(sp + junk + 5)
	event.TrgPakuAnim(0)
	vm.stack(sp + junk + 4)
	event.ResetPakuAnim()
	vm.stack(sp + junk + 6)
	event.SetMesOkuri(arg0, 1)
	vm.stack(sp + junk + 4)
	helper_cb99d2e8(arg0, sp + junk + 4)
	vm.stack(sp + junk + 4)
	return var3
end

return helper_e7f32ca1
