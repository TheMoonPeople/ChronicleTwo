--!strict
--- Holds the Japanese spheda event helpers.

local vm = require("@lib/vm")
local message = vm.module("@lib/event/message")
local wait = vm.module("@lib/event/wait")

local spheda = {}

--- Announces the floor practice result messages and the medals awarded for it.
function spheda.announce_medal_reward(is_new_record: s32, practice_result: s32, bonus_index: s32)
	local record_sound_id: s32 = 0
	local medal_sound_id: s32 = 0
	local reward_sound_id: s32 = 0
	event.set_message_window_mode(0, 4)
	event.set_message_draw_speed(0, 1)
	if is_new_record == 1 or is_new_record == 2 then
		message.show_and_wait(0, 2750, 8, 0, 0)
	end
	if is_new_record == 1 and practice_result ~= 2 then
		record_sound_id = event.get_system_sound_id() or record_sound_id
		event.play_sound_effect(record_sound_id, 18)
		message.show_and_wait(0, 2760, 8, 0, 0)
	end
	if practice_result == 2 or practice_result == 3 then
		message.show_and_wait(0, vm.i32(2700 + bonus_index), 8, 0, 0)
	end
	if is_new_record == 1 and practice_result == 2 then
		medal_sound_id = event.get_system_sound_id() or medal_sound_id
		event.play_sound_effect(medal_sound_id, 18)
		event.open_message_window_2(0, "メダル２個入手！！")
		message.show_and_wait(0, -1, 8, 0, 0)
	elseif practice_result == 2 then
		reward_sound_id = event.get_system_sound_id() or reward_sound_id
		event.play_sound_effect(reward_sound_id, 18)
		message.show_and_wait(0, 2760, 8, 0, 0)
	end
end

--- Shows the Spheda hole score sprites and waits until the player dismisses them.
function spheda.show_hole_score()
	local texture_bank: s32 = 0
	local score: s32 = 0
	vm.wait(1)
	score = event.get_sphida_hole_score(-1) or score
	texture_bank = event.get_sphida_texture_bank() or texture_bank
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "omake_sfida", texture_bank)
	event.set_event_sprite_texture_rect(0, 0, 38, 182, 34)
	event.set_event_sprite_position(0, 256, 192)
	event.set_event_sprite_size(0, 182, 34)
	event.set_event_sprite_color(0, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(0, 1)
	event.reset_event_sprite(1)
	event.set_event_sprite_draw_pass(1, 0)
	event.reset_event_sprite(2)
	event.set_event_sprite_type(2, 0)
	event.set_event_sprite_texture(2, "omake_sfida", texture_bank)
	event.set_event_sprite_texture_rect(2, 126, 0, 114, 38)
	event.set_event_sprite_position(2, 276, 224)
	event.set_event_sprite_size(2, 114, 38)
	event.set_event_sprite_color(2, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(2, 1)
	event.reset_event_sprite(3)
	event.set_event_sprite_type(3, 0)
	event.set_event_sprite_texture(3, "omake_sfida", texture_bank)
	event.set_event_sprite_texture_rect(3, vm.i32(vm.imod(score, 10) * 28), 96, 28, 32)
	event.set_event_sprite_position(3, 208, 224)
	event.set_event_sprite_size(3, 28, 32)
	event.set_event_sprite_color(3, 128, 128, 128, 128)
	event.set_event_sprite_draw_pass(3, 1)
	if vm.idiv(score, 10) > 0 then
		event.reset_event_sprite(4)
		event.set_event_sprite_type(4, 0)
		event.set_event_sprite_texture(4, "omake_sfida", texture_bank)
		event.set_event_sprite_texture_rect(4, vm.i32(vm.idiv(score, 10) * 28), 96, 28, 32)
		event.set_event_sprite_position(4, 184, 224)
		event.set_event_sprite_size(4, 28, 32)
		event.set_event_sprite_color(4, 128, 128, 128, 128)
		event.set_event_sprite_draw_pass(4, 1)
	end
	while true do
		if wait.get_button_state(0) ~= 0 then
			break
		else
			vm.wait(2)
		end
	end
end

return spheda
