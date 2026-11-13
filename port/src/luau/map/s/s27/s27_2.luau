--!strict
--- Pau's house interior in the Shigura village with the Shingala medicine quest and Pau joining the party.

local vm = require("@lib/vm")
local character = require("@lib/event/character")
local cutscene = require("@lib/event/cutscene")
local message = require("@lib/event/message")
local party = require("@lib/event/party")
local paus_house = require("@lib/event/paus_house")
local wait = require("@lib/event/wait")

--- Places the residents of Pau's house.
local function place_residents()
	paus_house.place_residents()
end

--- Speaks Pau's line about Shingala for the current quest progress.
local function talk_about_shingala(partner_slot: s32)
	local flag_444: s32 = 0
	local talk_style: s32 = 0
	local flag_420: s32 = 0
	local flag_438: s32 = 0
	local medicine_count: s32 = 0
	event.set_message_window_mode(0, 1)
	event.set_message_bubble_tail(0, 1)
	flag_444 = event.get_save_flag(444) or flag_444
	if flag_444 == 0 then
		talk_style = 0
		flag_420 = event.get_save_flag(420) or flag_420
		if flag_420 == 0 then
			event.open_message_window_2(
				0,
				"Vous pourriez questionner le type\ndu Labo psy au sujet de l'appareil\nque Shingala a sur la t[UNI00ea]te."
			)
		else
			flag_438 = event.get_save_flag(438) or flag_438
			if flag_438 == 0 then
				medicine_count = event.get_owned_item_count(375) or medicine_count
				if medicine_count >= 1 then
					event.open_message_window_2(
						0,
						"D[UNI00e9]p[UNI00ea]chez-vous de donner ce\nm[UNI00e9]dicament [UNI00e0] Shingala !"
					)
					talk_style = 1
				else
					event.open_message_window_2(
						0,
						"Allez [UNI00e0] la plage o[UNI00f9] se trouvent\nles autres Shiguras et trouvez un\nrem[UNI00e8]de qui gu[UNI00e9]rira Shingala."
					)
				end
			else
				event.open_message_window_2(0, "Je vous en prie ! Vous devez\nsauver le village des Shiguras !")
			end
		end
		paus_house.face_character_and_talk(partner_slot, talk_style)
	else
		event.open_message_window_2(
			0,
			"Shingala me manque... J'ai h[UNI00e2]te\nde voir [UNI00e0] quel point il aura grandi\nl'an prochain."
		)
		paus_house.face_character_and_talk(partner_slot, 0)
	end
end

--- Speaks Pau's quest line when the triggering NPC is Pau.
local function talk_to_pau_during_shingala_quest()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	event.initialize_event()
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	if npc_id == 9 then
		talk_about_shingala(character_slot)
	end
end

--- Plays Pau's first conversation in which he asks for a carrot before joining.
local function ask_for_carrot()
	local character_slot: s32 = 0
	local player_character_slot: s32 = 0
	event.apply_message_window_preset(0, 0)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	cutscene.begin_talk(character_slot, 0, 0)
	player_character_slot = event.get_player_character_slot() or player_character_slot
	event.open_message_window_2(0, "Oh, salut !\nMerci de m'avoir aid[UNI00e9] avec Shingala.\nAlors, quoi de neuf ?")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Quoi ? Moi, venir avec toi ?")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Non, non pas question !<page>Je dois rester ici pour\nattendre Shingala.")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Cela dit, les Shiguras ne\nreviendront probablement pas avant\nsix mois...")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Au lieu de rester ici en attendant,\nje pourrais t'accompagner.")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Je n'ai rien [UNI00e0] faire ici. Si je\nreste, je vais perdre mon temps.")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Ah ouais ! T'es un humain, tu dois\nsavoir [UNI00e7]a !")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "Cet aliment d[UNI00e9]licieux... tu sais\ncomment [UNI00e7]a s'appelle ?")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"Mais si, tu sais ! C'est orange, et\nen gros, de la taille d'un poisson.<page>Bref, c'est orange et d[UNI00e9]licieux."
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "J'aimerais vraiment en ravoir.\nTu pourrais faire [UNI00e7]a pour moi ?")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]Pau a de longues oreilles et de\n   grandes dents. [UNI00c7]a rappelle un certain\n   animal, qui adore un aliment orange..."
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 5, 1)
end

