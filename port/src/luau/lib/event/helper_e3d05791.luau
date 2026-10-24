--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3729284c = require("@lib/event/helper_3729284c")
local helper_a894a6c7 = require("@lib/event/helper_a894a6c7")
local helper_b4e8c6a3 = require("@lib/event/helper_b4e8c6a3")
local helper_fe0b8a94 = require("@lib/event/helper_fe0b8a94")

--- Helper function.
local function helper_e3d05791(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3729284c(arg0, arg1)
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
		helper_3729284c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_a894a6c7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_b4e8c6a3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_fe0b8a94(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_e3d05791
