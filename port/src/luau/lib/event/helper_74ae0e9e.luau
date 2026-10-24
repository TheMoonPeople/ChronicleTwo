--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47e5fe4f = require("@lib/event/helper_47e5fe4f")
local helper_9503b887 = require("@lib/event/helper_9503b887")
local helper_b25ca4bc = require("@lib/event/helper_b25ca4bc")
local helper_d99f73e7 = require("@lib/event/helper_d99f73e7")

--- Helper function.
local function helper_74ae0e9e(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_d99f73e7(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_9503b887(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_47e5fe4f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_b25ca4bc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_74ae0e9e
