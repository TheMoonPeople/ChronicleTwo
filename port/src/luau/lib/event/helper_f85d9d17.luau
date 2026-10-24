--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26c13524 = require("@lib/event/helper_26c13524")
local helper_931b01d9 = require("@lib/event/helper_931b01d9")
local helper_a69fa4ed = require("@lib/event/helper_a69fa4ed")
local helper_c1317169 = require("@lib/event/helper_c1317169")

--- Helper function.
local function helper_f85d9d17(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
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
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_931b01d9(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_a69fa4ed(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_26c13524(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_c1317169(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_f85d9d17
