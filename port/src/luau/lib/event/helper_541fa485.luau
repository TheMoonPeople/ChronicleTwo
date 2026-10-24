--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_219d40b9 = require("@lib/event/helper_219d40b9")
local helper_3e2628eb = require("@lib/event/helper_3e2628eb")
local helper_41fb4f84 = require("@lib/event/helper_41fb4f84")
local helper_890b5665 = require("@lib/event/helper_890b5665")
local helper_90f18c68 = require("@lib/event/helper_90f18c68")

--- Helper function.
local function helper_541fa485(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_41fb4f84(1)
		end
		if at <= 2 then
			helper_3e2628eb(0, -1, 8, 0, 0)
			helper_90f18c68(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_890b5665(arg2)
		end
		helper_219d40b9(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_41fb4f84(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_3e2628eb(0, -1, 8, 0, 0)
	helper_90f18c68(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_890b5665(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_219d40b9(0)
end

return helper_541fa485
