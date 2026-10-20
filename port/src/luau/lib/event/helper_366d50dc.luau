--!strict
-- Shared event helper used by 20 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1953c457 = require("@lib/event/helper_1953c457")
local helper_1f6c4dc7 = require("@lib/event/helper_1f6c4dc7")
local helper_894b5c3b = require("@lib/event/helper_894b5c3b")
local helper_adea7ba0 = require("@lib/event/helper_adea7ba0")
local helper_e797fcc8 = require("@lib/event/helper_e797fcc8")

--- Helper function.
local function helper_366d50dc(arg0: s32, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_894b5c3b(1)
		end
		if at <= 2 then
			helper_e797fcc8(0, -1, 8, 0, 0)
			helper_1f6c4dc7(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_adea7ba0(arg2)
		end
		helper_1953c457(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_894b5c3b(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_e797fcc8(0, -1, 8, 0, 0)
	helper_1f6c4dc7(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_adea7ba0(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_1953c457(0)
end

return helper_366d50dc
