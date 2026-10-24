--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_23369a5e = require("@lib/event/helper_23369a5e")
local helper_2f481f12 = require("@lib/event/helper_2f481f12")
local helper_ceb1f098 = require("@lib/event/helper_ceb1f098")
local helper_e62dd413 = require("@lib/event/helper_e62dd413")
local helper_e95ecf38 = require("@lib/event/helper_e95ecf38")

--- Helper function.
local function helper_78000d2f(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e95ecf38(1)
		end
		if at <= 2 then
			helper_e62dd413(0, -1, 8, 0, 0)
			helper_ceb1f098(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_2f481f12(arg2)
		end
		helper_23369a5e(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_e95ecf38(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_e62dd413(0, -1, 8, 0, 0)
	helper_ceb1f098(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_2f481f12(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_23369a5e(0)
end

return helper_78000d2f
