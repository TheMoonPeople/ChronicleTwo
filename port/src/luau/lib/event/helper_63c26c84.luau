--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19498e14 = require("@lib/event/helper_19498e14")
local helper_42d7e7f6 = require("@lib/event/helper_42d7e7f6")
local helper_75dff748 = require("@lib/event/helper_75dff748")
local helper_b5ccd39a = require("@lib/event/helper_b5ccd39a")

--- Helper function.
local function helper_63c26c84(arg0: s32, arg1: s32)
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
		helper_19498e14(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_b5ccd39a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_42d7e7f6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_75dff748(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_63c26c84
