--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2e854ff2 = require("@lib/event/helper_2e854ff2")
local helper_61d87b3f = require("@lib/event/helper_61d87b3f")
local helper_69d1dd55 = require("@lib/event/helper_69d1dd55")
local helper_8f3694dd = require("@lib/event/helper_8f3694dd")
local helper_b51fc149 = require("@lib/event/helper_b51fc149")

--- Helper function.
local function helper_7f333edb(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_61d87b3f(1)
		end
		if at <= 2 then
			helper_8f3694dd(0, -1, 8, 0, 0)
			helper_2e854ff2(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_b51fc149(arg2)
		end
		helper_69d1dd55(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_61d87b3f(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_8f3694dd(0, -1, 8, 0, 0)
	helper_2e854ff2(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_b51fc149(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_69d1dd55(0)
end

return helper_7f333edb
