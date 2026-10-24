--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_209e818b = require("@lib/event/helper_209e818b")
local helper_d2b0cc73 = require("@lib/event/helper_d2b0cc73")
local helper_ecedf6ae = require("@lib/event/helper_ecedf6ae")
local helper_ee44c534 = require("@lib/event/helper_ee44c534")

--- Helper function.
local function helper_5515f51f(arg0: s32, arg1: s32)
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
		helper_ee44c534(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_ecedf6ae(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_d2b0cc73(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_209e818b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_5515f51f
