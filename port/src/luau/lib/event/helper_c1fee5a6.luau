--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0205a539 = require("@lib/event/helper_0205a539")
local helper_4753e810 = require("@lib/event/helper_4753e810")
local helper_e7df4141 = require("@lib/event/helper_e7df4141")
local helper_ffd3c562 = require("@lib/event/helper_ffd3c562")

--- Helper function.
local function helper_c1fee5a6(arg0: s32, arg1: s32)
	local var2: s32 = 0
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
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_e7df4141(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_0205a539(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_ffd3c562(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_4753e810(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_c1fee5a6
