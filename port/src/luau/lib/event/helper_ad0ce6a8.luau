--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26989c80 = require("@lib/event/helper_26989c80")
local helper_40ff0a0d = require("@lib/event/helper_40ff0a0d")
local helper_5a871b71 = require("@lib/event/helper_5a871b71")
local helper_851dcef0 = require("@lib/event/helper_851dcef0")

--- Helper function.
local function helper_ad0ce6a8(arg0: s32, arg1: s32)
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
		helper_851dcef0(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_40ff0a0d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_26989c80(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_5a871b71(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_ad0ce6a8
