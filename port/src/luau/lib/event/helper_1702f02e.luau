--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2503c0bf = require("@lib/event/helper_2503c0bf")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_aa1ac59e = require("@lib/event/helper_aa1ac59e")
local helper_d84b5170 = require("@lib/event/helper_d84b5170")
local helper_ddb278e0 = require("@lib/event/helper_ddb278e0")

--- Helper function.
local function helper_1702f02e(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_aa1ac59e(1)
		end
		if at <= 2 then
			helper_2503c0bf(0, -1, 8, 0, 0)
			helper_ddb278e0(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_a0e17f3c(arg2)
		end
		helper_d84b5170(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_aa1ac59e(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_2503c0bf(0, -1, 8, 0, 0)
	helper_ddb278e0(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_a0e17f3c(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_d84b5170(0)
end

return helper_1702f02e
