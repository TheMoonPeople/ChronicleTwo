--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23b9be98 = require("@lib/event/helper_23b9be98")
local helper_365d5424 = require("@lib/event/helper_365d5424")
local helper_58bda493 = require("@lib/event/helper_58bda493")
local helper_96cbf3ce = require("@lib/event/helper_96cbf3ce")

--- Helper function.
local function helper_38d10df9(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_365d5424(arg0, arg1)
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
		helper_365d5424(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_23b9be98(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_96cbf3ce(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_58bda493(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_38d10df9
