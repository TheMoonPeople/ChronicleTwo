--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2bcf81b0 = require("@lib/event/helper_2bcf81b0")
local show_message = require("@lib/event/show_message")

--- Helper function.
local function helper_c15328c3(arg0: s32)
	local flag: s32 = 0
	flag = event.get_save_flag(612) or flag
	if flag == 0 then
		return
	end
	event.set_message_window_mode(0, 12)
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_color(0, 255, 255, 255, 255)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(20, 0)
	event.clear_object_sequence(20)
	event.set_object_sequence_object(20, 20)
	event.set_event_sprite_draw_pass(0, 1)
	event.fade_in_screen(0)
	vm.wait(1)
	if arg0 ~= 0 then
		event.open_message_window_2(
			0,
			"On a [UNI00e9]t[UNI00e9] propuls[UNI00e9]s dans le futur\npar la machine temporelle d'Ixion."
		)
	else
		event.open_message_window_2(
			0,
			"On a r[UNI00e9]int[UNI00e9]gr[UNI00e9] le pr[UNI00e9]sent gr[UNI00e2]ce [UNI00e0]\nla machine temporelle d'Ixion."
		)
	end
	vm.wait(2)
	show_message(0, -1, 5, 0, 0)
	vm.wait(4)
	event.fade_out_screen(0, 255.0, 255.0, 255.0)
	vm.wait(5)
	helper_2bcf81b0()
end

return helper_c15328c3
