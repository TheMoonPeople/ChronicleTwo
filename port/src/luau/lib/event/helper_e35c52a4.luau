--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7ad8af37 = require("@lib/event/helper_7ad8af37")
local helper_aa9fd447 = require("@lib/event/helper_aa9fd447")
local helper_d1d638ee = require("@lib/event/helper_d1d638ee")
local helper_d8f507ea = require("@lib/event/helper_d8f507ea")

--- Helper function.
local function helper_e35c52a4(arg0: s32, arg1: s32)
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
		helper_d8f507ea(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_d1d638ee(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_aa9fd447(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_7ad8af37(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_e35c52a4
