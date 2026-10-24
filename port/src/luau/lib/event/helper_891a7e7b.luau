--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2737ad20 = require("@lib/event/helper_2737ad20")
local helper_3f6dc8d5 = require("@lib/event/helper_3f6dc8d5")
local helper_67360d22 = require("@lib/event/helper_67360d22")
local helper_b9be8d71 = require("@lib/event/helper_b9be8d71")

--- Helper function.
local function helper_891a7e7b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3f6dc8d5(arg0, arg1)
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
		helper_3f6dc8d5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_2737ad20(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_b9be8d71(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_67360d22(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_891a7e7b
