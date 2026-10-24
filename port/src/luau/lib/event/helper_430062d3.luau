--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2bd56995 = require("@lib/event/helper_2bd56995")
local helper_81254767 = require("@lib/event/helper_81254767")
local helper_84adb214 = require("@lib/event/helper_84adb214")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_e03e89ed = require("@lib/event/helper_e03e89ed")

--- Helper function.
local function helper_430062d3(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2bd56995(1)
		end
		if at <= 2 then
			helper_e03e89ed(0, -1, 8, 0, 0)
			helper_84adb214(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_c1c32f84(arg2)
		end
		helper_81254767(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_2bd56995(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_e03e89ed(0, -1, 8, 0, 0)
	helper_84adb214(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_c1c32f84(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_81254767(0)
end

return helper_430062d3
