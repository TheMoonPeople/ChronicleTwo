--!strict
-- Shared event helper used by 15 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1d5088bd = require("@lib/event/helper_1d5088bd")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_2ba993e3 = require("@lib/event/helper_2ba993e3")
local helper_4601e60b = require("@lib/event/helper_4601e60b")
local helper_8980cad2 = require("@lib/event/helper_8980cad2")

--- Helper function.
local function helper_aac4ded0(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4601e60b(1)
		end
		if at <= 2 then
			helper_24d1805d(0, -1, 8, 0, 0)
			helper_1d5088bd(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_8980cad2(arg2)
		end
		helper_2ba993e3(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_4601e60b(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_24d1805d(0, -1, 8, 0, 0)
	helper_1d5088bd(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_8980cad2(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_2ba993e3(0)
end

return helper_aac4ded0
