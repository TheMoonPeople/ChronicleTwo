--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0353a07e = require("@lib/event/helper_0353a07e")
local helper_df9138a6 = require("@lib/event/helper_df9138a6")
local helper_e0b6d158 = require("@lib/event/helper_e0b6d158")
local helper_fb334994 = require("@lib/event/helper_fb334994")

--- Helper function.
local function helper_7c955bd0(arg0: s32, arg1: s32)
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
		helper_0353a07e(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_df9138a6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_e0b6d158(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_fb334994(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_7c955bd0
