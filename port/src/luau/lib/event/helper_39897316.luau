--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05f13031 = require("@lib/event/helper_05f13031")
local helper_604d1827 = require("@lib/event/helper_604d1827")
local helper_64b3a7ae = require("@lib/event/helper_64b3a7ae")
local helper_b4b9bfbc = require("@lib/event/helper_b4b9bfbc")
local helper_e8b18690 = require("@lib/event/helper_e8b18690")

--- Helper function.
local function helper_39897316(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_64b3a7ae(1)
		end
		if at <= 2 then
			helper_b4b9bfbc(0, -1, 8, 0, 0)
			helper_05f13031(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_e8b18690(arg2)
		end
		helper_604d1827(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_64b3a7ae(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_b4b9bfbc(0, -1, 8, 0, 0)
	helper_05f13031(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_e8b18690(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_604d1827(0)
end

return helper_39897316
