--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_16575edb = require("@lib/event/helper_16575edb")
local helper_4ce28218 = require("@lib/event/helper_4ce28218")
local helper_89618040 = require("@lib/event/helper_89618040")
local helper_c7517b90 = require("@lib/event/helper_c7517b90")

--- Helper function.
local function helper_ac3d3596(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c7517b90(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_c7517b90(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_4ce28218(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_89618040(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_16575edb(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_ac3d3596
