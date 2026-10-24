--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_01fe6ed4 = require("@lib/event/helper_01fe6ed4")
local helper_65fc1678 = require("@lib/event/helper_65fc1678")
local helper_a6d7a247 = require("@lib/event/helper_a6d7a247")
local helper_e18601c7 = require("@lib/event/helper_e18601c7")

--- Helper function.
local function helper_58f4a291(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_01fe6ed4(arg0, arg1)
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
	if var2 ~= 2 then
		helper_01fe6ed4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_e18601c7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_a6d7a247(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_65fc1678(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_58f4a291
