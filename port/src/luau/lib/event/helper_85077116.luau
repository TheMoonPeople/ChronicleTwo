--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_267bc7b4 = require("@lib/event/helper_267bc7b4")
local helper_e6106d27 = require("@lib/event/helper_e6106d27")

--- Helper function.
local function helper_85077116(arg0: any, arg1: s32, arg2: s32, arg3: s32, sp: number)
	vm.stack(sp + 5)
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + 6)
			return
		end
		vm.stack(sp + 5)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 6)
	if arg3 <= 0 then
		vm.stack(sp + 5)
		return
	end
	vm.stack(sp + 7)
	event.SetMesPreset(1, 4)
	vm.stack(sp + 6)
	helper_267bc7b4(1, 4, sp + 5)
	vm.stack(sp + 6)
	var4 = -1
	vm.stack(sp + 6)
	if arg1 == 1 then
		vm.stack(sp + 6)
		if arg3 == 1 then
			vm.stack(sp + 6)
			var4 = 14
		else
			vm.stack(sp + 6)
			var4 = 21
		end
	end
	vm.stack(sp + 6)
	if arg1 == 2 then
		vm.stack(sp + 6)
		if arg3 == 1 then
			vm.stack(sp + 6)
			var4 = 26
		else
			vm.stack(sp + 6)
			var4 = 24
		end
	end
	vm.stack(sp + 6)
	if arg1 == 3 then
		vm.stack(sp + 6)
		if arg3 == 1 then
			vm.stack(sp + 6)
			var4 = 27
		else
			vm.stack(sp + 6)
			var4 = 25
		end
	end
	vm.stack(sp + 6)
	if var4 == -1 then
		vm.stack(sp + 5)
		return
	end
	vm.stack(sp + 8)
	event.SetMesValue(1, 1, arg1)
	vm.stack(sp + 8)
	event.SetMesItem(1, 1, arg2)
	vm.stack(sp + 8)
	event.SetMesValue(1, 2, arg3)
	vm.stack(sp + 9)
	helper_e6106d27(1, var4, 8, 0, 0, sp + 5)
	if vm.skipping() then
		return skip(2)
	end
	vm.stack(sp + 5)
end

return helper_85077116
