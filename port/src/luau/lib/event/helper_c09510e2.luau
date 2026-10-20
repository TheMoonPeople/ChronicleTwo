--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_329c1757 = require("@lib/event/helper_329c1757")
local helper_3c8cbc4e = require("@lib/event/helper_3c8cbc4e")
local helper_5d763052 = require("@lib/event/helper_5d763052")
local helper_8bec73c7 = require("@lib/event/helper_8bec73c7")
local helper_c7af224d = require("@lib/event/helper_c7af224d")

--- Helper function.
local function helper_c09510e2(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c7af224d(1)
		end
		if at <= 2 then
			helper_5d763052(0, -1, 8, 0, 0)
			helper_8bec73c7(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_3c8cbc4e(arg2)
		end
		helper_329c1757(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_c7af224d(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_5d763052(0, -1, 8, 0, 0)
	helper_8bec73c7(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_3c8cbc4e(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_329c1757(0)
end

return helper_c09510e2
