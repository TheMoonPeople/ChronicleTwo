--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06b50a23 = require("@lib/event/helper_06b50a23")
local helper_9200285b = require("@lib/event/helper_9200285b")
local helper_c54ba3a5 = require("@lib/event/helper_c54ba3a5")
local helper_f059d6b3 = require("@lib/event/helper_f059d6b3")

--- Helper function.
local function helper_529cb606(arg0: s32, arg1: s32)
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
		helper_c54ba3a5(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_f059d6b3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_06b50a23(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_9200285b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_529cb606
