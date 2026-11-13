--!strict
--- Event script for the Golden Paint house interior, where Parn the magical artist asks for Golden Paint and brings Julia to life.

local vm = require("@lib/vm")
local cutscene = require("@lib/event/cutscene")
local i04_golden_paint_house = require("@lib/event/i04_golden_paint_house")
local inventory = require("@lib/event/inventory")
local message = require("@lib/event/message")
local npc_dialogue = require("@lib/event/spanish/npc_dialogue")
local object = require("@lib/event/object")
local party = require("@lib/event/party")
local villager_dialogue = require("@lib/event/spanish/villager_dialogue")
local wait = require("@lib/event/wait")

--- Plays the cutscene where Parn introduces Julia to Monica and tells the player to try again as Max.
local function play_parn_introduction_as_monica(npc_slot: s32, player_slot: s32)
	event.set_character_motion(player_slot, "立ち")
	event.fade_out_screen(30)
	wait.frames(30)
	event.initialize_event()
	event.apply_message_window_preset(0, 0)
	event.attach_object_handle_to_character(0, player_slot)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, npc_slot)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_object_sequence_position(0, 30.52, 0.2, -56.3)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	wait.frames(30)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "Hola.\n[UNI00bf]M[UNI00f3]nica, no?")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Soy Parn.\nSoy un artista m[UNI00e1]gico.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(30)
	event.open_message_window_2(0, "...")
	message.show(0, -1, 2, 341, 416)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]A M[UNI00f3]nica no se le dan muy bien\nestas situaciones. Podr[UNI00ed]a lograr algo,\npero es probable que no lo haga. Prueba m[UNI00e1]s tarde con Max."
	)
	message.show(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Plays the cutscene where Parn introduces Julia to Max and asks him to find Golden Paint.
local function play_parn_introduction_as_max(npc_slot: s32, player_slot: s32)
	event.set_character_motion(player_slot, "立ち")
	event.fade_out_screen(30)
	wait.frames(30)
	event.initialize_event()
	event.apply_message_window_preset(0, 0)
	event.attach_object_handle_to_character(0, player_slot)
	event.clear_object_sequence(0)
	event.set_object_sequence_object(0, 0)
	event.attach_object_handle_to_character(1, npc_slot)
	event.clear_object_sequence(1)
	event.set_object_sequence_object(1, 1)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_object_sequence_position(0, 30.52, 0.2, -56.3)
	event.set_object_sequence_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_object_sequence_motion(0, "立ち")
	event.reset_object_sequence_dynamic_animation(0)
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	wait.frames(30)
	event.open_message_window_2(0, "Hola, Max.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(0, "No os he presentado todav[UNI00ed]a, [UNI00bf]no?<page>Esta es Julia, mi futura mujer.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, 60.0, 0.0, -100.0, 30)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	wait.frames(30)
	event.open_message_window_2(0, "...")
	message.show(0, -1, 2, 341, 416)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"Puedes re[UNI00ed]rte lo que quieras.\nYa s[UNI00e9] que es raro.<page>[UNI00bf]Qui[UNI00e9]n se enamorar[UNI00ed]a de\nun retrato?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Pero soy un artista m[UNI00e1]gico.\nTengo el poder de convertir en realidad las cosas que pinto.<page>Todo lo que pinto existe en el cuadro verdaderamente.\nA menos que se trate de un ser vivo..."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Ni siquiera un artista m[UNI00e1]gico puede pintar vida.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.rotate_object_sequence(0, 0.0, 3.1415927, 0.0, 30)
	object.wait_until_done(0)
	event.set_object_sequence_motion(0, "立ち")
	event.open_message_window_2(
		0,
		"Aunque he o[UNI00ed]do que existe una forma.\nHay un Huevo dorado en un [UNI00e1]rbol grande y viejo."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(0, "Se cuenta que con el color dorado\nse puede dar vida a cualquier cosa que pintes.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.rotate_object_sequence(1, 0.0, 0.17, 0.0, 30)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "会話", 2)
	event.queue_object_sequence_next_motion(1, "立ち")
	event.open_message_window_2(
		0,
		"Max, tengo entendido que\nte marchas de la ciudad, [UNI00bf]no?<page>[UNI00bf]Podr[UNI00ed]as traerme algo de Pintura dorada?"
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"Por supuesto que no espero que lo hagas a cambio de nada.<page>Si me ayudas, usar[UNI00e9]\nmi nuevo poder para devolverte el favor."
	)
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Un [UNI00e1]rbol grande y viejo...\n [UNI00a1]Con un Huevo dorado! [UNI00bf]Y d[UNI00f3]nde se supone\nque hay algo as[UNI00ed]?"
	)
	message.show(0, -1, 8, 0, 0)
	event.fade_out_screen(30)
	wait.frames(30)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Plays the introduction cutscene for the active character and records the Golden Paint request when Max is playing.
local function start_golden_paint_request(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		play_parn_introduction_as_monica(npc_slot, player_slot)
		return
	end
	play_parn_introduction_as_max(npc_slot, player_slot)
	event.set_quest_request(0, 1, 1)
end

--- Shows the notice that Julia joined the party.
local function announce_julia_joined()
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	event.open_message_window_2(1, "Julia se ha unido a tu grupo.\nJulia ha subido al tren.")
	message.show(1, -1, 8, 0, 0)
end

--- Asks for the Golden Paint, and on delivery plays the cutscene that brings Julia to life and adds her to the party.
local function deliver_golden_paint(npc_slot: s32, player_slot: s32)
	local active_character: s32 = 0
	local item: s32 = 0
	local sound_handle: s32 = 0
	local parn_slot: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
		event.open_message_window_2(
			0,
			"Las chicas no deben de entender\npor qu[UNI00e9] los hombres necesitan\nperseguir sus ideales."
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk_with_camera_flag(npc_slot, 0, 0)
	event.open_message_window_2(0, "Te he estado esperando.<page>R[UNI00e1]pido, dame la Pintura para\ndar vida a mi cuadro.")
	message.say_bubble(0, -1, npc_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(5)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	if item ~= 376 then
		event.open_message_window_2(
			0,
			"[UNI00a1]Est[UNI00e1]s de broma!<page>Lo que necesito es Pintura dorada.\n[UNI00a1]No te equivoques!"
		)
		message.say_bubble(0, -1, npc_slot, player_slot, 0)
		event.set_character_motion(npc_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.initialize_event()
	event.fade_out_screen(30)
	wait.frames(30)
	event.load_map_sounds(2827)
	sound_handle = event.load_sound_effect_file_2(2827) or sound_handle
	parn_slot = event.find_scene_character_slot(5) or parn_slot
	event.set_villager_ai_enabled(0, parn_slot)
	event.attach_object_handle_to_character(1, parn_slot)
	event.clear_object_sequence(1, parn_slot)
	event.set_object_sequence_object(1, 1)
	event.assign_memory_stack(5)
	event.clear_memory_stack(5)
	event.load_character(5, "chara/p01_25a.gltf", "info", 32)
	event.set_character_active(0, 32)
	event.attach_object_handle_to_character(2, 32)
	event.clear_object_sequence(2, 32)
	event.set_object_sequence_object(2, 2)
	event.load_character(5, "event/e200/e255/e255_rafhikari.gltf", "info", 33)
	event.set_character_active(0, 33)
	event.attach_object_handle_to_character(3, 33)
	event.clear_object_sequence(3, 33)
	event.set_object_sequence_object(3, 3)
	event.clear_camera_sequence()
	event.set_camera_sequence_position(-41.63, 18.05, -20.16)
	event.set_camera_sequence_look_at(30.4, 34.28, -73.36)
	event.set_character_position(0, 30.52, 0.2, -56.3)
	event.set_character_rotation(0, 0.0, 3.1415927, 0.0)
	event.set_character_motion(0, "立ち")
	event.set_object_sequence_position(1, 23.52, 0.2, -84.52)
	event.set_object_sequence_rotation(1, 0.0, 0.0, 0.0)
	event.set_object_sequence_motion(1, "立ち")
	event.fade_in_screen(30)
	wait.frames(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "O sea que esta es la Pintura dorada...\nLa probar[UNI00e9] ahora mismo.")
	message.say_bubble(0, -1, parn_slot, 0, 0)
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 60.0, 0.0, -100.0, 30)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "会話")
	wait.frames(60)
	event.set_object_sequence_motion(1, "立ち")
	wait.frames(60)
	event.set_character_active(1, 33)
	event.set_object_sequence_position(3, 45.0, 15.0, -90.0)
	event.set_object_sequence_motion(3, "ラフレシアの光", 6)
	event.play_sound_effect(sound_handle, 2)
	wait.frames(60)
	event.fade_out_screen(30, 250.0, 250.0, 250.0)
	wait.frames(30)
	event.set_character_active(0, 33)
	event.set_character_active(1, 32)
	event.set_object_sequence_position(2, 45.0, 15.0, -90.0)
	event.set_object_sequence_rotation(2, 0.0, -0.7853982, 0.0)
	event.set_object_sequence_motion(2, "立ち")
	wait.frames(30)
	event.fade_in_screen(30, 255.0, 255.0, 255.0)
	wait.frames(30)
	wait.frames(30)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "Es... Es real...<page>[UNI00a1]Incre[UNI00ed]ble, es perfecta!")
	message.say_bubble(0, -1, parn_slot, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_object_sequence_motion(2, "歩き")
	event.turn_object_sequence_toward(2, 30.52, 0.2, -56.3, 30)
	object.wait_until_done(2)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(2, "会話")
	event.open_message_window_2(0, "Hola, soy Julia.\nEs un placer conoceros.")
	message.say_bubble(0, -1, 32, 0, 0)
	event.set_object_sequence_motion(2, "立ち")
	event.set_object_sequence_motion(1, "歩き")
	event.turn_object_sequence_toward(1, 30.52, 0.2, -56.3, 30)
	object.wait_until_done(1)
	event.set_object_sequence_motion(1, "会話")
	event.open_message_window_2(0, "Gracias, Max.\nNo he olvidado mi promesa. Usa mi\nnuevo poder cuando quieras.")
	message.say_bubble(0, -1, parn_slot, 0, 0)
	event.set_object_sequence_motion(1, "立ち")
	event.set_npc_party_status(5, 128)
	party.announce_member_joined(5)
	event.set_npc_party_status(22, 130)
	announce_julia_joined()
	event.fade_out_screen(30)
	wait.frames(35)
	event.delete_character(32)
	event.delete_character(33)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
	event.set_villager_ai_enabled(1, parn_slot)
	event.reset_follow_camera(1, 3.14, 20.0)
	event.fade_in_screen(30)
end

--- Shows Parn's closing remark once the Golden Paint request is complete.
local function talk_to_parn_after_paint(npc_slot: s32, player_slot: any)
	local chapter: s32 = 0
	local active_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		active_character = event.get_playable_character() or active_character
		if active_character == 1 then
			event.open_message_window_2(
				0,
				"Las chicas no deben de entender\npor qu[UNI00e9] los hombres necesitan\nperseguir sus ideales."
			)
		else
			event.open_message_window_2(0, "Usa mi nuevo poder\ncuando quieras.")
		end
	else
		event.open_message_window_2(
			0,
			"El mundo de la pintura es muy profundo.\nPuede que me lleve toda una vida dominarlo,\npero el trayecto bien vale la pena."
		)
	end
	cutscene.talk_to_character(npc_slot, -1, 0, 0)
end

--- Chooses Parn's dialogue from the progress of the Golden Paint request.
local function talk_to_parn(npc_slot: s32)
	local player_slot: s32 = 0
	local request_status: s32 = 0
	player_slot = event.get_player_character_slot() or player_slot
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc_dialogue.talk_to_parn(npc_slot, player_slot)
		return
	end
	request_status = event.get_quest_request_status(0, 1) or request_status
	if request_status == 0 then
		start_golden_paint_request(npc_slot, player_slot)
		return
	end
	if request_status == 1 then
		deliver_golden_paint(npc_slot, player_slot)
		return
	end
	if request_status == 2 then
		talk_to_parn_after_paint(npc_slot, player_slot)
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = i04_golden_paint_house.refresh_paint_visibility

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
--- Overrides the square-button handler with nothing.
function script.key_open() end

--- Gives the player twenty of item 243 once and hides the painting.
function script.take_item_from_painting()
	local flag: s32 = 0
	event.set_character_motion(0, "立ち")
	flag = event.get_save_flag(37) or flag
	if flag == 0 then
		event.set_save_flag(37, 1)
		event.add_inventory_item(243, 20)
		inventory.announce_received(243, 20)
		i04_golden_paint_house.set_paint_visible(0)
		inventory.resolve_overflow_alt(1)
	end
end
script[400] = script.take_item_from_painting

--- Talks to the triggered villager, running Parn's dialogue when Parn is the one addressed.
function script.talk_to_villager()
	local villager_kind: s32 = 0
	local villager_slot: s32 = 0
	local stage: number = 0
	return vm.guard(function()
		villager_kind = event.get_triggered_event_data_2(14) or villager_kind
		if villager_kind == 5 then
			villager_slot = event.get_triggered_event_data_2(13) or villager_slot
			event.stop_camera_control_movement()
			event.set_villager_ai_enabled(0, villager_slot)
			stage = 1
			talk_to_parn(villager_slot)
			event.set_villager_ai_enabled(1, villager_slot)
		else
			stage = 2
			villager_dialogue.talk_to_triggered_villager()
		end
		return
	end, function(received: { any })
		if stage <= 2 then
			if stage <= 1 then
				cutscene.play_talk_sequence_default()
			end
			return 0
		end
		return nil
	end)
end
script[1000] = script.talk_to_villager

return script
