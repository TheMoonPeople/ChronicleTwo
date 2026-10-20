--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12da9e56 = require("@lib/event/helper_12da9e56")
local helper_3e3eb4a7 = require("@lib/event/helper_3e3eb4a7")
local helper_8745d638 = require("@lib/event/helper_8745d638")
local helper_960cfd57 = require("@lib/event/helper_960cfd57")

--- Helper function.
local function helper_f5e85c88(arg0: s32, arg1: s32)
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
		helper_3e3eb4a7(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_8745d638(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_12da9e56(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_960cfd57(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_f5e85c88