--- Lets the player hand over a carrot and recruits Pau into the party.
local function give_carrot_to_pau()
	local npc_id: s32 = 0
	local character_slot: s32 = 0
	local player_character_slot: s32 = 0
	local item: s32 = 0
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	player_character_slot = event.get_player_character_slot() or player_character_slot
	event.open_message_window_2(0, "Oh ! Tu m'en as apport[UNI00e9] ?\nCet aliment orange...")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_use_item_menu(315)
	vm.wait(3)
	item = vmhost.used_item() or item
	if item <= 0 then
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	if item ~= 315 then
		event.open_message_window_2(0, "Allez ! Ne me fais pas marcher !\nC'est pas [UNI00e7]a !")
		message.say_bubble(0, -1, character_slot, player_character_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "Ah... C'est [UNI00e7]a !<page>La couleur, l'odeur,\nle croquant...")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"Je suppose que vivre avec des\nhommes n'est pas si mal que [UNI00e7]a.<page>Bon, c'est d'accord.\nJe viens avec toi."
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(0, "En fait, j'ai eu l'intuition\nr[UNI00e9]cemment que le monde avait\ndes probl[UNI00e8]mes.")
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"Quand Shingala [UNI00e9]tait l[UNI00e0], je savais\nqu'un certain Griffon causait bien\ndes soucis."
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"Je suppose que tu dois essayer\nde l'arr[UNI00ea]ter. Dans ce cas, je serais\nheureux de t'aider."
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.open_message_window_2(
		0,
		"Au fait, je ne t'aide pas seulement\nparce que tu m'as donn[UNI00e9] une\ncarotte. Ne va pas t'imaginer [UNI00e7]a."
	)
	message.say_bubble(0, -1, character_slot, player_character_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.set_npc_party_status(npc_id, 130)
	party.announce_member_joined(npc_id)
	event.finish_event()
	event.set_quest_request(1, 5, 1)
end

--- Plays Pau's idle line once the carrot request is finished.
local function talk_to_pau_after_joining()
	local character_slot: s32 = 0
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "Mais si jamais tu en trouves\nd'autres, tu sais o[UNI00f9] me trouver !")
	else
		event.open_message_window_2(0, "H[UNI00e9], [UNI00e7]a roule ? Moi, c'est l'top !")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Picks Pau's conversation from the carrot request status.
local function talk_to_pau_by_request_status()
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 5) or request_status
	if request_status == 0 then
		ask_for_carrot()
		return
	end
	if request_status == 1 then
		give_carrot_to_pau()
		return
	end
	if request_status == 2 then
		talk_to_pau_after_joining()
		return
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Does nothing at load time.
function script.setup() end

script.place_residents = place_residents
script[99] = script.place_residents

--- Plays the arrival scene that matches the previous map and saved flags.
function script.default_event()
	local previous_map_number: s32 = 0
	local flag_404: s32 = 0
	local flag_408: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		place_residents()
		previous_map_number = event.get_previous_map() or previous_map_number
		if previous_map_number == 2 then
			flag_404 = event.get_save_flag(404) or flag_404
			if flag_404 == 0 then
				resume_step = 1
				paus_house.play_event_e404()
				event.skip_next_music_load()
				event.jump_to_map_3(-1, "g03", 500)
			else
				resume_step = 2
				paus_house.walk_player_in()
			end
		elseif previous_map_number == 84 then
			flag_408 = event.get_save_flag(408) or flag_408
			if flag_408 == 0 then
				resume_step = 3
				paus_house.play_event_e408()
			else
				resume_step = 4
				paus_house.play_event_e420()
			end
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step <= 1 then
				paus_house.advance_look_height_frame()
			end
			if resume_step <= 2 then
				resume_step = 3
				paus_house.play_event_e408()
				return vm.continue_with(function()
					return
				end)
			end
			if resume_step <= 3 then
				resume_step = 4
				paus_house.play_event_e420()
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
script.key_open = paus_house.play_event_e438

--- Asks whether to leave the house and jumps to g03.
function script.leave_house()
	if paus_house.ask_to_leave_house() ~= 0 then
		event.jump_to_map_2(-1, "g03")
	end
end
script[201] = script.leave_house

