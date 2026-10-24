--!strict
-- Shared event helper used by 260 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_c624bc16()
	local var0: s32 = 0
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return helper_c624bc16
