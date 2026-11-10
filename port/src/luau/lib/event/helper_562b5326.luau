--!strict
-- Shared event helper used by 66 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_562b5326(lid_open: f32)
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = 0
		lid_open = vm.f32(0.04)
		while var1 <= 10 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + vm.f32(0.13))
			var1 = var1 + 1
			at = 1
			vm.wait(1)
		end
		return lid_open
	end, function(received: { any })
		if at <= 1 then
			return 0, lid_open
		end
		return nil, lid_open
	end)
end

return helper_562b5326
