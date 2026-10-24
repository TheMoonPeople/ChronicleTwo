--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_32c6d3c9 = require("@lib/event/helper_32c6d3c9")
local helper_3dcaa55a = require("@lib/event/helper_3dcaa55a")
local helper_7401c4b3 = require("@lib/event/helper_7401c4b3")
local helper_7fabb3a7 = require("@lib/event/helper_7fabb3a7")

--- Helper function.
local function helper_349b1f0d(arg0: s32, arg1: s32)
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
		helper_3dcaa55a(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_32c6d3c9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_7fabb3a7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_7401c4b3(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_349b1f0d
