--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3f6dc8d5 = require("@lib/event/helper_3f6dc8d5")
local helper_67360d22 = require("@lib/event/helper_67360d22")
local helper_ab2a536c = require("@lib/event/helper_ab2a536c")
local helper_f21eda2d = require("@lib/event/helper_f21eda2d")

--- Helper function.
local function helper_0be40ac6(arg0: s32, arg1: s32)
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
		helper_f21eda2d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ab2a536c(arg0, arg1)
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

return helper_0be40ac6
