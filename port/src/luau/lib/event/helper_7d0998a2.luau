--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")

--- Helper function.
local function helper_7d0998a2(arg0: s32, arg1: s32)
	local var2: f32 = 0
	local var3: s32 = 0
	event.apply_message_window_preset(0, 0)
	helper_c8484b43(arg0, 0, 0)
	var2 = vm.bits_float(event.get_menu_value(2, 322)) or var2
	if var2 <= 0 then
		event.open_message_window_2(
			0,
			"H[UNI00e9], je parie que tu n'as jamais\nattrap[UNI00e9] un Nonky ?<page>Ah ah. Tu dois [UNI00ea]tre vraiment\nnul en p[UNI00ea]che !"
		)
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	if var2 < vm.f32(0.6) then
		var3 = vm.ftoi(vm.f32(var2 * 100.0))
		event.set_message_number(0, 1, var3)
		event.open_message_window_2(0, "Ah ah ! Tu n'as attrap[UNI00e9] qu'un tout\npetit poisson de [数値１] cm !")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(0, "Tu ne m[UNI00e9]rites pas mon aide !<page>Tu ferais mieux de recommencer.")
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "...Oh, je t'avais sous-estim[UNI00e9].")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(
		0,
		"Un homme, [UNI00e7]a n'a qu'une parole.<page>Je vais [UNI00e9]couter ce que t'as [UNI00e0] dire."
	)
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.open_message_window_2(0, "Parle autant que tu veux !")
	helper_0ffc2526(0, -1, arg0, arg1, 0)
	event.set_character_motion(arg0, "立ち")
	helper_9cc4383b()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

return helper_7d0998a2
