--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19a74323 = require("@lib/event/helper_19a74323")
local helper_6fdd737a = require("@lib/event/helper_6fdd737a")
local helper_efde54cc = require("@lib/event/helper_efde54cc")

--- Helper function.
local function helper_059fcb0a(arg0: s32, arg1: any, arg2: any, arg3: s32, arg4: any)
	local var5: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_efde54cc(arg0, arg1, arg2, arg3)
		end
		if at <= 2 then
			_, var5 = helper_6fdd737a(arg0, 0, var5)
		end
		helper_19a74323(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_efde54cc(arg0, arg1, arg2, arg3)
	if vm.skipping() then
		return skip(2)
	end
	_, var5 = helper_6fdd737a(arg0, 0, var5)
	if vm.skipping() then
		return skip(3)
	end
	helper_19a74323(arg0)
end

return helper_059fcb0a