--- Lets the player use the medicine on the injured Shingala or hears it call out.
function script.talk_to_shingala()
	local medicine_count: s32 = 0
	local menu_stage: s32 = 0
	local item: s32 = 0
	local confirmed: s32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_yaw: f32 = 0
	local yaw: f32 = 0
	local angle_check: s32 = 0
	local flag_438: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		event.initialize_event()
		medicine_count = event.get_owned_item_count(375) or medicine_count
		if medicine_count >= 1 then
			event.set_character_motion(0, "立ち")
			menu_stage = event.get_triggered_event_data_2(6) or menu_stage
			if menu_stage == 1 then
				event.set_message_window_mode(0, 1)
				event.set_message_bubble_tail(0, 0)
				event.open_message_window_2(0, "Le Shingala bless[UNI00e9] souffre.\nOuvrir le menu : (#).")
				resume_step = 1
				confirmed = message.ask_confirmation(0, -1, 5, 256, 208, confirmed)
				if confirmed == 1 then
					menu_stage = 2
				end
			end
			if menu_stage == 2 then
				event.open_use_item_menu(375)
				resume_step = 2
				vm.wait(2)
				item = vmhost.used_item() or item
				if item > 0 then
					if item == 375 then
						resume_step = 3
						paus_house.play_event_e438()
						event.jump_to_map_3(-1, "s40", 500)
						resume_step = 4
						vm.wait(4)
						return
					else
						resume_step = 5
						character.shake_head()
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
				player_x = out1 or player_x
				player_y = out2 or player_y
				player_z = out3 or player_z
			end
			do
				local _, out2, _ = event.get_character_rotation(0)
				player_yaw = out2 or player_yaw
			end
			yaw = event.get_direction_angle(player_x, player_y, player_z, -76.0, 0.0, 23.0) or yaw
			angle_check = event.compare_angles(player_yaw, yaw, 0.1) or angle_check
			if angle_check ~= 0 then
				event.rotate_object_sequence(0, 0.0, yaw, 0.0, 10)
				event.set_object_sequence_motion(0, "歩き")
				event.delay_object_sequence_motion_track(0, 10)
			end
			event.set_object_sequence_motion(0, "立ち")
			resume_step = 6
			wait.frames(20)
			event.set_message_window_mode(0, 1)
			event.set_mouth_motions(1, "鳴く", 0, "座り", 0)
			flag_438 = event.get_save_flag(438) or flag_438
			if flag_438 == 0 then
				event.open_message_window_2(0, "Weeeeeeah !")
			else
				event.open_message_window_2(0, "Waaaa-oh !")
			end
			resume_step = 7
			message.say_bubble(0, -1, 9, 0, 0)
		end
		return
	end, function(received: { any })
		if resume_step <= 4 then
			if resume_step == 1 then
				confirmed = received[2] :: number
			end
			if resume_step <= 1 then
				local _ = menu_stage == 1
				menu_stage = 2
			end
			if resume_step <= 2 then
				resume_step = 3
				paus_house.play_event_e438()
				return vm.continue_with(function()
					event.jump_to_map_3(-1, "s40", 500)
					resume_step = 4
					vm.wait(4)
					return
				end)
			end
			return 0
		end
		if resume_step <= 7 then
			if resume_step <= 5 then
				wait.frames_skipping(20)
			end
			if resume_step <= 6 then
				message.show_then_close_variant(0, -1, 9, 0, 0)
			end
			return 0
		end
		return nil
	end)
end
script[400] = script.talk_to_shingala

--- Places the residents and plays the cutscene in which Pau sulks.
function script.cutscene_pau_sulks()
	place_residents()
	paus_house.play_event_e408()
end
script[500] = script.cutscene_pau_sulks

--- Runs the villager conversation matching the saved flags.
function script.talk_to_villager()
	local flag_500: s32 = 0
	local character_slot: s32 = 0
	flag_500 = event.get_save_flag(500) or flag_500
	if flag_500 == 0 then
		talk_to_pau_during_shingala_quest()
	else
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, character_slot)
		talk_to_pau_by_request_status()
		event.set_villager_ai_enabled(1, character_slot)
	end
end
script[1000] = script.talk_to_villager

--- Resets the Pau flags and replays the arrival with a jump to g03.
function script.restart_from_arrival()
	event.set_save_flag(408, 0)
	event.set_save_flag(420, 0)
	event.set_save_flag(444, 0)
	place_residents()
	paus_house.play_event_e404()
	event.skip_next_music_load()
	event.jump_to_map_3(-1, "g03", 500)
end
script[14040] = script.restart_from_arrival

--- Sets the Pau flags and replays the Shingala cure with a jump to s40.
function script.restart_from_medicine_cure()
	event.set_save_flag(408, 1)
	event.set_save_flag(420, 1)
	event.set_save_flag(444, 0)
	place_residents()
	paus_house.play_event_e438()
	event.jump_to_map_3(-1, "s40", 500)
	vm.wait(2)
end
script[14380] = script.restart_from_medicine_cure

return script
