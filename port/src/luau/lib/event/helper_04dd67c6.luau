--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ec08062 = require("@lib/event/helper_0ec08062")
local helper_7cbd640d = require("@lib/event/helper_7cbd640d")
local helper_80f8bdc9 = require("@lib/event/helper_80f8bdc9")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")
local helper_f8aba7e6 = require("@lib/event/helper_f8aba7e6")

--- Helper function.
local function helper_04dd67c6(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7cbd640d(1)
		end
		if at <= 2 then
			helper_0ec08062(0, -1, 8, 0, 0)
			helper_80f8bdc9(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_bc77b237(arg2)
		end
		helper_f8aba7e6(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_7cbd640d(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_0ec08062(0, -1, 8, 0, 0)
	helper_80f8bdc9(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_bc77b237(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_f8aba7e6(0)
end

return helper_04dd67c6
