--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_097407fc = require("@lib/event/helper_097407fc")
local helper_6e94ffcc = require("@lib/event/helper_6e94ffcc")
local helper_7e2956fd = require("@lib/event/helper_7e2956fd")
local helper_b0211f82 = require("@lib/event/helper_b0211f82")
local helper_dc39b923 = require("@lib/event/helper_dc39b923")

--- Helper function.
local function helper_2d5c6a8c(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_097407fc(1)
		end
		if at <= 2 then
			helper_dc39b923(0, -1, 8, 0, 0)
			helper_6e94ffcc(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_b0211f82(arg2)
		end
		helper_7e2956fd(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_097407fc(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_dc39b923(0, -1, 8, 0, 0)
	helper_6e94ffcc(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_b0211f82(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_7e2956fd(0)
end

return helper_2d5c6a8c
