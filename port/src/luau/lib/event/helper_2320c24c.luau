--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_591fc661 = require("@lib/event/helper_591fc661")
local helper_6f5230e9 = require("@lib/event/helper_6f5230e9")
local helper_95e76b0f = require("@lib/event/helper_95e76b0f")
local helper_d217e294 = require("@lib/event/helper_d217e294")

--- Helper function.
local function helper_2320c24c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d217e294(arg0, arg1)
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
		helper_d217e294(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_591fc661(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_6f5230e9(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_95e76b0f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_2320c24c
