--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e01ce81 = require("@lib/event/helper_1e01ce81")
local helper_3d19a759 = require("@lib/event/helper_3d19a759")
local helper_c1348eae = require("@lib/event/helper_c1348eae")
local helper_c3039c09 = require("@lib/event/helper_c3039c09")

--- Helper function.
local function helper_a0bb9fe2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c3039c09(arg0, arg1)
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
		helper_c3039c09(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_c1348eae(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1e01ce81(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_3d19a759(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_a0bb9fe2
