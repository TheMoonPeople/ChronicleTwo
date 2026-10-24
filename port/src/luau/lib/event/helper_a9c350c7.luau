--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e7f32ca1 = require("@lib/event/helper_e7f32ca1")
local helper_fd98eb80 = require("@lib/event/helper_fd98eb80")

--- Helper function.
local function helper_a9c350c7(arg0: s32, arg1: s32, arg2: s32, arg3: s32, arg4: s32, arg5: s32, sp: number)
	vm.stack(sp + 8)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			vm.stack(sp + 13)
			local _ = helper_fd98eb80(arg0, arg1, arg2, arg3, arg4, sp + 9)
			vm.stack(sp + 8)
			vm.stack(sp + 10)
			local _ = helper_e7f32ca1(arg0, arg5, sp + 9)
			vm.stack(sp + 8)
		end
		vm.stack(sp + 10)
	end
	if vm.skipping() then
		return skip(1)
	end
	vm.stack(sp + 13)
	local _ = helper_fd98eb80(arg0, arg1, arg2, arg3, arg4, sp + 9)
	vm.stack(sp + 8)
	vm.stack(sp + 10)
	local _ = helper_e7f32ca1(arg0, arg5, sp + 9)
	vm.stack(sp + 8)
	if vm.skipping() then
		return skip(2)
	end
	vm.stack(sp + 10)
	event.SetMesPos(arg0, 0)
	vm.stack(sp + 8)
end

return helper_a9c350c7
