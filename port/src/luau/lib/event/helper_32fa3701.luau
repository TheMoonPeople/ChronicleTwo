--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_33680575 = require("@lib/event/helper_33680575")
local helper_7c9d908c = require("@lib/event/helper_7c9d908c")
local helper_ad0d2322 = require("@lib/event/helper_ad0d2322")
local helper_f3021833 = require("@lib/event/helper_f3021833")

--- Helper function.
local function helper_32fa3701(arg0: s32, arg1: s32)
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
		helper_f3021833(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_7c9d908c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_33680575(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_ad0d2322(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_32fa3701
