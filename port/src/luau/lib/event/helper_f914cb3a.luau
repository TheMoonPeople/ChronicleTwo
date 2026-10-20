--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1f882600 = require("@lib/event/helper_1f882600")
local helper_62fc4cea = require("@lib/event/helper_62fc4cea")
local helper_f9d945dc = require("@lib/event/helper_f9d945dc")

--- Helper function.
local function helper_f914cb3a(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f9d945dc(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_1f882600(arg0, 0, var5)
		end
		helper_62fc4cea(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_f9d945dc(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_1f882600(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_62fc4cea(arg0)
end

return helper_f914cb3a
