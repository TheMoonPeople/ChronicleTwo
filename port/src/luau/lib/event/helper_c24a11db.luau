--!strict
-- Shared event helper used by 35 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_581cb30c = require("@lib/event/helper_581cb30c")

--- Helper function.
local function helper_c24a11db()
	local language_code: s32 = 0
	local tex_bank: s32 = 0
	local var2: s32 = 0
	vm.wait(1)
	language_code = event.get_language() or language_code
	var2 = event.get_sphida_hole_score(-1) or var2
	tex_bank = event.get_sphida_texture_bank() or tex_bank
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "omake_sfida", tex_bank)
	event.set_event_sprite_position(0, 256, 192)
	if language_code == 3 then
		event.set_event_sprite_texture_rect(0, 0, 38, 162, 34)
		event.set_event_sprite_size(0, 162, 34)
	else
		event.set_event_sprite_texture_rect(0, 0, 38, 182, 34)
		event.set_event_sprite_size(0, 182, 34)
	end
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_draw_pass(1, 0)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "omake_sfida", tex_bank)
	event.set_event_sprite_texture_rect(2, 136, 0, 104, 38)
	event.set_event_sprite_position(2, 278, 224)
	event.set_event_sprite_size(2, 104, 38)
	event.set_event_sprite_color(2, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(2, 1)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "omake_sfida", tex_bank)
	event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(var2, 10) * 28), 96, 28, 32)
	event.set_event_sprite_position(3, 208, 224)
	event.set_event_sprite_size(3, 28, 32)
	event.set_event_sprite_color(3, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(3, 1)
	if vm.idiv(var2, 10) > 0 then
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "omake_sfida", tex_bank)
		event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(var2, 10) * 28), 96, 28, 32)
		event.set_event_sprite_position(4, 184, 224)
		event.set_event_sprite_size(4, 28, 32)
		event.set_event_sprite_color(4, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(4, 1)
	end
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(2)
		end
	end
end

return helper_c24a11db
