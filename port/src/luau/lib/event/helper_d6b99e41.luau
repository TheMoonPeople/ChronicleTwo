--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6f2f4116 = require("@lib/event/helper_6f2f4116")
local helper_72ce4a2d = require("@lib/event/helper_72ce4a2d")
local helper_7c94b03f = require("@lib/event/helper_7c94b03f")
local helper_8a3dae90 = require("@lib/event/helper_8a3dae90")

--- Helper function.
local function helper_d6b99e41(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_6f2f4116(arg0, arg1)
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
		helper_6f2f4116(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_72ce4a2d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_8a3dae90(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_7c94b03f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_d6b99e41
