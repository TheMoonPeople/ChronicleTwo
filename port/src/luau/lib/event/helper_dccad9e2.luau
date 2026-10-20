--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_16b89c0e = require("@lib/event/helper_16b89c0e")
local helper_4a1b71e2 = require("@lib/event/helper_4a1b71e2")
local helper_62605520 = require("@lib/event/helper_62605520")
local helper_d0338de7 = require("@lib/event/helper_d0338de7")

--- Helper function.
local function helper_dccad9e2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_62605520(arg0, arg1)
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
		helper_62605520(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_4a1b71e2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_d0338de7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_16b89c0e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_dccad9e2
