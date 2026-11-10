--!strict
-- map/s/s27/s27_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
local function helper_145f0(arg0: s32)
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
			event.open_message_window_2(0, "Chiederete al tipo del Lab-Lunatica\ndel congegno sul capo di Shingala?")
		else
			flag_3 = event.get_save_flag(438) or flag_3
			if flag_3 == 0 then
				argc = event.get_owned_item_count(375) or argc
				if argc >= 1 then
					event.open_message_window_2(0, "Sbrigatevi a dare quella medicina\na Shingala!")
					var2 = 1
				else
					event.open_message_window_2(
						0,
						"Andate alla spiaggia dove\nsono gli altri Shigura e\ntrovate una cura per Shingala!"
					)
				end
			else
				event.open_message_window_2(0, "Vi prego! Dovete salvare\nil villaggio Shigura!")
			end
		end
		helper_87196c31(arg0, var2)
	else
		event.open_message_window_2(0, "Mi manca Shingala e non vedo\nl'ora di vedere come sar[UNI00e0]\ncresciuto tra un anno.")
		helper_87196c31(arg0, 0)
	end
end

--- Helper function.
local function helper_14bbc()
	local var0: s32 = 0
	local var1: s32 = 0
	event.initialize_event()
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	if var0 == 9 then
		helper_145f0(var1)
	end
end

--- Helper function.
local function helper_111b8()
	local var0: s32 = 0
	local player_chara: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	helper_4e93f9fc(var0, 0, 0)
	player_chara = event.get_player_character_slot() or player_chara
	event.open_message_window_2(0, "Oh, siete voi, ragazzi! Grazie\nper avermi aiutato con Shingala.\nAllora, novit[UNI00e0]?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Cosa? Volete che venga con voi?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "No! Assolutamente!<page>Devo stare qui\nad aspettare Shingala.")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Ma ci vorranno minimo sei mesi\nprima che tornino gli Shigura!")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Non avr[UNI00f2] granch[UNI00e9] da fare fino ad\nallora. Credo di poter venire!")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Non ha alcun senso stare qui.\n[UNI00c8] solo una perdita di tempo.")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Ah gi[UNI00e0]! Siete Umani, quindi immagino lo sappiate!")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Quel cibo davvero delizioso...\nDai, come si chiama?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(
		0,
		"Dai, dovete saperlo! [UNI00c8] arancione\ne grande quasi come un pesce.<page>Allora: [UNI00e8] arancione e delizioso!"
	)
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.open_message_window_2(0, "Vorrei tanto poterla assaggiare\ndi nuovo. Me ne portereste una?")
	helper_0ffc2526(0, -1, var0, player_chara, 0)
	event.set_character_motion(var0, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pau ha lunghe orecchie e denti grandi,\n   proprio come un certo animale.\n   [UNI00c8] ghiotto di un cibo arancione!"
	)
	show_message(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 5, 1)
end

--- Helper function.
local function helper_11d48()
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
	event.open_message_window_2(0, "Oh! Me ne avete portata una?\nQuel cibo arancione...")
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
		event.open_message_window_2(0, "Dai! Non prendetemi in giro!\nNon [UNI00e8] questo!")
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ah... ecco, [UNI00e8] questo!<page>Il colore, l'odore,\nla consistenza...")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"Penso che stare con gli Umani\nnon sia poi cos[UNI00ec] male.<page>OK, affare fatto!\nVerr[UNI00f2] con voi."
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "In realt[UNI00e0], [UNI00e8] un po' che sospetto\nche il mondo sia in pericolo.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Con Shingala qui, ho saputo che un\ncerto Grifone tramava qualcosa.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(0, "Immagino che gli stiate dando la\ncaccia. Sar[UNI00f2] felice di aiutarvi.")
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.open_message_window_2(
		0,
		"Comunque, non vi sto aiutando solo\nperch[UNI00e9] mi avete dato una carota.\nNon pensatelo neanche!"
	)
	helper_0ffc2526(0, -1, var1, player_chara, 0)
	event.set_character_motion(var1, "立ち")
	event.set_npc_party_status(var0, 130)
	helper_024677a1(var0)
	event.finish_event()
	event.set_quest_request(1, 5, 1)
end

--- Helper function.
local function helper_12818()
	local var0: s32 = 0
	local var1: s32 = 0
	event.apply_message_window_preset(0, 0)
	var0 = event.get_triggered_event_data_2(13) or var0
	var1 = event.get_chapter() or var1
	if var1 ~= 8 then
		event.open_message_window_2(0, "Se vi capitassero a tiro altre\ncarote, sapete dove trovarmi!")
	else
		event.open_message_window_2(0, "Ehi, come va? Io sto d'incanto!")
	end
	helper_1c04a0eb(var0, -1, 0, 0)
end

--- Helper function.
local function helper_12a60()
	local var0: s32 = 0
	var0 = event.get_quest_request_status(0, 5) or var0
	if var0 == 0 then
		helper_111b8()
		return
	end
	if var0 == 1 then
		helper_11d48()
		return
	end
	if var0 == 2 then
		helper_12818()
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
				event.open_message_window_2(0, "Shingala [UNI00e8] ferito e soffre.\nPremi (#) per accedere al Menu.")
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
				event.open_message_window_2(0, "Reeeeeeah!")
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
		helper_14bbc()
	else
		var1 = event.get_triggered_event_data_2(13) or var1
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, var1)
		helper_12a60()
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
