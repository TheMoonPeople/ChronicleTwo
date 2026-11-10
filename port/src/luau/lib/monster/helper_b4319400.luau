--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f23ca43 = require("@lib/monster/helper_0f23ca43")

--- Helper function.
local function helper_b4319400()
	local var3: f32 = 0
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 < 200.0 then
			vm.wait()
			return
		end
		helper_0f23ca43()
	end
end

return helper_b4319400
