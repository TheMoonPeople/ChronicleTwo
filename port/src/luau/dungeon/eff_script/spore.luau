--!strict
-- dungeon/eff_script/spore.stb: effect script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

local script = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
function script.init() end

--- Runs the effect from the frame it is created.
function script.on_start()
	local var0: s32 = 0
	local angle: f32 = 0
	local var2: f32 = 0
	local value: f32 = 0
	local var4: f32 = 0
	local value_2: f32 = 0
	local color_delta_4: f32 = 0
	local value_3: f32 = 0
	local color_w: f32 = 0
	effect.allocate_sprites_1(50)
	effect.set_sprite_texture("b02maphousi01")
	effect.reset_sprites(0, 50)
	effect.set_sprite_blend_mode(0, 2, 50)
	effect.set_sprite_visible(0, 1, 50)
	effect.set_sprite_texture_rect(0, 64.0, 0.0, 64.0, 64.0, 50)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 0.0, 50)
	var0 = 0
	angle = 0.0
	while var0 < 50 do
		effect.set_sprite_size(var0, 60.0, 60.0)
		var2 = vm.f32(vm.sin(angle) * 120.0)
		value = effect.get_random_number(50.0) or value
		value = vm.f32(value + 790.0)
		var4 = vm.f32(vm.cos(angle) * 120.0)
		angle = vm.f32(angle + vm.f32(0.25120002))
		angle = effect.wrap_angle(angle) or angle
		effect.set_sprite_position(var0, var2 + 268.0, value, var4 - 322.0)
		value_2 = effect.get_random_number(360.0) or value_2
		value_2 = vm.f32(vm.f32(vm.f32(value_2 / 180.0) * vm.f32(3.1415927)) - vm.f32(3.1415927))
		effect.set_sprite_rotation(var0, value_2)
		var0 = var0 + 1
	end
	color_delta_4 = 1.0
	var0 = 0
	while var0 < 160 do
		value_3 = effect.get_random_number(0.04) or value_3
		effect.offset_sprite_rotation(0, value_3, 25)
		value_3 = effect.get_random_number(0.04) or value_3
		effect.offset_sprite_rotation(25, -value_3, 25)
		effect.offset_sprite_color(0, 0.0, 0.0, 0.0, color_delta_4, 50)
		do
			local _, _, _, out4 = effect.get_sprite_color(0)
			color_w = out4 or color_w
		end
		if color_w > 80.0 then
			color_delta_4 = -color_delta_4
		end
		if vm.imod(var0, 12) == 0 then
			effect.create_effect_1("ラフレシア花粉サブ")
			effect.set_effect_first_work_vector(268.802, 758.472, -322.002)
		end
		var0 = var0 + 1
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
function script.on_finish() end

return script
