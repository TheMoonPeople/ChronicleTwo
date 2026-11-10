--!strict
-- Shared effect helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8fa274d5(arg0: s32, arg1: f32, arg2: f32, arg3: f32, arg4: f32, range: f32)
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local value: f32 = 0
	local value_2: f32 = 0
	local value_3: f32 = 0
	local value_4: f32 = 0
	local value_5: f32 = 0
	value_2 = effect.get_random_number(range) or value_2
	value_3 = effect.get_random_number(360.0) or value_3
	value_4 = effect.get_random_number(0.01) or value_4
	value_5 = effect.get_random_number(1.25) or value_5
	value_5 = vm.f32(value_5 + 2.0)
	value_3 = vm.f32(vm.f32(value_3 / 180.0) * vm.f32(3.1415927))
	value_4 = vm.f32(value_4 + vm.f32(0.024543693))
	var6 = vm.f32(arg1 + vm.f32(vm.sin(value_3) * value_2))
	var7 = arg2
	var8 = vm.f32(arg3 + vm.f32(vm.cos(value_3) * value_2))
	var12 = vm.f32(vm.f32(0.8) * vm.sin(arg4))
	var13 = value_5
	var14 = vm.f32(vm.f32(0.8) * vm.cos(arg4))
	effect.set_sprite_visible(arg0, 1)
	effect.set_sprite_position(arg0, var6, var7, var8)
	effect.set_sprite_color(arg0, 128.0, 128.0, 128.0, 0.0)
	effect.set_sprite_scale(arg0, 1.0, 1.0)
	effect.set_sprite_velocity(arg0, var12, var13, var14)
	value = effect.get_random_number(3.0) or value
	effect.set_sprite_color_velocity(arg0, 0.0, 0.0, 0.0, value + 3.0)
	effect.set_sprite_angular_velocity(arg0, value_4)
	effect.set_sprite_scale_velocity(arg0, 0.01, 0.01)
end

return helper_8fa274d5
