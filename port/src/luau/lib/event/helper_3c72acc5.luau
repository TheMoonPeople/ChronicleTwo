--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3513260d = require("@lib/event/helper_3513260d")
local helper_a5feeb16 = require("@lib/event/helper_a5feeb16")
local helper_b67f1630 = require("@lib/event/helper_b67f1630")
local helper_d5216612 = require("@lib/event/helper_d5216612")

--- Helper function.
local function helper_3c72acc5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b67f1630(arg0, arg1)
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
		helper_b67f1630(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 19) or var2
	if var2 == 0 then
		helper_3513260d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_a5feeb16(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_d5216612(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_3c72acc5
