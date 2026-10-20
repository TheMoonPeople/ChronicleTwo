--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_103588a7 = require("@lib/event/helper_103588a7")
local helper_35cb9ed3 = require("@lib/event/helper_35cb9ed3")
local helper_6dc2b473 = require("@lib/event/helper_6dc2b473")
local helper_7b4ae2f4 = require("@lib/event/helper_7b4ae2f4")

--- Helper function.
local function helper_c9cddfe6(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_35cb9ed3(arg0, arg1, 0)
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
		helper_35cb9ed3(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_7b4ae2f4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_103588a7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_6dc2b473(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_c9cddfe6
