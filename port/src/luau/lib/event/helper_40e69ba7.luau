--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27d4dc14 = require("@lib/event/helper_27d4dc14")
local helper_4def91a5 = require("@lib/event/helper_4def91a5")
local helper_856dbe85 = require("@lib/event/helper_856dbe85")
local helper_85bd97d8 = require("@lib/event/helper_85bd97d8")
local helper_da44d11a = require("@lib/event/helper_da44d11a")

--- Helper function.
local function helper_40e69ba7(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4def91a5(1)
		end
		if at <= 2 then
			helper_27d4dc14(0, -1, 8, 0, 0)
			helper_856dbe85(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_da44d11a(arg2)
		end
		helper_85bd97d8(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_4def91a5(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_27d4dc14(0, -1, 8, 0, 0)
	helper_856dbe85(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_da44d11a(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_85bd97d8(0)
end

return helper_40e69ba7
