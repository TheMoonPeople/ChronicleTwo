--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_398fae17 = require("@lib/event/helper_398fae17")
local helper_599d5546 = require("@lib/event/helper_599d5546")
local helper_770db70a = require("@lib/event/helper_770db70a")
local helper_c27b1452 = require("@lib/event/helper_c27b1452")

--- Helper function.
local function helper_91858344(arg0: s32, arg1: s32)
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
		helper_599d5546(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_c27b1452(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_770db70a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_398fae17(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_91858344
