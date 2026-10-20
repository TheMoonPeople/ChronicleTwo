--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2940c784 = require("@lib/event/helper_2940c784")
local helper_29e17dbd = require("@lib/event/helper_29e17dbd")
local helper_32023e5d = require("@lib/event/helper_32023e5d")
local helper_5b434731 = require("@lib/event/helper_5b434731")

--- Helper function.
local function helper_d15a635c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5b434731(arg0, arg1)
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
		helper_5b434731(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_2940c784(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_29e17dbd(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_32023e5d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_d15a635c
