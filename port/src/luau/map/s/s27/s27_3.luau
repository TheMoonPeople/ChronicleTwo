--!strict
-- map/s/s27/s27_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_024677a1 = require("@lib/event/helper_024677a1")
local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_249b75d1 = require("@lib/event/helper_249b75d1")
local helper_31bb617a = require("@lib/event/helper_31bb617a")
local helper_33ff74db = require("@lib/event/helper_33ff74db")
local helper_4e93f9fc = require("@lib/event/helper_4e93f9fc")
local helper_5673b458 = require("@lib/event/helper_5673b458")
local helper_5fb66cb1 = require("@lib/event/helper_5fb66cb1")
local helper_790d496b = require("@lib/event/helper_790d496b")
local helper_7ccafde4 = require("@lib/event/helper_7ccafde4")
local helper_87196c31 = require("@lib/event/helper_87196c31")
local helper_c292fa16 = require("@lib/event/helper_c292fa16")
local helper_dfed0a42 = require("@lib/event/helper_dfed0a42")
local helper_e84b4994 = require("@lib/event/helper_e84b4994")
local helper_f5363207 = require("@lib/event/helper_f5363207")
local show_message = require("@lib/event/show_message")
local wait_frames = require("@lib/event/wait_frames")
local wait_frames_skipping = require("@lib/event/wait_frames_skipping")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	helper_31bb617a()
end

--- Helper function.
local function helper_146c0(arg0: s32)
	local flag: s32 = 0
	local var2: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local argc: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	flag = event.get_save_flag(444) or flag
	if flag == 0 then
		var2 = 0
		flag_2 = event.get_save_flag(420) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(0, "Kannst du jem. im Mondlabor\nnach dem Ger[UNI00e4]t auf dem\nKopf von Shingala fragen?")
		else
			flag_3 = event.get_save_flag(438) or flag_3
			if flag_3 == 0 then
				argc = event.get_owned_item_count(375) or argc
				if argc >= 1 then
					event.open_message_window_2(0, "Beeil dich und gib diese\nMedizin Shingala!")
					var2 = 1
				else
					event.open_message_window_2(
						0,
						"Du musst an den Strand, wo die\nanderen Shigura sind, um Medizin\nf[UNI00fc]r Shingala zu besorgen."
					)
				end
			else
				event.open_message_window_2(0, "Bitte! Du musst das\nShigura-Dorf retten!")
			end
		end
		helper_87196c31(arg0, var2)
	else
		event.open_message_window_2(
			0,
			"Shingala fehlt mir, aber\nich bin schon gespannt, wie\nviel er n[UNI00e4]chstes Jahr gewachsen ist."
		)
		helper_87196c31(arg0, 0)
	end
end

--- Helper function.
local function helper_14cac()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	if var0 == 9 then
		helper_146c0(var1)
	end
end

--- Helper function.
local function helper_112a8()
	local var0: s32 = 0
	local player_chara: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	helper_4e93f9fc(var0, 0, 0)
	player_chara = event.get_player_character_slot() or player_chara
	event.open_message_window_2(0, "Oh, ihr seid's!\nDanke f[UNI00fc]r die Hilfe mit Shingala.\nUnd, was gibt's?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Wie? Ich soll mitkommen?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Nein! Niemals!<page>Ich muss hier auf\nShingala warten.")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Aber es dauert bestimmt ein halbes\nJahr, bis die Shigura\nwiederkommen ...")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Bis dann h[UNI00e4]nge ich nur rum,\nda kann ich auch mitkommen.")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Hierbleiben bringt nichts.\nDa verschwende ich nur Zeit.")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Oh ja! Du bist ein Mensch,\ndann wei[UNI00df]t du bestimmt Bescheid!")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Dieses leckere Essen,\nwie hei[UNI00df]t es noch?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(
		0,
		"Komm schon, du wei[UNI00df]t es!\nEs ist orange und ungef[UNI00e4]hr\nso gro[UNI00df] wie ein Fisch.<page>Jedenfalls ist es orange\nund unheimlich lecker."
	)
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Das h[UNI00e4]tte ich echt gern mal wieder.\nHolst du mir eins?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.set_character_motion(var0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pau hat gro[UNI00df]e Ohren und Nagez[UNI00e4]hne,\n   wie gewisse andere Tiere.\n   Ein orangenes Essen f[UNI00fc]r ihn ..."
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 5, 1)
end

