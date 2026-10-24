--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a8b5d854 = require("@lib/event/helper_a8b5d854")
local helper_b90ffbb8 = require("@lib/event/helper_b90ffbb8")
local helper_ed11f95b = require("@lib/event/helper_ed11f95b")
local helper_fdd8b5e6 = require("@lib/event/helper_fdd8b5e6")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")

--- Helper function.
local function helper_d60c1fd9(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_fdd8b5e6(1)
		end
		if at <= 2 then
			helper_fdffeda5(0, -1, 8, 0, 0)
			helper_ed11f95b(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_a8b5d854(arg2)
		end
		helper_b90ffbb8(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_fdd8b5e6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_fdffeda5(0, -1, 8, 0, 0)
	helper_ed11f95b(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_a8b5d854(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_b90ffbb8(0)
end

return helper_d60c1fd9
