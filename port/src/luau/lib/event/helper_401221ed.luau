--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_00026766 = require("@lib/event/helper_00026766")
local helper_5f77409f = require("@lib/event/helper_5f77409f")
local helper_803621f6 = require("@lib/event/helper_803621f6")
local helper_c312db26 = require("@lib/event/helper_c312db26")
local helper_c85a55f2 = require("@lib/event/helper_c85a55f2")

--- Helper function.
local function helper_401221ed(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_803621f6(1)
		end
		if at <= 2 then
			helper_00026766(0, -1, 8, 0, 0)
			helper_c312db26(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_c85a55f2(arg2)
		end
		helper_5f77409f(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_803621f6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_00026766(0, -1, 8, 0, 0)
	helper_c312db26(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_c85a55f2(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_5f77409f(0)
end

return helper_401221ed
