--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_067d8638 = require("@lib/event/helper_067d8638")
local helper_2e9f92fa = require("@lib/event/helper_2e9f92fa")
local helper_4c505ac4 = require("@lib/event/helper_4c505ac4")
local helper_85626c59 = require("@lib/event/helper_85626c59")

--- Helper function.
local function helper_12d342e8(arg0: s32, arg1: s32)
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
		helper_067d8638(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_4c505ac4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_2e9f92fa(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_85626c59(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_12d342e8
