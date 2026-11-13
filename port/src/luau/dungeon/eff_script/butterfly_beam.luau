--!strict
--- Draws a beam of scale-dust sprites between two points and fades it out when finished.

local vm = require("@lib/vm")

local script = {}

--- Does nothing; the effect needs no load-time setup.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing; the engine never runs this program.
function script.init() end

--- Spreads a line of sprites between the two work positions every frame.
function script.on_start()
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_y: f32 = 0
	local end_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	effect.set_sprite_texture("nana_rinpun")
	effect.allocate_sprites_1(600)
	effect.reset_sprites(0, 600)
	effect.set_sprite_blend_mode(0, 2, 600)
	effect.set_sprite_visible(0, 1, 600)
	effect.set_sprite_position(0, 0.0, -1000.0, 0.0, 600)
	effect.set_sprite_size(0, 4.0, 4.0, 600)
	effect.set_sprite_texture_rect(0, 129.0, 1.0, 126.0, 126.0, 600)
	while true do
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		do
			local out1, out2, out3 = effect.get_second_work_vector()
			end_x = out1 or end_x
			end_y = out2 or end_y
			end_z = out3 or end_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(end_x, end_y, end_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, start_x, start_y, start_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 600.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		effect.spread_sprite_positions(0, start_x, start_y, start_z, step_x, step_y, step_z, 0.0, 0.0, 0.0, 600)
		vm.wait()
	end
end

--- Keeps drawing the beam while fading its sprites out.
function script.on_finish()
	local start_x: f32 = 0
	local start_y: f32 = 0
	local start_z: f32 = 0
	local end_x: f32 = 0
	local end_y: f32 = 0
	local end_z: f32 = 0
	local step_x: f32 = 0
	local step_y: f32 = 0
	local step_z: f32 = 0
	local color_red: f32 = 0
	local color_green: f32 = 0
	local color_blue: f32 = 0
	local alpha: f32 = 0
	color_red = 128.0
	color_green = 128.0
	color_blue = 128.0
	alpha = 128.0
	while true do
		do
			local out1, out2, out3 = effect.get_first_work_vector()
			start_x = out1 or start_x
			start_y = out2 or start_y
			start_z = out3 or start_z
		end
		do
			local out1, out2, out3 = effect.get_second_work_vector()
			end_x = out1 or end_x
			end_y = out2 or end_y
			end_z = out3 or end_z
		end
		do
			local out1, out2, out3 = effect.copy_vector(end_x, end_y, end_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.subtract_vectors(step_x, step_y, step_z, start_x, start_y, start_z)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		do
			local out1, out2, out3 = effect.divide_vector(step_x, step_y, step_z, 600.0)
			step_x = out1 or step_x
			step_y = out2 or step_y
			step_z = out3 or step_z
		end
		effect.spread_sprite_positions(0, start_x, start_y, start_z, step_x, step_y, step_z, 0.0, 0.0, 0.0, 600)
		effect.set_sprite_color(0, color_red, color_green, color_blue, alpha, 600)
		alpha = vm.f32(alpha - 4.0)
		if alpha <= 0.0 then
			break
		else
			vm.wait()
		end
	end
end

return script
