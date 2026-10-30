--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bee0409d = require("@lib/monster/helper_bee0409d")

--- Helper function.
local function helper_067263da(arg0: f32, arg1: any)
	local var2: s32 = 0
	local arrived: s32 = 0
	local var4: f32 = 0
	var2 = 0
	while var2 < arg1 do
		arrived = monster.is_move_finished() or arrived
		var4 = monster.get_target_distance() or var4
		if var4 < arg0 then
			monster.stop_moving()
			return 1
		end
		if arrived == 0 then
			helper_bee0409d()
		else
			monster.stop_moving()
			return 2
		end
		if arrived == 1 then
			monster.stop_moving()
			return 1
		end
		var2 = vm.i32(var2 + 1)
	end
	return 0
end

return helper_067263da
