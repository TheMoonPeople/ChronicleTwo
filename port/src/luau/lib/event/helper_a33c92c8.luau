--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_cde2edc7 = require("@lib/event/helper_cde2edc7")

--- Helper function.
local function helper_a33c92c8(arg0: any, arg1: s32, arg2: s32, sp: number)
	local junk = 0
	vm.stack(sp + 5)
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + junk + 6)
			var4 = 0
			vm.stack(sp + junk + 8)
			local t1 = helper_cde2edc7(arg0, arg1, sp + junk + 7)
			vm.stack(sp + junk + 6)
			var3 = t1
			vm.stack(sp + junk + 8)
			arg2 = 0
			vm.stack(sp + junk + 10)
			arg2 = 1
			vm.stack(sp + junk + 12)
			arg2 = 1
			vm.stack(sp + junk + 13)
			var4 = var4 + 1
			junk += 6
		end
		vm.stack(sp + junk + 7)
		var4 = vm.i32(var4 + 1)
		vm.stack(sp + junk + 6)
		return var4, arg2
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + junk + 6)
	event.TrgPakuAnim(1)
	vm.stack(sp + junk + 6)
	event.TrgPakuMotion(0)
	vm.stack(sp + junk + 6)
	var4 = 0
	while true do
		vm.stack(sp + junk + 5)
		if 1 == 0 then
			break
		end
		vm.stack(sp + junk + 7)
		local t0 = helper_cde2edc7(arg0, arg1, sp + junk + 6)
		vm.stack(sp + junk + 5)
		var3 = t0
		vm.stack(sp + junk + 5)
		if var3 ~= 0 then
			vm.stack(sp + junk + 6)
			arg2 = 0
			vm.stack(sp + junk + 6)
			if arg1 == 1 and var3 == 2 then
				vm.stack(sp + junk + 6)
				arg2 = 1
			end
			vm.stack(sp + junk + 6)
			if arg1 == 2 and var3 == 3 then
				vm.stack(sp + junk + 6)
				arg2 = 1
			end
			vm.stack(sp + junk + 7)
			var4 = vm.i32(var4 + 1)
			break
		else
			if vm.wait() then
				return skip(2)
			end
			vm.stack(sp + junk + 7)
			var4 = vm.i32(var4 + 1)
		end
	end
	vm.stack(sp + junk + 5)
	event.ResetPakuMotion()
	vm.stack(sp + junk + 6)
	event.TrgPakuAnim(0)
	vm.stack(sp + junk + 5)
	event.ResetPakuAnim()
	vm.stack(sp + junk + 5)
	return var4, arg2
end

return helper_a33c92c8
