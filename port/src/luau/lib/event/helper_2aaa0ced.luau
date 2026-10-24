--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_35963413 = require("@lib/event/helper_35963413")
local helper_c3547a0e = require("@lib/event/helper_c3547a0e")
local helper_dd135848 = require("@lib/event/helper_dd135848")
local helper_e9b69603 = require("@lib/event/helper_e9b69603")

--- Helper function.
local function helper_2aaa0ced(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_35963413(arg0, arg1)
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
		helper_35963413(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_c3547a0e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_dd135848(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e9b69603(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_2aaa0ced
