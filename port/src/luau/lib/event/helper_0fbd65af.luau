--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e96cfb3 = require("@lib/event/helper_1e96cfb3")
local helper_9e1760a5 = require("@lib/event/helper_9e1760a5")
local helper_eeda1a9c = require("@lib/event/helper_eeda1a9c")
local helper_fc028319 = require("@lib/event/helper_fc028319")

--- Helper function.
local function helper_0fbd65af(arg0: s32, arg1: s32)
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
		helper_1e96cfb3(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_eeda1a9c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_9e1760a5(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_fc028319(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_0fbd65af
