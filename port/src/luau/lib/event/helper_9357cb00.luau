--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c8c39a1 = require("@lib/event/helper_1c8c39a1")
local helper_2bd00f1e = require("@lib/event/helper_2bd00f1e")
local helper_522670ce = require("@lib/event/helper_522670ce")
local helper_5716569e = require("@lib/event/helper_5716569e")
local helper_b5f02d99 = require("@lib/event/helper_b5f02d99")

--- Helper function.
local function helper_9357cb00(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b5f02d99(1)
		end
		if at <= 2 then
			helper_522670ce(0, -1, 8, 0, 0)
			helper_2bd00f1e(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_1c8c39a1(arg2)
		end
		helper_5716569e(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_b5f02d99(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_522670ce(0, -1, 8, 0, 0)
	helper_2bd00f1e(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_1c8c39a1(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_5716569e(0)
end

return helper_9357cb00
