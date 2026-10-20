--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09b6964c = require("@lib/event/helper_09b6964c")
local helper_383a700d = require("@lib/event/helper_383a700d")
local helper_4328aa87 = require("@lib/event/helper_4328aa87")
local helper_ce57a67d = require("@lib/event/helper_ce57a67d")

--- Helper function.
local function helper_0405ac94(arg0: s32, arg1: s32)
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
		helper_4328aa87(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_ce57a67d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_383a700d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_09b6964c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_0405ac94
