--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_078b1d80 = require("@lib/event/helper_078b1d80")
local helper_89bc0aca = require("@lib/event/helper_89bc0aca")
local helper_99836410 = require("@lib/event/helper_99836410")
local helper_ad3984ab = require("@lib/event/helper_ad3984ab")

--- Helper function.
local function helper_85dfe7c6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_078b1d80(arg0, arg1)
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
		helper_078b1d80(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_99836410(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ad3984ab(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_89bc0aca(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_85dfe7c6
