--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d6804fa1 = require("@lib/event/helper_d6804fa1")
local helper_e201716d = require("@lib/event/helper_e201716d")
local helper_eb106592 = require("@lib/event/helper_eb106592")
local helper_f86f0da9 = require("@lib/event/helper_f86f0da9")

--- Helper function.
local function helper_5866eca8(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f86f0da9(arg0, arg1)
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
		helper_f86f0da9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_eb106592(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_d6804fa1(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e201716d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_5866eca8
