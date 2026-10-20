--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4c127924 = require("@lib/event/helper_4c127924")
local helper_a4a0a430 = require("@lib/event/helper_a4a0a430")
local helper_b7cd86df = require("@lib/event/helper_b7cd86df")
local helper_cc831f3e = require("@lib/event/helper_cc831f3e")

--- Helper function.
local function helper_afc674c9(arg0: s32, arg1: s32)
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
		helper_cc831f3e(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_a4a0a430(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_b7cd86df(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_4c127924(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_afc674c9
