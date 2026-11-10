--!strict
-- Shared event helper used by 71 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_1ebb0be6(lid_open: f32)
	local var1: s32 = 0
	local var2: f32 = 0
	local at: number = 0
	return vm.guard(function()
		var1 = 0
		while var1 < 10 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + vm.f32(0.18))
			var1 = var1 + 1
			at = 1
			vm.wait(1)
		end
		var1 = 0
		var2 = vm.f32(0.06)
		while var1 <= 6 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open - var2)
			var2 = vm.f32(var2 - vm.f32(0.008))
			var1 = var1 + 1
			at = 2
			vm.wait(2)
		end
		var1 = 0
		var2 = vm.f32(0.005)
		while var1 <= 8 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
			at = 3
			vm.wait(3)
		end
		var1 = 0
		var2 = vm.f32(0.03)
		while var1 <= 6 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open - var2)
			var2 = vm.f32(var2 - vm.f32(0.005))
			var1 = var1 + 1
			at = 4
			vm.wait(4)
		end
		var1 = 0
		var2 = vm.f32(0.01)
		while var1 <= 4 do
			event.set_nearest_treasure_box_lid_open(lid_open)
			lid_open = vm.f32(lid_open + var2)
			var2 = vm.f32(var2 + vm.f32(0.01))
			var1 = var1 + 1
			at = 5
			vm.wait(5)
		end
		return lid_open
	end, function(received: { any })
		if at <= 5 then
			if at <= 1 then
				var1 = 0
				var2 = vm.f32(0.06)
				lid_open = vm.f32(lid_open - var2)
				var2 = vm.f32(var2 - vm.f32(0.008))
				local _ = var1 <= 6
				var1 = var1 + 1
			end
			if at <= 2 then
				var1 = 0
				var2 = vm.f32(0.005)
				lid_open = vm.f32(lid_open + var2)
				var2 = vm.f32(var2 + vm.f32(0.01))
				local _ = var1 <= 8
				var1 = var1 + 1
			end
			if at <= 3 then
				var1 = 0
				var2 = vm.f32(0.03)
				lid_open = vm.f32(lid_open - var2)
				var2 = vm.f32(var2 - vm.f32(0.005))
				local _ = var1 <= 6
				var1 = var1 + 1
			end
			if at <= 4 then
				var1 = 0
				var2 = vm.f32(0.01)
				lid_open = vm.f32(lid_open + var2)
				var2 = vm.f32(var2 + vm.f32(0.01))
				local _ = var1 <= 4
				var1 = var1 + 1
			end
			return 0, lid_open
		end
		return nil, lid_open
	end)
end

return helper_1ebb0be6
