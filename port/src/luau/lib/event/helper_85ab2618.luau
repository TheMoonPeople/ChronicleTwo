--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a0e1163 = require("@lib/event/helper_0a0e1163")
local helper_0ba263f7 = require("@lib/event/helper_0ba263f7")
local helper_3ab24005 = require("@lib/event/helper_3ab24005")

--- Helper function.
local function helper_85ab2618(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_3ab24005(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_0a0e1163(arg0, 0, var5)
		end
		helper_0ba263f7(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_3ab24005(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_0a0e1163(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_0ba263f7(arg0)
end

return helper_85ab2618
