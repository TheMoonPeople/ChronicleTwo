--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ebd2cd9 = require("@lib/event/helper_1ebd2cd9")
local helper_44f2f24a = require("@lib/event/helper_44f2f24a")
local helper_7582bb05 = require("@lib/event/helper_7582bb05")
local helper_bdabcadf = require("@lib/event/helper_bdabcadf")

--- Helper function.
local function helper_4690f525(arg0: s32, arg1: s32)
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
		helper_7582bb05(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_1ebd2cd9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_44f2f24a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_bdabcadf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_4690f525
