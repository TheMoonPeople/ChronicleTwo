--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_090f0448 = require("@lib/event/helper_090f0448")
local helper_854d8da2 = require("@lib/event/helper_854d8da2")
local helper_c57bb1a8 = require("@lib/event/helper_c57bb1a8")
local helper_e85df3b0 = require("@lib/event/helper_e85df3b0")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")

--- Helper function.
local function helper_1497768d(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_090f0448(1)
		end
		if at <= 2 then
			helper_e85df3b0(0, -1, 8, 0, 0)
			helper_c57bb1a8(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_efffcfbb(arg2)
		end
		helper_854d8da2(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_090f0448(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_e85df3b0(0, -1, 8, 0, 0)
	helper_c57bb1a8(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_efffcfbb(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_854d8da2(0)
end

return helper_1497768d
