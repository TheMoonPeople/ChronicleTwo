--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5c123176 = require("@lib/event/helper_5c123176")
local helper_b971cedc = require("@lib/event/helper_b971cedc")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_c570169b = require("@lib/event/helper_c570169b")
local helper_eb354717 = require("@lib/event/helper_eb354717")

--- Helper function.
local function helper_7bb034a7(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b971cedc(1)
		end
		if at <= 2 then
			helper_eb354717(0, -1, 8, 0, 0)
			helper_c570169b(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_bdbefa67(arg2)
		end
		helper_5c123176(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_b971cedc(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_eb354717(0, -1, 8, 0, 0)
	helper_c570169b(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_bdbefa67(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_5c123176(0)
end

return helper_7bb034a7
