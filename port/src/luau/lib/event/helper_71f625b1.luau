--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22e34d28 = require("@lib/event/helper_22e34d28")
local helper_a5bdcaf8 = require("@lib/event/helper_a5bdcaf8")
local helper_c758eb34 = require("@lib/event/helper_c758eb34")
local helper_d759a0ab = require("@lib/event/helper_d759a0ab")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

--- Helper function.
local function helper_71f625b1(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c758eb34(1)
		end
		if at <= 2 then
			helper_22e34d28(0, -1, 8, 0, 0)
			helper_a5bdcaf8(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_ed0a80b8(arg2)
		end
		helper_d759a0ab(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_c758eb34(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_22e34d28(0, -1, 8, 0, 0)
	helper_a5bdcaf8(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_ed0a80b8(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_d759a0ab(0)
end

return helper_71f625b1
