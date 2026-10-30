--!strict
-- Shared event helper used by 19 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_9cc4383b = require("@lib/event/helper_9cc4383b")
local helper_be16759c = require("@lib/event/helper_be16759c")
local helper_c8484b43 = require("@lib/event/helper_c8484b43")
local helper_dc8bbe30 = require("@lib/event/helper_dc8bbe30")

--- Helper function.
local function helper_b45daec0(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		at = 1
		helper_c8484b43(arg0, 0, 0)
		var2 = event.get_menu_value_2(0) or var2
		var3 = event.get_save_counter(19) or var3
		print("start=", var3, ",now=", var2, ",clear=", vm.i32(var2 - var3), "\n")
		if vm.i32(var2 - var3) < 10 then
			event.open_message_window_2(0, "Todav[UNI00ed]a no me siento demasiado bien.")
			at = 2
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.open_message_window_2(
				0,
				"A lo mejor es\nque me pasa algo de verdad.<page>Quiz[UNI00e1] ni siquiera\nel Dr. Dell pueda ayudarme..."
			)
			at = 3
			helper_0ffc2526(0, -1, arg0, arg1, 0)
			event.set_character_motion(arg0, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "[UNI00a1]Hola!<page>[UNI00bf]Que c[UNI00f3]mo me siento? [UNI00a1]Como nunca!")
		at = 4
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"No me creo lo bien que me encuentro estos d[UNI00ed]as.<page>El mundo vuelve a estar como antes."
		)
		at = 5
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.open_message_window_2(
			0,
			"Ah, s[UNI00ed], me hab[UNI00ed]as pedido un favor.<page>Te ayudar[UNI00e9] en lo que pueda.<page>T[UNI00fa] me has ayudado,\nas[UNI00ed] que te debo una."
		)
		at = 6
		helper_0ffc2526(0, -1, arg0, arg1, 0)
		event.set_character_motion(arg0, "立ち")
		at = 7
		helper_9cc4383b()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				print("start=", var3, ",now=", var2, ",clear=", var2 - var3, "\n")
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 2 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			return 0
		end
		if at <= 7 then
			if at <= 4 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 5 then
				helper_be16759c(0, -1, arg0, arg1, 0)
			end
			if at <= 6 then
				helper_dc8bbe30()
			end
			return 0
		end
		return nil
	end)
end

return helper_b45daec0
