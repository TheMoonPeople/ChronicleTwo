--!strict
-- Shared event helper used by 25 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_57ae27b6 = require("@lib/event/helper_57ae27b6")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_f37e8af2 = require("@lib/event/helper_f37e8af2")

--- Helper function.
local function helper_a03e568e(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_57ae27b6(1)
		end
		if at <= 2 then
			helper_27ff0b8f(0, -1, 8, 0, 0)
			helper_f37e8af2(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_aafd6a80(arg2)
		end
		helper_dd7a6f53(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_57ae27b6(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_27ff0b8f(0, -1, 8, 0, 0)
	helper_f37e8af2(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_aafd6a80(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_dd7a6f53(0)
end

return helper_a03e568e
