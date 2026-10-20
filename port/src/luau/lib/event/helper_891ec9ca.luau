--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_31a3b707 = require("@lib/event/helper_31a3b707")
local helper_64e99d3d = require("@lib/event/helper_64e99d3d")
local helper_969c5ad6 = require("@lib/event/helper_969c5ad6")
local helper_d395a4a5 = require("@lib/event/helper_d395a4a5")
local helper_ee3beaa9 = require("@lib/event/helper_ee3beaa9")

--- Helper function.
local function helper_891ec9ca(arg0: any, arg1: s32, arg2: any)
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_31a3b707(1)
		end
		if at <= 2 then
			helper_d395a4a5(0, -1, 8, 0, 0)
			helper_ee3beaa9(0, arg1)
		end
		if at <= 3 then
			arg2 = arg2
			helper_64e99d3d(arg2)
		end
		helper_969c5ad6(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Ext(231, 0, var3) -- retail: the handler rejects 2 arguments
	event.StreamOpen3(1, arg0)
	helper_31a3b707(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	event.MesMake_2(0, arg0)
	helper_d395a4a5(0, -1, 8, 0, 0)
	helper_ee3beaa9(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMesOkuri(0, var3)
	if arg2 > 0 then
		arg2 = arg2
	end
	helper_64e99d3d(arg2)
	if vm.skipping() then
		return skip(4)
	end
	event.SetMesOkuri(0, 0)
	event.StreamClose(1)
	helper_969c5ad6(0)
end

return helper_891ec9ca
