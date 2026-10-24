--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_72643bb6 = require("@lib/event/helper_72643bb6")
local helper_7443da3d = require("@lib/event/helper_7443da3d")
local helper_8a64cd6a = require("@lib/event/helper_8a64cd6a")
local helper_f78c4e0e = require("@lib/event/helper_f78c4e0e")
local helper_fcb18908 = require("@lib/event/helper_fcb18908")

--- Helper function.
local function helper_2d210f8b(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f78c4e0e(1)
		end
		if at <= 2 then
			helper_fcb18908(0, -1, 8, 0, 0)
			helper_8a64cd6a(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_72643bb6(arg2)
		end
		helper_7443da3d(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_f78c4e0e(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_fcb18908(0, -1, 8, 0, 0)
	helper_8a64cd6a(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_72643bb6(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_7443da3d(0)
end

return helper_2d210f8b
