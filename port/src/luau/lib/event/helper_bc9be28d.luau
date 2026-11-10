--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_c137370d = require("@lib/event/helper_c137370d")

--- Helper function.
local function helper_bc9be28d()
	local var0: s32 = 0
	local omake_flag: s32 = 0
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_character_motion_pack(4, "event/e00/e70/e70_mints.gltf", "info", 0)
	event.load_character(4, "chara/p01_28a.gltf", "info", 24)
	helper_c137370d(24, 156, vm.f32(100.41), vm.f32(23.15), vm.f32(-396.44), vm.f32(0.4))
	event.load_character(4, "event/e00/e70/cup.gltf", "info", 8)
	event.set_character_active(0, 8)
	var0 = event.get_chapter() or var0
	omake_flag = event.is_extra_mode() or omake_flag
	if omake_flag == 0 then
		helper_c137370d(25, 161, -105.0, 0.0, -340.0, vm.f32(-2.81))
	else
		helper_c137370d(25, 171, -105.0, 0.0, -340.0, vm.f32(-2.81))
	end
	if omake_flag ~= 0 or var0 < 6 then
		helper_c137370d(26, 169, -432.0, 0.0, 25.0, vm.f32(-1.4))
	else
		helper_c137370d(26, 167, -432.0, 0.0, 25.0, vm.f32(-1.4))
	end
	if omake_flag == 0 then
		if var0 < 6 then
			helper_c137370d(27, 166, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
		else
			helper_c137370d(27, 165, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
		end
	else
		helper_c137370d(27, 160, vm.f32(-206.4), 0.0, vm.f32(100.9), vm.f32(1.8))
	end
	if omake_flag ~= 0 or var0 < 6 then
		helper_c137370d(28, 172, -199.5, 0.0, vm.f32(126.9), vm.f32(1.63))
	else
		helper_c137370d(28, 158, 430.0, 0.0, vm.f32(1.2), vm.f32(1.49))
	end
	if omake_flag == 0 then
		helper_c137370d(29, 159, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	else
		helper_c137370d(29, 162, vm.f32(48.9), 0.0, vm.f32(376.2), vm.f32(3.11))
	end
	helper_c137370d(30, 168, vm.f32(214.9), 0.0, vm.f32(-103.6), vm.f32(-1.15))
end

return helper_bc9be28d
