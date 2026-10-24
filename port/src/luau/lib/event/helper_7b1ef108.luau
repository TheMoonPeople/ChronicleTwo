--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_74aa7964 = require("@lib/event/helper_74aa7964")
local helper_79d19617 = require("@lib/event/helper_79d19617")
local helper_9b82f21d = require("@lib/event/helper_9b82f21d")
local helper_c4777c25 = require("@lib/event/helper_c4777c25")

--- Helper function.
local function helper_7b1ef108(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_74aa7964(arg0, arg1)
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
		helper_74aa7964(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_9b82f21d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_79d19617(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_c4777c25(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_7b1ef108
