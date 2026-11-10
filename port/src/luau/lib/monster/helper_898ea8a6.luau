--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_93a51a2c = require("@lib/monster/helper_93a51a2c")

--- Helper function.
local function helper_898ea8a6()
	local var3: f32 = 0
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 < 175.0 then
			vm.wait()
			return
		end
		helper_93a51a2c()
	end
end

return helper_898ea8a6
