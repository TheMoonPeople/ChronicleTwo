--!strict
-- Shared action helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9559fe61(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	var3 = 1
	while var3 ~= 0 do
		vm.wait()
		var2 = action.NowMosWait() or var2
		if var2 >= arg0 and var2 <= arg1 then
			var3 = 0
		end
	end
end

return helper_9559fe61
