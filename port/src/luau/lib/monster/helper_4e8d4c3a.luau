--!strict
-- Shared monster helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_122dfaca = require("@lib/monster/helper_122dfaca")
local helper_2b3d84b9 = require("@lib/monster/helper_2b3d84b9")
local helper_7274c7ab = require("@lib/monster/helper_7274c7ab")
local helper_a7a3b447 = require("@lib/monster/helper_a7a3b447")

--- Helper function.
local function helper_4e8d4c3a()
	local var3: f32 = 0
	local priority: s32 = 0
	local gekirin: s32 = 0
	while true do
		vm.wait()
		var3 = monster.get_target_distance() or var3
		if var3 > 240.0 then
			vm.wait()
			return
		end
		gekirin = vm.float_bits(monster.get_rage_hits_left()) or gekirin
		if gekirin == 0 then
			vm.wait()
			return
		end
		priority = monster.get_priority() or priority
		if priority > 100 then
			helper_122dfaca()
			continue
		end
		if var3 < 240.0 and var3 >= 140.0 then
			helper_a7a3b447()
		elseif var3 < 140.0 and var3 >= 85.0 then
			helper_2b3d84b9()
		else
			helper_7274c7ab()
		end
		vm.wait()
	end
end

return helper_4e8d4c3a
