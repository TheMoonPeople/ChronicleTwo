--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6168008a = require("@lib/event/helper_6168008a")
local helper_a923707e = require("@lib/event/helper_a923707e")
local helper_d8d6545a = require("@lib/event/helper_d8d6545a")
local helper_e518bc0d = require("@lib/event/helper_e518bc0d")

--- Helper function.
local function helper_422e9067(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e518bc0d(arg0, arg1)
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
		helper_e518bc0d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_a923707e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_d8d6545a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_6168008a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_422e9067
