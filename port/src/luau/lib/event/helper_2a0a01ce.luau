--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2ae7062f = require("@lib/event/helper_2ae7062f")
local helper_55a39038 = require("@lib/event/helper_55a39038")
local helper_5bda467f = require("@lib/event/helper_5bda467f")
local helper_db76c1fc = require("@lib/event/helper_db76c1fc")

--- Helper function.
local function helper_2a0a01ce(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2ae7062f(arg0, arg1)
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
		helper_2ae7062f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_5bda467f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_db76c1fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_55a39038(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_2a0a01ce
