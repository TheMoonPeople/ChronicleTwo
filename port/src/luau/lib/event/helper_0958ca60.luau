--!strict
-- Shared event helper used by 458 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_0958ca60(arg0: s32)
	local var1: s32 = 0
	while true do
		var1 = event.ObjsCheck(arg0) or var1
		if var1 == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return helper_0958ca60
