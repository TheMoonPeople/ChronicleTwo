--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_220e1543 = require("@lib/event/helper_220e1543")
local helper_385a4235 = require("@lib/event/helper_385a4235")
local helper_9132d6fd = require("@lib/event/helper_9132d6fd")
local helper_dc1fde18 = require("@lib/event/helper_dc1fde18")

--- Helper function.
local function helper_ac84258c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_385a4235(arg0, arg1)
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
	var2 = event.GetQuestEtc(0, 0) or var2
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_385a4235(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_9132d6fd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_220e1543(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_dc1fde18(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_ac84258c
