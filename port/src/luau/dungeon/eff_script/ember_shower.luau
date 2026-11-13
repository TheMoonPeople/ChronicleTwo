--!strict
--- Continuous shower of bouncing embers.

local vm = require("@lib/vm")
local particles = require("@lib/effect/particles")

local script = {}

--- Does nothing when the effect script is loaded.
function script.setup() end

--- Initialisation program that every effect script defines empty; the engine never runs it.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing because this effect needs no initialisation.
function script.init() end

--- Emits embers that fall and bounce on the ground until the effect is stopped.
function script.on_start()
	local emitter_x: f32 = 0
	local emitter_y: f32 = 0
	local emitter_z: f32 = 0
	local sprite_y: f32 = 0
	local sprite_alpha: f32 = 0
	local spawn_range: f32 = 0
	local sprites_allocated: s32 = 0
	local next_sprite_index: s32 = 0
	local stop_signal: s32 = 0
	local is_visible: s32 = 0
	do
		local out1, out2, out3 = effect.get_first_work_vector()
		emitter_x = out1 or emitter_x
		emitter_y = out2 or emitter_y
		emitter_z = out3 or emitter_z
	end
	sprites_allocated = effect.allocate_sprites_2(210) or sprites_allocated
	if sprites_allocated == 0 then
		return
	end
	effect.set_sprite_texture("hinoko")
	effect.reset_sprites(0, 210)
	effect.set_sprite_blend_mode(0, 2, 210)
	effect.set_sprite_texture_rect(0, 64.0, 0.0, 64.0, 64.0, 210)
	effect.set_sprite_size(0, 1.0, 1.0, 210)
	effect.set_sprite_color(0, 128.0, 128.0, 128.0, 128.0, 210)
	effect.set_sprite_visible(0, 0, 210)
	effect.set_sprite_position(0, 0.0, 0.0, 0.0, 210)
	effect.set_sprite_acceleration(0, 0.0, -0.3, 0.0, 210)
	effect.get_owner_character()
	next_sprite_index = 0
	while true do
		for index = 0, 209 do
			do
				local _, _, _, out4 = effect.get_sprite_color(index)
				sprite_alpha = out4 or sprite_alpha
			end
			if sprite_alpha <= 0.0 then
				effect.set_sprite_visible(index, 0)
			end
			is_visible = effect.is_sprite_visible(index) or is_visible
			if is_visible ~= 0 then
				do
					local _, out2, _ = effect.get_sprite_position(index)
					sprite_y = out2 or sprite_y
				end
				if sprite_y < 2.0 then
					is_visible = effect.get_script_value(1) or is_visible
					is_visible = 0
					if is_visible == 0 then
						sprite_y = vm.f32(sprite_y * vm.f32(-0.8))
						effect.set_sprite_velocity(index, 0.0, sprite_y, 0.0)
						effect.set_sprite_acceleration(index, 0.0, -0.3, 0.0)
					end
				end
			end
		end
		stop_signal = effect.get_script_value(2) or stop_signal
		if stop_signal ~= 1 then
			for i = 0, 1 do
				spawn_range = 20.0
				particles.spawn_spark(next_sprite_index, spawn_range, emitter_x, emitter_y, emitter_z)
				next_sprite_index = next_sprite_index + 1
				if next_sprite_index >= 210 then
					next_sprite_index = 0
				end
			end
		end
		vm.wait()
	end
end

--- Ends an effect.
-- Defined empty, so the engine runs this instead of its default.
--- Does nothing when the effect ends.
function script.on_finish() end

return script
