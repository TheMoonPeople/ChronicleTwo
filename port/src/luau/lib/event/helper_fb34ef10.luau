--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c43045c = require("@lib/event/helper_1c43045c")
local helper_d0bf4a49 = require("@lib/event/helper_d0bf4a49")

--- Helper function.
local function helper_fb34ef10(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32, arg5: s32, arg6: s32)
	local var8: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
			var8 = helper_d0bf4a49(arg0, arg5, arg6, 0)
		end
		return var8
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_1c43045c(arg0, arg1, arg2, arg3, arg4)
	var8 = helper_d0bf4a49(arg0, arg5, arg6, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.SetMesPos(arg0, 0)
	return var8
end

return helper_fb34ef10
