--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0433f6e4 = require("@lib/event/helper_0433f6e4")
local helper_9660e7cc = require("@lib/event/helper_9660e7cc")
local helper_99b3e0d6 = require("@lib/event/helper_99b3e0d6")
local helper_9ac5c278 = require("@lib/event/helper_9ac5c278")
local helper_cc3c3399 = require("@lib/event/helper_cc3c3399")

--- Helper function.
local function helper_68536db5(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0433f6e4(1)
		end
		if at <= 2 then
			helper_9ac5c278(0, -1, 8, 0, 0)
			helper_99b3e0d6(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_cc3c3399(arg2)
		end
		helper_9660e7cc(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_0433f6e4(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_9ac5c278(0, -1, 8, 0, 0)
	helper_99b3e0d6(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_cc3c3399(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_9660e7cc(0)
end

return helper_68536db5
