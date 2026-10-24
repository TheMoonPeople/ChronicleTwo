--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d72b86b = require("@lib/event/helper_1d72b86b")
local helper_8f452c97 = require("@lib/event/helper_8f452c97")
local helper_b867396e = require("@lib/event/helper_b867396e")
local helper_dfdeada2 = require("@lib/event/helper_dfdeada2")

--- Helper function.
local function helper_c8ba187e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8f452c97(arg0, arg1)
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
		helper_8f452c97(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_b867396e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_dfdeada2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_1d72b86b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_c8ba187e
