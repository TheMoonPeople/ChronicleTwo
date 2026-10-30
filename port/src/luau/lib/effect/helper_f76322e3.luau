--!strict
-- Shared effect helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f76322e3(arg0: s32, range: f32, arg2: f32, arg3: f32, arg4: f32)
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	local value_6: f32 = 0
	value_5 = effect.get_random_number(150.0) or value_5
	value_5 = vm.f32(value_5 / 100.0)
	value_5 = vm.f32(value_5 + 2.0)
	value_4 = effect.get_random_number(6.0) or value_4
	value_4 = vm.f32(value_4 + 1.0)
	value_4 = vm.f32(value_4 * 2.0)
	value = 1.0
	value_2 = 1.0
	value_3 = 1.0
	value = effect.get_random_number(360.0) or value
	value_2 = effect.get_random_number(range) or value_2
	value_3 = effect.get_random_number(8.0) or value_3
	value = vm.f32(vm.f32(value / 180.0) * vm.f32(3.1415927))
	x = vm.f32(vm.sin(value) * value_2)
	y = 0.0
	z = vm.f32(vm.cos(value) * value_2)
	var5 = vm.f32(arg2 + x)
	var6 = vm.f32(vm.f32(arg3 - value_3) + 4.0)
	var7 = vm.f32(arg4 + z)
	do
		local out1, out2, out3 = effect.normalize_vector(x, y, z)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	do
		local out1, out2, out3 = effect.scale_vector(x, y, z, 1.2)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	effect.set_sprite_position(arg0, var5, var6, var7)
	effect.set_sprite_color(arg0, 128.0, 128.0, 128.0, 128.0)
	effect.set_sprite_visible(arg0, 1)
	effect.set_sprite_scale(arg0, value_4, value_4)
	value_6 = effect.get_random_number(4.0) or value_6
	value_6 = vm.f32(value_6 + 1.0)
	effect.set_sprite_velocity(arg0, x, value_6, z)
	effect.set_sprite_color_velocity(arg0, 0.0, 0.0, 0.0, -2.0)
end

return helper_f76322e3
