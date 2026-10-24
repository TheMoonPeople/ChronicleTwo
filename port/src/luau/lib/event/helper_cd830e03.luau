--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_413849fe = require("@lib/event/helper_413849fe")
local helper_6db3e9e7 = require("@lib/event/helper_6db3e9e7")
local helper_7782707a = require("@lib/event/helper_7782707a")
local helper_ed8919de = require("@lib/event/helper_ed8919de")

--- Helper function.
local function helper_cd830e03(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ed8919de(arg0, arg1)
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
		helper_ed8919de(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_7782707a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_6db3e9e7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_413849fe(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_cd830e03
