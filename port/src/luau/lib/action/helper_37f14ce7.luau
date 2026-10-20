--!strict
-- Shared action helper used by 17 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_9da84b8b = require("@lib/action/helper_9da84b8b")

--- Helper function.
local function helper_37f14ce7()
	local var0: s32 = 0
	action.ReleaseObj(0)
	action.SetMos("死に", -1, 6)
	helper_9da84b8b()
	while true do
		var0 = action.GetBtn_2(50) or var0
		if var0 ~= 0 then
			break
		else
			vm.wait()
		end
	end
	action.ProgSet(0)
end

return helper_37f14ce7
