--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_044fd257 = require("@lib/event/helper_044fd257")
local helper_388829ca = require("@lib/event/helper_388829ca")
local helper_4111b872 = require("@lib/event/helper_4111b872")
local helper_e143ba08 = require("@lib/event/helper_e143ba08")

--- Helper function.
local function helper_79d8c095(arg0: s32, arg1: s32)
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
		helper_044fd257(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_4111b872(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_388829ca(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_e143ba08(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_79d8c095
