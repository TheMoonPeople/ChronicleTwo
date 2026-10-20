--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1a04d799 = require("@lib/event/helper_1a04d799")
local helper_b0938cc1 = require("@lib/event/helper_b0938cc1")
local helper_ea6c4b41 = require("@lib/event/helper_ea6c4b41")
local helper_f2bb956d = require("@lib/event/helper_f2bb956d")

--- Helper function.
local function helper_23f7e5c7(arg0: s32, arg1: s32)
	local var2: s32 = 0
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
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_f2bb956d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_ea6c4b41(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_b0938cc1(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_1a04d799(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_23f7e5c7
