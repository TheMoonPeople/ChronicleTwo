--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_329a1566 = require("@lib/event/helper_329a1566")
local helper_b0bac3cf = require("@lib/event/helper_b0bac3cf")
local helper_ecf0e369 = require("@lib/event/helper_ecf0e369")
local helper_f07bdcc0 = require("@lib/event/helper_f07bdcc0")

--- Helper function.
local function helper_a3559941(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_f07bdcc0(arg0, arg1)
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
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_f07bdcc0(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_ecf0e369(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_b0bac3cf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_329a1566(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_a3559941
