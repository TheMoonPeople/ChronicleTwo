--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47d71f9a = require("@lib/event/helper_47d71f9a")
local helper_4b5a8f9d = require("@lib/event/helper_4b5a8f9d")
local helper_90e38e58 = require("@lib/event/helper_90e38e58")
local helper_dc10aa5f = require("@lib/event/helper_dc10aa5f")

--- Helper function.
local function helper_fba6a0ed(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dc10aa5f(arg0, arg1)
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
		helper_dc10aa5f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_47d71f9a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_90e38e58(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_4b5a8f9d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_fba6a0ed
