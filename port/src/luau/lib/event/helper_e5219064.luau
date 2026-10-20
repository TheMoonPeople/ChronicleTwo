--!strict
-- Shared event helper used by 50 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_048b6415 = require("@lib/event/helper_048b6415")
local helper_88c6684e = require("@lib/event/helper_88c6684e")
local helper_8b555b0f = require("@lib/event/helper_8b555b0f")

--- Helper function.
local function helper_e5219064(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_8b555b0f(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_048b6415(arg0, 0, var5)
		end
		helper_88c6684e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_8b555b0f(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_048b6415(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_88c6684e(arg0)
end

return helper_e5219064
