--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bf943cd = require("@lib/event/helper_0bf943cd")
local helper_6aa77305 = require("@lib/event/helper_6aa77305")
local helper_8d0a7543 = require("@lib/event/helper_8d0a7543")
local helper_9c403f39 = require("@lib/event/helper_9c403f39")

--- Helper function.
local function helper_338c09af(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0bf943cd(arg0, arg1)
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
		helper_0bf943cd(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_8d0a7543(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_9c403f39(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_6aa77305(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_338c09af
