--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9235e17f = require("@lib/event/helper_9235e17f")
local helper_d99c83c1 = require("@lib/event/helper_d99c83c1")
local helper_dabe3ce2 = require("@lib/event/helper_dabe3ce2")
local helper_df4c2cf7 = require("@lib/event/helper_df4c2cf7")

--- Helper function.
local function helper_13f523ff(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_df4c2cf7(arg0, arg1)
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
		helper_df4c2cf7(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_9235e17f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_dabe3ce2(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_d99c83c1(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_13f523ff
