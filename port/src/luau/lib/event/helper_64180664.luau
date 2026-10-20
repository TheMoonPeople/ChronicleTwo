--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1e76241a = require("@lib/event/helper_1e76241a")
local helper_4b94f782 = require("@lib/event/helper_4b94f782")
local helper_8f179710 = require("@lib/event/helper_8f179710")
local helper_b937bf9e = require("@lib/event/helper_b937bf9e")

--- Helper function.
local function helper_64180664(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_1e76241a(arg0, arg1)
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
		helper_1e76241a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_4b94f782(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_b937bf9e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_8f179710(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_64180664
