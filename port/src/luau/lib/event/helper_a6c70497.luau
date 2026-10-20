--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_523d475c = require("@lib/event/helper_523d475c")
local helper_6389003f = require("@lib/event/helper_6389003f")
local helper_93763a2c = require("@lib/event/helper_93763a2c")
local helper_946ad1c2 = require("@lib/event/helper_946ad1c2")

--- Helper function.
local function helper_a6c70497(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_93763a2c(arg0, arg1)
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
		helper_93763a2c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_946ad1c2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_523d475c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_6389003f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_a6c70497
