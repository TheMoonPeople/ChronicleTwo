--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e14bd541 = require("@lib/event/helper_e14bd541")

--- Helper function.
local function helper_66f07360(arg0: any)
	local var1: s32 = 0
	local lid_open: f32 = 0
	local var3: s32 = 0
	local voice: s32 = 0
	var1 = 0
	lid_open = 0.0
	while var1 <= 5 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open + vm.f32(0.01))
		var1 = var1 + 1
		vm.wait(1)
	end
	voice = helper_e14bd541()
	var3 = event.get_sound_id(3) or var3
	event.play_sound_effect(var3, voice)
	var1 = 0
	while var1 <= 4 do
		event.set_nearest_treasure_box_lid_open(lid_open)
		lid_open = vm.f32(lid_open - vm.f32(0.004))
		var1 = var1 + 1
		vm.wait(2)
	end
end

return helper_66f07360
