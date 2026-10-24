--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05deb318 = require("@lib/event/helper_05deb318")
local helper_19c92a8d = require("@lib/event/helper_19c92a8d")
local helper_8816da95 = require("@lib/event/helper_8816da95")
local helper_c1a3bc21 = require("@lib/event/helper_c1a3bc21")

--- Helper function.
local function helper_5c8704e5(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_19c92a8d(arg0, arg1, 0)
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
		helper_19c92a8d(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_c1a3bc21(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_8816da95(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_05deb318(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_5c8704e5
