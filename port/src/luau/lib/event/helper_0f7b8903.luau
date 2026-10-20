--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_11202dd0 = require("@lib/event/helper_11202dd0")
local helper_2bfdaf43 = require("@lib/event/helper_2bfdaf43")
local helper_64ca7faa = require("@lib/event/helper_64ca7faa")
local helper_e956dc97 = require("@lib/event/helper_e956dc97")

--- Helper function.
local function helper_0f7b8903(arg0: s32, arg1: s32)
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
		helper_64ca7faa(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_e956dc97(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_2bfdaf43(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_11202dd0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_0f7b8903
