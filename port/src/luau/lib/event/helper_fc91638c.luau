--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4e8ca68d = require("@lib/event/helper_4e8ca68d")
local helper_9f6e33a6 = require("@lib/event/helper_9f6e33a6")
local helper_a9bbe846 = require("@lib/event/helper_a9bbe846")
local helper_bf358213 = require("@lib/event/helper_bf358213")

--- Helper function.
local function helper_fc91638c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4e8ca68d(arg0, arg1)
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
		helper_4e8ca68d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_bf358213(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_a9bbe846(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_9f6e33a6(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_fc91638c
