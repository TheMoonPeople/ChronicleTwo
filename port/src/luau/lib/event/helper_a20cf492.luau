--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5459c976 = require("@lib/event/helper_5459c976")
local helper_80984147 = require("@lib/event/helper_80984147")
local helper_a21efb03 = require("@lib/event/helper_a21efb03")
local helper_a980f4c3 = require("@lib/event/helper_a980f4c3")

--- Helper function.
local function helper_a20cf492(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a980f4c3(arg0, arg1)
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
		helper_a980f4c3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_5459c976(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_a21efb03(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_80984147(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_a20cf492
