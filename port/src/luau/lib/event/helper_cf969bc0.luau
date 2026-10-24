--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2e8cfc5c = require("@lib/event/helper_2e8cfc5c")
local helper_474c5bc8 = require("@lib/event/helper_474c5bc8")
local helper_750fa174 = require("@lib/event/helper_750fa174")
local helper_bd8026bc = require("@lib/event/helper_bd8026bc")
local helper_be5e42c1 = require("@lib/event/helper_be5e42c1")

--- Helper function.
local function helper_cf969bc0(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bd8026bc(1)
		end
		if at <= 2 then
			helper_2e8cfc5c(0, -1, 8, 0, 0)
			helper_750fa174(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_474c5bc8(arg2)
		end
		helper_be5e42c1(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_bd8026bc(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_2e8cfc5c(0, -1, 8, 0, 0)
	helper_750fa174(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_474c5bc8(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_be5e42c1(0)
end

return helper_cf969bc0
