--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06e3d1fa = require("@lib/monster/helper_06e3d1fa")

--- Helper function.
local function helper_6f1cb0ef()
	local var3: f32 = 0
	while true do
		monster.SetMos("立ち", -1, 0)
		vm.wait()
		helper_06e3d1fa()
		var3 = monster.GetTargetDist() or var3
		if var3 < 280.0 then
			vm.wait()
			return
		end
	end
end

return helper_6f1cb0ef
