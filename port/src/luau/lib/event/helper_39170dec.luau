--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23369a5e = require("@lib/event/helper_23369a5e")
local helper_93671964 = require("@lib/event/helper_93671964")
local helper_f1a4920e = require("@lib/event/helper_f1a4920e")

--- Helper function.
local function helper_39170dec(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f1a4920e(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_93671964(arg0, 0, var5)
		end
		helper_23369a5e(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_f1a4920e(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_93671964(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_23369a5e(arg0)
end

return helper_39170dec
