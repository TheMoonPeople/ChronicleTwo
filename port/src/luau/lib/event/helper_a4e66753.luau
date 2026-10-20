--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_633b4244 = require("@lib/event/helper_633b4244")
local helper_fcb18908 = require("@lib/event/helper_fcb18908")

--- Helper function.
local function helper_a4e66753(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_fcb18908(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_633b4244(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_fcb18908(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_633b4244(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_a4e66753
