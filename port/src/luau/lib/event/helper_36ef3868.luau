--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_036a108f = require("@lib/event/helper_036a108f")
local helper_4dc6d4d2 = require("@lib/event/helper_4dc6d4d2")
local helper_ce0590af = require("@lib/event/helper_ce0590af")
local helper_db975eb7 = require("@lib/event/helper_db975eb7")

--- Helper function.
local function helper_36ef3868(arg0: s32, arg1: s32)
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
		helper_4dc6d4d2(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_db975eb7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_036a108f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_ce0590af(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_36ef3868