--- Helper function.
local function helper_11e38()
	local var0: s32 = 0
	local var1: s32 = 0
	local player_chara: s32 = 0
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	event.apply_message_window_preset(0, 0)
	helper_4e93f9fc(var1, 0, 0)
	player_chara = event.get_player_character_slot() or player_chara
	event.open_message_window_2(0, "Oh! Hast du eins f[UNI00fc]r mich?\nSo ein orangenes Essen ...")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_use_item_menu(315)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(var1, "立ち")
		event.finish_event()
		return
	end
	if item ~= 315 then
		event.open_message_window_2(0, "Komm schon! [UNI00c4]rger mich nicht!\nDas ist es nicht!")
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ah ... das ist es!<page>Die Farbe, der Duft,\nund so knackig ...")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Menschen sind doch nicht\nso schlecht.<page>Na gut, abgemacht.\nIch komme mit.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Ich hatte schon so eine Ahnung,\ndass die Welt in Gefahr ist.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Als Shingala hier war, erfuhr ich, dass\nein gewisser Griffon [UNI00c4]rger macht.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Ihn suchst du bestimmt.\nDann helfe ich gern.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Ich helfe [UNI00fc]brigens nicht nur\nwegen der Karotte.\nBitte denk das nicht.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.set_character_motion(var1, "立ち")
	event.set_npc_party_status(var0, 130)
	helper_024677a1(var0)
	event.finish_event()
	event.set_quest_request(1, 5, 1)
end

--- Helper function.
local function helper_128b8()
	local var0: s32 = 0
	local var1: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_chapter() or var1
	if var1 ~= 8 then
		event.open_message_window_2(0, "Aber falls du noch mehr Karotten\nfindest, wei[UNI00df]t du ja, wo ich bin!")
	else
		event.open_message_window_2(0, "Hey, wie l[UNI00e4]uft's?\nBei mir l[UNI00e4]uft's super!")
	end
	helper_1c04a0eb(var0, -1, 0, 0)
end

