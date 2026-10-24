--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_100ac525 = require("@lib/event/helper_100ac525")
local helper_1c43045c = require("@lib/event/helper_1c43045c")
local helper_26b14944 = require("@lib/event/helper_26b14944")
local helper_86c454a8 = require("@lib/event/helper_86c454a8")
local helper_a5edb217 = require("@lib/event/helper_a5edb217")

--- Helper function.
local function helper_f63a0ea5(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a5edb217(1)
		end
		if at <= 2 then
			helper_1c43045c(0, -1, 8, 0, 0)
			helper_86c454a8(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_100ac525(arg2)
		end
		helper_26b14944(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_a5edb217(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_1c43045c(0, -1, 8, 0, 0)
	helper_86c454a8(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_100ac525(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_26b14944(0)
end

return helper_f63a0ea5