--- Helper function.
local function helper_12b30()
	local var0: s32 = 0
	var0 = event.get_quest_request_status(0, 5) or var0
	if var0 == 0 then
		helper_112a8()
		return
	end
	if var0 == 1 then
		helper_11e38()
		return
	end
	if var0 == 2 then
		helper_128b8()
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local old_map_no: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event_99()
		old_map_no = event.get_previous_map() or old_map_no
		if old_map_no == 2 then
			flag = event.get_save_flag(404) or flag
			if flag == 0 then
				at = 1
				helper_f5363207()
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g03", 500)
			else
				at = 2
				helper_790d496b()
			end
		elseif old_map_no == 84 then
			flag_2 = event.get_save_flag(408) or flag_2
			if flag_2 == 0 then
				at = 3
				helper_33ff74db()
			else
				at = 4
				helper_7ccafde4()
			end
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at <= 1 then
				helper_dfed0a42()
			end
			if at <= 2 then
				at = 3
				helper_33ff74db()
				return vm.continue_with(function()
					return
				end)
			end
			if at <= 3 then
				at = 4
				helper_7ccafde4()
				return vm.continue_with(function()
					return
				end)
			end
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_5673b458

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	if helper_e84b4994() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local argc: s32 = 0
	local var1: s32 = 0
	local item: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var8: f32 = 0
	local yaw: f32 = 0
	local var11: s32 = 0
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.initialize_event()
		argc = event.get_owned_item_count(375) or argc
		if argc >= 1 then
			event.set_character_motion(0, "立ち")
			var1 = event.get_triggered_event_data_2(6) or var1
			if var1 == 1 then
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "Der verletzte Shingala hat Schmerzen.\nMit (#) Men[UNI00fc] [UNI00f6]ffnen.")
				at = 1
				var3 = helper_c292fa16(0, -1, 5, 256, 208, var3)
				if var3 == 1 then
					var1 = 2
				end
			end
			if var1 == 2 then
				event.open_use_item_menu(375)
				at = 2
				vm.wait(2)
				item = vmhost.used_item() or item
				if item > 0 then
					if item == 375 then
						at = 3
						helper_5673b458()
						event.jump_to_map_3(-1, "s40", 500)
						at = 4
						vm.wait(4)
						return
					else
						at = 5
						helper_5fb66cb1()
					end
				end
			end
		else
			event.attach_object_handle_to_character(0, 0)
			event.clear_object_sequence(0)
			event.set_object_sequence_object(0, 0)
			event.attach_object_handle_to_character(1, 9)
			event.clear_object_sequence(1)
			event.set_object_sequence_object(1, 1)
			do
				local out1, out2, out3 = event.get_character_position(0)
				var4 = out1 or var4
				var5 = out2 or var5
				var6 = out3 or var6
			end
			do
				local _, out2, _ = event.get_character_rotation(0)
				var8 = out2 or var8
			end
			yaw = event.get_direction_angle(var4, var5, var6, -76.0, 0.0, 23.0) or yaw
			var11 = event.compare_angles(var8, yaw, 0.1) or var11
			if var11 ~= 0 then
				event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
				event.set_object_sequence_motion(0, "歩き")
				event.delay_object_sequence_motion_track(0, 10)
			end
			event.set_object_sequence_motion(0, "立ち")
			at = 6
			wait_frames(20)
			event.set_message_window_mode(0, 1)
			event.set_mouth_motions(1, "鳴く", 0, "座り", 0)
			flag = event.get_save_flag(438) or flag
			if flag == 0 then
				event.open_message_window_2(0, "Riiiiiiiiiiah!")
			else
				event.open_message_window_2(0, "Raaaa-oh!")
			end
			at = 7
			helper_0ffc2526(0, -1, 9, 0, 0)
		end
		return
	end, function(received: { any })
		if at <= 4 then
			if at == 1 then
				var3 = received[2] :: number
			end
			if at <= 1 then
				local _ = var1 == 1
				var1 = 2
			end
			if at <= 2 then
				at = 3
				helper_5673b458()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s40", 500)
					at = 4
					vm.wait(4)
					return
				end)
			end
			return 0
		end
		if at <= 7 then
			if at <= 5 then
				wait_frames_skipping(20)
			end
			if at <= 6 then
				helper_249b75d1(0, -1, 9, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event_99()
	helper_33ff74db()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local flag: s32 = 0
	local var1: s32 = 0
	flag = event.get_save_flag(500) or flag
	if flag == 0 then
		helper_14cac()
	else
		var1 = event.get_triggered_event_data_2(13) or var1
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, var1)
		helper_12b30()
		event.set_villager_ai_enabled(1, var1)
	end
end

--- Event 14040, which map data, a script or the engine runs by number.
function script.event_14040()
	event.set_save_flag(408, 0)
	event.set_save_flag(420, 0)
	event.set_save_flag(444, 0)
	event_99()
	helper_f5363207()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g03", 500)
end

--- Event 14380, which map data, a script or the engine runs by number.
function script.event_14380()
	event.set_save_flag(408, 1)
	event.set_save_flag(420, 1)
	event.set_save_flag(444, 0)
	event_99()
	helper_5673b458()
	event.jump_to_map_3(-1, "s40", 500)
	vm.wait(2)
end

return script
