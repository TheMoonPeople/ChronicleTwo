--!strict
--- Conversations with townspeople and recruitable characters, including quest-state dispatch.

local vm = require("@lib/vm")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local menu = vm.module("@lib/event/menu")
local message = vm.module("@lib/event/message")
local object = vm.module("@lib/event/object")
local party = vm.module("@lib/event/party")
local wait = vm.module("@lib/event/wait")

local npc = {}

--- Shows an aspiring cook's chapter-dependent remarks and waits for the conversation to end.
function npc.chat_aspiring_cook(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "僕が坊ちゃんの頼みを\n断るわけないじゃないですか。")
	else
		event.open_message_window_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows the baker's chapter-dependent remarks to the second playable character.
function npc.chat_baker_to_second_character(villager_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"最近、ユリスと\nいっしょにいる娘だね。<page>なかなか男を見る目が\nあるよ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "私もあともうちょっと若けりゃ、\n放っておかないんだけどねぇ。")
	else
		event.open_message_window_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.finish_event()
end

--- Shows a shopkeeper explaining that the shop sells blades and waits for the conversation to end.
function npc.chat_blade_shop(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"うちの店は刃物専門だよ。<page>一応、銃も扱ってはいるが、\nどうも飛び道具は\n性に合わなくってね。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a cook comparing his recipes to the player's inventions and waits for the conversation to end.
function npc.chat_cooking_invention(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"坊ちゃん、「発明」の\n調子はどうですか？<page>坊ちゃんが機械や仕掛けを\n「発明」するように、私は\n料理を「発明」しています。<page>まだ誰も食べた事のない\n美味い食べ物を作るために、\n日々研究をしています。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows an angler stating his dream of catching Mardangarayan and his respect for big catches, then waits for the conversation to end.
function npc.chat_fishing_enthusiast(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"俺の趣味は釣りだ。<page>俺の夢は\nマーダンガラヤンを\n釣る事だ。<page>俺が尊敬するのは、\nでっかい魚を\n釣った奴だけだ。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows the angler asking for fishing tips, with a chapter-dependent line.
function npc.chat_fishing_tips_request(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"あのさ、気が向いた時で\n良いから、釣りのコツってのを\n教えてくんねぇか。"
		)
	else
		event.open_message_window_2(0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows the gardener's lines after he has joined the party, depending on chapter and playable character.
function npc.chat_gardener_after_recruit(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			event.open_message_window_2(0, "お嬢さん、アッシに何かご用で？")
		else
			event.open_message_window_2(0, "坊ちゃん、「聖水」のことは、\nダンナ様にはナイショですよ。")
		end
	else
		event.open_message_window_2(
			0,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows the gardener tending a sick tree, with a different line when the player is the second character.
function npc.chat_gardener_busy(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.set_character_motion(player_character, "立ち")
		event.open_message_window_2(0, "この木は・・・イカンな。\nなんとかせねば。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
	else
		event.open_message_window_2(
			0,
			"おぉ、坊ちゃんでしたか、驚いた。\nちょうど木についた悪い虫を取っていたところです。<page>植物は勝手に育つ物ばかりじゃなく、こんな風に\n世話をしないと枯れてしまうのもあるんですよ。"
		)
		cutscene.talk(villager_character, -1, 0, 0)
	end
end

--- Shows an elderly villager complaining of poor hearing and waits for the conversation to end.
function npc.chat_hard_of_hearing(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"・・・<page>ああ、こんにちは。\n最近、耳が遠くなっちまってねぇ。<page>ゆっくりしゃべってもらわないと、\n聞き取れないんだよ。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a villager musing about longing for the moon and waits for the conversation to end.
function npc.chat_longing_for_moon(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"なんでこんなに月が恋しいんだろう。<page>もしかしたら、僕はあそこから\n来たのかも知れない・・・"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a villager muttering number combinations without noticing the player, then a hint to come back later.
function npc.chat_muttering_numbers(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	message.wait_facing_character(villager_character)
	event.open_message_window_2(
		0,
		"・・・１２１２、<page>いやいや、１１２２\nだったような気が。<page>それとも１０１０\nだったかな。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]目の前で話しかけているのに気づかないなんて、\n   何やら大きな悩み事があるみたいですね。<page>   後でまた来てみましょう。もしかしたら、\n   力になってあげられるかもしれませんよ。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Shows a servant's chapter-dependent remarks about the player's friend or the mine.
function npc.chat_noble_servant(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"そう思っているのは私だけかも\nしれませんが、モニカさんは、\nエイナ様に似てらっしゃいます。<page>雰囲気と言うかなんと言うか、\nお二人とも、この町の人とは\n何かが違うと思えてなりません。"
		)
	else
		event.open_message_window_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a servant telling the young master to bring any trouble to him first, then ends the talk.
function npc.chat_offer_help(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"坊ちゃん、何か困った事が\nあれば、誰よりもまず\nこの私に相談してください。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a boy complaining that since the girl arrived the player spends less time with him, then waits for the conversation to end.
function npc.chat_resent_new_girl(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"お姉さんが来てから、ユリスの\n付き合いが悪くなっちまった。<page>何してんのか知らないけど、\nあいつをこき使わないでくれよ。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a shopkeeper's advice that customer trust comes first and waits for the conversation to end.
function npc.chat_shopkeeper_advice(villager_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"商売はお客の\n信用が第一。<page>ないがしろにしちゃ\n絶対にいけないよ。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a villager reminding the player to sort garbage, or of the mine's danger in the later chapter.
function npc.chat_sort_garbage(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "ゴミはきちんと分別\nして、決められた日に\n出すようにな。")
	else
		event.open_message_window_2(
			0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Shows a town guard's chapter-dependent remarks and waits for the conversation to end.
function npc.chat_town_guard(villager_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"女の子が剣を振り回すなんて、\n私はあまり好きではないな。<page>例えばルネさんのような、\nおしとやかな女性が一番だよ。"
		)
	else
		event.open_message_window_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Forwards the talked-to character and the player to the default talk handler.
function npc.forward_talk(npc_character: any, player_character: any)
	npc.resume_chat_muttering_numbers(npc_character, player_character)
end

--- Shows the flower girl greeting the second playable character as the player's girlfriend.
function npc.greet_second_character(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "こんにちは、ユリスの\nガールフレンドさん？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"めずらしい髪の色ですね。\nトムみたいな赤毛ともちがう、\nまるで宝石みたい。<page>ステキだわ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.finish_event()
end

--- Loads the model that matches a villager's character number, places the villager and registers it as an active scene character.
function npc.load_villager(slot: s32, character_number: s32, x: f32, y: f32, z: f32, yaw: f32)
	if character_number == 51 or character_number == 81 or character_number == 166 then
		event.load_character(4, "chara/p01_19a.gltf", "info", slot)
	end
	if character_number == 54 or character_number == 60 or character_number == 76 or character_number == 83 or character_number == 169 then
		event.load_character(4, "chara/p01_20a.gltf", "info", slot)
	end
	if character_number == 90 or character_number == 70 or character_number == 80 then
		event.load_character(4, "chara/p01_21a.gltf", "info", slot)
	end
	if character_number == 55 or character_number == 62 or character_number == 94 or character_number == 77 or character_number == 84 or character_number == 168 then
		event.load_character(4, "chara/p01_22a.gltf", "info", slot)
	end
	if character_number == 59 or character_number == 91 or character_number == 71 or character_number == 159 then
		event.load_character(4, "chara/p01_23a.gltf", "info", slot)
	end
	if character_number == 95 or character_number == 75 or character_number == 85 or character_number == 172 then
		event.load_character(4, "chara/p01_24a.gltf", "info", slot)
	end
	if character_number == 57 or character_number == 64 or character_number == 98 or character_number == 74 or character_number == 87 or character_number == 157 or character_number == 158 then
		event.load_character(4, "chara/p03_20a.gltf", "info", slot)
	end
	if character_number == 58 or character_number == 69 or character_number == 99 or character_number == 79 or character_number == 89 or character_number == 167 then
		event.load_character(4, "chara/p03_22a.gltf", "info", slot)
	end
	if character_number == 53 or character_number == 68 or character_number == 93 or character_number == 73 or character_number == 86 or character_number == 164 or character_number == 165 then
		event.load_character(4, "chara/p03_24a.gltf", "info", slot)
	end
	if character_number == 40 then
		event.load_character(4, "chara/p03_26a.gltf", "info", slot)
	end
	if character_number == 41 then
		event.load_character(4, "chara/p03_27a.gltf", "info", slot)
	end
	if character_number == 42 then
		event.load_character(4, "chara/p03_28a.gltf", "info", slot)
	end
	if character_number == 67 or character_number == 65 or character_number == 97 or character_number == 88 then
		event.load_character(4, "chara/p03_30a.gltf", "info", slot)
	end
	if character_number == 63 then
		event.load_character(4, "chara/p03_32a.gltf", "info", slot)
	end
	if character_number == 66 then
		event.load_character(4, "chara/p03_33a.gltf", "info", slot)
	end
	if character_number == 52 or character_number == 61 or character_number == 92 or character_number == 161 or character_number == 163 then
		event.load_character(4, "chara/p03_37a.gltf", "info", slot)
	end
	if character_number == 56 or character_number == 96 or character_number == 78 or character_number == 170 or character_number == 171 then
		event.load_character(4, "chara/p03_38a.gltf", "info", slot)
	end
	if character_number == 72 or character_number == 162 then
		event.load_character(4, "chara/p03_39a.gltf", "info", slot)
	end
	if character_number == 82 or character_number == 160 then
		event.load_character(4, "chara/p03_40a.gltf", "info", slot)
	end
	event.set_character_position(slot, x, y, z)
	event.set_character_rotation(slot, 0.0, yaw, 0.0)
	event.set_scene_character_number(slot, character_number)
	event.register_villager(slot, character_number)
	event.set_character_active(slot)
end

--- Greets the player as a shopkeeper, shows first-visit introductions and opens the shop menu of the triggered character.
function npc.open_shop()
	local npc_id: s32 = 0
	local villager_character: s32 = 0
	local language_code: s32 = 0
	local bakery_intro_flag: s32 = 0
	local weapon_shop_intro_flag: s32 = 0
	local church_intro_flag: s32 = 0
	print("IN go_shop_up()\n")
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	villager_character = event.get_triggered_event_data_2(13) or villager_character
	print("talk_chara=", npc_id, "talk_chara_id=", villager_character, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	language_code = event.get_language() or language_code
	if language_code ~= 0 then
		event.open_message_window_2(0, "Welcome.")
	else
		event.open_message_window_2(0, "いらっしゃい。")
		if npc_id == 18 then
			event.open_message_window_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if npc_id == 4 then
			event.open_message_window_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if npc_id == 34 then
			event.open_message_window_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if npc_id == 1012 then
			bakery_intro_flag = event.get_save_flag(45) or bakery_intro_flag
			if bakery_intro_flag == 0 then
				event.open_message_window_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.set_save_flag(45, 1)
			end
		end
		if npc_id == 1015 then
			weapon_shop_intro_flag = event.get_save_flag(46) or weapon_shop_intro_flag
			if weapon_shop_intro_flag == 0 then
				event.open_message_window_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.set_save_flag(46, 1)
			end
		end
		if npc_id == 1018 then
			church_intro_flag = event.get_save_flag(47) or church_intro_flag
			if church_intro_flag == 0 then
				event.open_message_window_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.set_save_flag(47, 1)
			else
				event.open_message_window_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if villager_character ~= -1 then
		cutscene.talk(villager_character, -1, 0, 0)
	end
	if npc_id == 18 then
		menu.open_type_6(15)
	end
	if npc_id == 12 then
		menu.open_type_6(1)
	end
	if npc_id == 4 then
		menu.open_type_6(6)
	end
	if npc_id == 15 then
		menu.open_type_6(0)
	end
	if npc_id == 33 then
		menu.open_type_6(4)
	end
	if npc_id == 34 then
		menu.open_type_6(31)
	end
	if npc_id == 1012 then
		menu.open_type_6(35)
	end
	if npc_id == 1015 then
		menu.open_type_6(36)
	end
	if npc_id == 1018 then
		menu.open_type_6(37)
	end
end

--- Resumes the number-muttering villager's conversation through its remaining pages.
function npc.resume_chat_muttering_numbers(villager_character: any, player_character: any)
	message.wait_facing_character_skipping(villager_character)
	message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
	message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
	message.show_and_wait_skipping(0, -1, 8, 0, 0)
end

--- Logs the talked-to character and runs the shop-up finishing sequence when the villager talk resumes.
function npc.resume_talk_end()
	cutscene.log_and_go_shop_up()
end

--- Runs every resumable step of the villager talk dispatcher in order, ending with the choice prompt.
function npc.resume_talk_steps(villager_character: s32, player_character: s32)
	cutscene.resume_say_bubble_then_talk(villager_character, player_character)
	message.resume_talk_pages(villager_character, player_character)
	cutscene.go_shop_up()
	message.resume_talk_pages_fifth(villager_character, player_character)
	message.resume_talk_pages_third(villager_character, player_character)
	message.resume_talk_pages_fourth(villager_character, player_character)
	message.resume_talk_pages_sixth(villager_character, player_character)
	message.resume_talk_pages_second(villager_character, player_character)
	local _ = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
end

--- Plays an NPC's remark after the quest 2 request is done, using the Monica variant when Monica is playable outside chapter 8, or an offer of help in chapter 8.
function npc.talk_after_quest_2(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc.chat_resent_new_girl(npc_character, player_character)
			return
		end
		event.apply_message_window_preset(0, 0)
		event.open_message_window_2(
			0,
			"集められっこないと\n思って、ダメモトで\n言ったんだけどな。<page>やっぱ、ユリスは\nすごいぜ。"
		)
	else
		event.open_message_window_2(
			0,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Chooses the baker's dialogue from the playable character and the state of her request chain.
function npc.talk_baker(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local request_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_baker_to_second_character(villager_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.chat_shopkeeper_advice(villager_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 8) or request_status
	if request_status == 0 then
		party.ask_baker_to_join(villager_character, player_character)
		return
	end
	if request_status == 1 then
		npc.talk_bread_seller_recruit(villager_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_baker(villager_character, player_character)
		return
	end
end

--- Plays an NPC's talk praising the shine of well-honed swords, with a question about tough opponents in the Zelmite mine in chapter 8.
function npc.talk_blade_admirer(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"よくきたえられた\n剣のかがやきは\n素晴らしいよ。<page>吸い込まれそうだ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "石ころをみがいて\nありがたがっている\n奴の気が知れないね。")
	else
		event.open_message_window_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays a guard complaining that the town is too peaceful for him to shine.
function npc.talk_bored_guard(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"この町は平和すぎて、\n私のかつやくする場が\n全然ない。<page>もちろん、それが\n良い事なのはわかって\nいるんだが・・・"
	)
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays the bread seller waiting for the Morton visits, then swaps the bread items and recruits her as a party member.
function npc.talk_bread_seller_recruit(npc_character: s32, player_character: s32)
	local visit_counter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	visit_counter = event.get_save_counter(12) or visit_counter
	if visit_counter < 3 then
		event.open_message_window_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"なんだって！モートンの奴、\n勝手なことばっかり言って。<page>もう、いいわ、\nそのパンは全部あげる。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Plays Stuart asking for 1000 gilda to win a book auction and starts the quest 6 request.
function npc.talk_butler_book_auction(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"坊ちゃんの頼みとあらば、\n出来る限りの事をして\n差し上げます。<page>お任せください。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "・・・")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"引き受けてくれとは\n申しません・・・<page>ただ、私の話を聞いて\n頂きとうございます。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"この家にお仕えして３０余年、\n真面目だけが取り得と\n今まで尽くしてまいりました。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "そんな仕事しか取り得の\nない私の、唯一の趣味が\n読書なんです。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"すごく貴重で珍しい本が\nありまして、その本が今、\nオークションに出ているのです。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"まさに競り合っている最中なのです。\n思うに、１０００ギルダもあれば\n落札出来ます。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、そんな大金、とても\n持ち合わせていませんし、<page>こんな事、だんな様に\nご相談したなら、呆れ果てて、\nお暇を頂く事になるでしょう。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"ですから、お頼みできるのは、\n坊ちゃんだけなのです。<page>決して、決して交換条件と\nいう訳ではございませんよ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]なんだかんだ言って、１０００ギルダ渡さないと\n   スチュアートは仲間になってくれそうにないですね。\n   仕方ありません。お金を用意しましょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Chooses the butler's talk from the Monica check, the quest 0 status and the state of the quest 6 request.
function npc.talk_butler_by_quest_6(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_noble_servant(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_offer_help(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		npc.talk_butler_book_auction(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		party.recruit_auction_butler(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_book_buyer(npc_character, player_character)
		return
	end
end

--- Stops the camera and the villager's wandering, then runs the conversation, recruitment or shop scene that matches the triggered character's id.
function npc.talk_by_npc_id(villager_character: s32, player_character: s32)
	local chapter: s32 = 0
	local npc_id: s32 = 0
	local submap_no: s32 = 0
	local save_flag_104: s32 = 0
	local gardener_status_for_baker: s32 = 0
	local baker_request_status: s32 = 0
	local baker_join_choice: any = 0
	local gardener_status_for_blade_shop: s32 = 0
	local blade_shop_request_status: s32 = 0
	local blade_shop_join_choice: any = 0
	local gardener_status_for_priest: s32 = 0
	local priest_request_status: s32 = 0
	local priest_join_choice: any = 0
	local bread_request_status: s32 = 0
	local playable_character: s32 = 0
	local shop_or_talk_choice: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		chapter = event.get_chapter() or chapter
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		event.get_current_map()
		submap_no = event.get_current_submap() or submap_no
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, villager_character)
		if npc_id == 3 then
			resume_point = 1
			npc.talk_gardener(villager_character, player_character)
		end
		if npc_id == 5 then
			resume_point = 2
			party.recruit_painter(villager_character, player_character)
		end
		if npc_id == 4 then
			save_flag_104 = event.get_save_flag(104) or save_flag_104
			if save_flag_104 == 0 then
				resume_point = 3
				npc.open_shop()
			else
				resume_point = 4
				npc.talk_shopkeeper_by_quest_2(villager_character, player_character)
			end
		end
		if npc_id == 7 then
			resume_point = 5
			npc.talk_chef_by_quest_3(villager_character, player_character)
		end
		if npc_id == 8 then
			resume_point = 6
			npc.talk_girl_by_quest_4(villager_character, player_character)
		end
		if npc_id == 10 then
			resume_point = 7
			npc.talk_butler_by_quest_6(villager_character, player_character)
		end
		if npc_id == 11 then
			resume_point = 8
			npc.talk_maid_by_quest_7(villager_character, player_character)
		end
		if npc_id == 12 then
			gardener_status_for_baker = event.get_quest_request_status(0, 0) or gardener_status_for_baker
			baker_request_status = event.get_quest_request_status(0, 8) or baker_request_status
			if gardener_status_for_baker == 2 and baker_request_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 9
				baker_join_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if baker_join_choice < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if baker_join_choice == 1 then
					resume_point = 10
					npc.talk_baker(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap_no == 28 then
				resume_point = 11
				npc.open_shop()
			else
				resume_point = 12
				npc.talk_baker(villager_character, player_character)
			end
		end
		if npc_id == 14 then
			resume_point = 13
			party.recruit_busy_official(villager_character, player_character)
		end
		if npc_id == 15 then
			gardener_status_for_blade_shop = event.get_quest_request_status(0, 0) or gardener_status_for_blade_shop
			blade_shop_request_status = event.get_quest_request_status(0, 10) or blade_shop_request_status
			if gardener_status_for_blade_shop == 2 and blade_shop_request_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 14
				blade_shop_join_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if blade_shop_join_choice < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if blade_shop_join_choice == 1 then
					resume_point = 15
					party.recruit_circus_performer(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap_no == 30 then
				resume_point = 16
				npc.open_shop()
			else
				resume_point = 17
				party.recruit_circus_performer(villager_character, player_character)
			end
		end
		if npc_id == 16 then
			resume_point = 18
			npc.talk_by_quest_11(villager_character, player_character)
		end
		if npc_id == 17 then
			resume_point = 19
			npc.talk_mayor_by_quest_12(villager_character, player_character)
		end
		if npc_id == 18 then
			gardener_status_for_priest = event.get_quest_request_status(0, 0) or gardener_status_for_priest
			priest_request_status = event.get_quest_request_status(0, 13) or priest_request_status
			if gardener_status_for_priest == 2 and priest_request_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 20
				priest_join_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if priest_join_choice < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if priest_join_choice == 1 then
					resume_point = 21
					npc.talk_priest(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap_no == 33 then
				resume_point = 22
				npc.open_shop()
			else
				resume_point = 23
				npc.talk_priest(villager_character, player_character)
			end
		end
		if npc_id == 19 then
			resume_point = 24
			party.recruit_moon_photo_friend(villager_character, player_character)
		end
		if npc_id == 20 then
			resume_point = 25
			npc.talk_fisherman(villager_character, player_character)
		end
		if npc_id == 21 then
			resume_point = 26
			party.recruit_podium_hopeful(villager_character, player_character)
		end
		if npc_id == 23 then
			resume_point = 27
			party.recruit_mina(villager_character, player_character)
		end
		if npc_id == 24 then
			resume_point = 28
			npc.talk_colin(villager_character, player_character)
		end
		if npc_id == 25 then
			resume_point = 29
			party.recruit_grandmother(villager_character, player_character)
		end
		if npc_id == 33 then
			bread_request_status = event.get_quest_request_status(0, 8) or bread_request_status
			playable_character = event.get_playable_character() or playable_character
			if bread_request_status == 1 and playable_character == 0 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "買い物させて\nこんにちは")
				resume_point = 30
				shop_or_talk_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if shop_or_talk_choice < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if shop_or_talk_choice == 1 then
					resume_point = 31
					npc.talk_fondue_host(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			resume_point = 32
			npc.open_shop()
		end
		if npc_id == 1 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"最近は細かい部品が\n見えにくくてのぅ。<page>わしも、もうろく\nしたのかのぅ・・・"
				)
			else
				event.open_message_window_2(
					0,
					"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
				)
			end
			resume_point = 33
			cutscene.talk(villager_character, -1, 0, 0)
		end
		if npc_id == 2 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
				)
			end
			resume_point = 34
			cutscene.talk(villager_character, -1, 0, 0)
		end
		if npc_id == 6 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(0, "この時期、羽毛に虫がついてな、\nかゆくてかなわんよ。")
			else
				event.open_message_window_2(
					0,
					"ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。"
				)
			end
			resume_point = 35
			cutscene.talk(villager_character, -1, 0, 0)
		end
		if npc_id == 13 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
				)
			else
				event.open_message_window_2(0, "おまえ、ホントに冒険が好きだよなぁ。")
			end
			resume_point = 36
			cutscene.talk(villager_character, -1, 0, 0)
		end
		if npc_id == 22 then
			event.apply_message_window_preset(0, 0)
			if chapter ~= 8 then
				event.open_message_window_2(
					0,
					"絵から出て来たって言っても、\nそれ以外は普通の人と変わらないのよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
				)
			end
			resume_point = 37
			cutscene.talk(villager_character, -1, 0, 0)
		end
		event.set_villager_ai_enabled(1, villager_character)
		return
	end, function(received: { any })
		if resume_point <= 9 then
			if resume_point == 9 then
				baker_join_choice = received[1] :: number
			end
			if resume_point <= 1 then
				message.resume_talk_pages(villager_character, player_character)
			end
			if resume_point <= 2 then
				cutscene.go_shop_up()
			end
			if resume_point <= 3 then
				message.resume_talk_pages_fifth(villager_character, player_character)
			end
			if resume_point <= 4 then
				message.resume_talk_pages_third(villager_character, player_character)
			end
			if resume_point <= 5 then
				message.resume_talk_pages_fourth(villager_character, player_character)
			end
			if resume_point <= 6 then
				message.resume_talk_pages_sixth(villager_character, player_character)
			end
			if resume_point <= 7 then
				message.resume_talk_pages_second(villager_character, player_character)
			end
			if resume_point <= 8 then
				baker_join_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 10 then
			return 0
		end
		if resume_point <= 14 then
			if resume_point == 14 then
				blade_shop_join_choice = received[1] :: number
			end
			if resume_point <= 11 then
				message.resume_talk_pages_third(villager_character, player_character)
			end
			if resume_point <= 12 then
				message.resume_finish_dialogue(villager_character, player_character)
			end
			if resume_point <= 13 then
				blade_shop_join_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 15 then
			return 0
		end
		if resume_point <= 20 then
			if resume_point == 20 then
				priest_join_choice = received[1] :: number
			end
			if resume_point <= 16 then
				message.resume_talk_pages_sixth(villager_character, player_character)
			end
			if resume_point <= 17 then
				message.resume_talk_pages_sixth(villager_character, player_character)
			end
			if resume_point <= 18 then
				npc.forward_talk(villager_character, player_character)
			end
			if resume_point <= 19 then
				priest_join_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 21 then
			return 0
		end
		if resume_point <= 30 then
			if resume_point == 30 then
				shop_or_talk_choice = received[1] :: number
			end
			if resume_point <= 22 then
				cutscene.talk_with_default_message_zero_option(villager_character, player_character)
			end
			if resume_point <= 23 then
				message.resume_talk_pages_fifth(villager_character, player_character)
			end
			if resume_point <= 24 then
				message.resume_talk_pages_fifth(villager_character, player_character)
			end
			if resume_point <= 25 then
				cutscene.talk_with_default_message_forwarded(villager_character, player_character)
			end
			if resume_point <= 26 then
				cutscene.show_two_default_messages_forwarded_alt(villager_character, player_character)
			end
			if resume_point <= 27 then
				message.resume_talk_pages(villager_character, player_character)
			end
			if resume_point <= 28 then
				message.resume_talk_pages_fifth(villager_character, player_character)
			end
			if resume_point <= 29 then
				shop_or_talk_choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 31 then
			return 0
		end
		if resume_point <= 37 then
			if resume_point <= 32 then
				cutscene.talk_skipping(villager_character, -1, 0, 0)
			end
			if resume_point <= 33 then
				cutscene.talk_skipping(villager_character, -1, 0, 0)
			end
			if resume_point <= 34 then
				cutscene.talk_skipping(villager_character, -1, 0, 0)
			end
			if resume_point <= 35 then
				cutscene.talk_skipping(villager_character, -1, 0, 0)
			end
			if resume_point <= 36 then
				cutscene.talk_skipping(villager_character, -1, 0, 0)
			end
			return 0
		end
		return nil
	end)
end

--- Chooses the NPC's talk from the Monica check, the quest 0 status and the state of the quest 11 request.
function npc.talk_by_quest_11(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_welcoming_elder(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_study_mine_advice(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 11) or quest_status
	if quest_status == 0 then
		party.start_gun_upgrade_challenge(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		party.ask_gun_expert_to_join(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_gun_expert(npc_character, player_character)
		return
	end
end

--- Chooses the chef's talk from the Monica check, the quest 0 status and the state of the quest 3 request.
function npc.talk_chef_by_quest_3(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_chef_with_monica(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_cooking_invention(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 3) or quest_status
	if quest_status == 0 then
		npc.talk_chef_chestnut_request(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		party.ask_cook_to_join(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.chat_aspiring_cook(npc_character, player_character)
		return
	end
end

--- Plays the chef asking for pointy chestnuts for a rare sweet and starts the quest 3 request.
function npc.talk_chef_chestnut_request(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "あ、坊ちゃん、ちょうど良い所へ。\nちょっと相談があるんですよ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"僕が研究のために世界中の\nめずらしいお菓子を作って\nいるのはご存知ですよね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "なんでも、「カスタニャッチョ」\nというお菓子があるそうで、")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "それは「カスターニャ」という\n物を使って作るらしいんです。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"いろいろ調べてみて、その\n「カスターニャ」ってのは、<page>どうも『とんがりマロン』と\n同じ種類の木の実らしいと\nいう所までは突き止めました。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そこで、とりあえず『とんがりマロン』を\n使って作って見ようと思ったのですが、<page>不思議な事に、町中の『とんがりマロン』が\n売り切れてしまっているのです。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"なんでも、町長が\n買い占めてしまったとか。<page>坊ちゃん、なんとか\nなりませんか？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 3, 1)
end

--- Plays the chef's talk with Monica about favorite food and cooking dreams, with a different line in chapter 8.
function npc.talk_chef_with_monica(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "こんにちは。\nモニカさんはどんな\n食べ物が好きですか？")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"僕はもちろんおいしい物が\n好きですが、めずらしい\n食べ物にも目がないんですよ。"
		)
	else
		event.open_message_window_2(
			0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays a child asking to be taken along outside town, calling the playable character big brother or big sister.
function npc.talk_child_wants_to_join(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.open_message_window_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays a shopkeeper's remark that the shop is closed and customers should visit the family shop marked by a pumpkin.
function npc.talk_closed_shop_keeper(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"もう店じまいだ。これからは\n親父の店で買ってくれ。<page>カボチャが目印だ。知ってるだろ。\nそこのはしごから出りゃすぐだから。"
	)
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Chooses the dialogue of Colin, the girl who wants to join through a game of hide-and-seek, from the state of the request chain.
function npc.talk_colin(villager_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_child_wants_to_join(villager_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status == 0 then
		party.start_hide_and_seek(villager_character, player_character)
		return
	end
	if request_status == 1 then
		npc.talk_hide_and_seek_found(villager_character, player_character)
		return
	end
	if request_status == 2 then
		npc.talk_hide_and_seek_girl(villager_character, player_character)
		return
	end
end

--- Plays an NPC's remark that the people of Fabris heed requests only from someone better than themselves.
function npc.talk_fabris_pride(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays a Fabris NPC challenging the player to win a fish race and starts the quest 16 request.
function npc.talk_fish_race_request(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"ファブリースの民は、\n自分より秀でた人でないと、\nたのみを聞く事はありません。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "私も魚については、\nいささか自信があります。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"聞く所によると、人間は\n魚に競争をさせて\nいるとかいないとか。<page>あなたも魚を飼って\nいるのなら、それで\n一番になってみなさい。<page>そうすれば、\n私もあなたを認め、\n力になりましょう。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]彼女はどうやらギョレースの事を言っているようです。\n   さしあたり、ビギナークラスで優勝してみましょう。\n   彼女の態度も変わるかも知れません。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Chooses the fisherman's dialogue from the state of his request chain.
function npc.talk_fisherman(villager_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.chat_fishing_enthusiast(villager_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 15) or request_status
	if request_status == 0 then
		party.ask_fisherman_to_join(villager_character, player_character)
		return
	end
	if request_status == 1 then
		party.recruit_after_fishing(villager_character, player_character)
		return
	end
	if request_status == 2 then
		npc.chat_fishing_tips_request(villager_character, player_character)
		return
	end
end

--- Plays the fondue party host's bread delivery conversation according to the delivery state.
function npc.talk_fondue_host(villager_character: s32, player_character: s32)
	local delivery_state: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	delivery_state = event.get_save_counter(12) or delivery_state
	if delivery_state == 0 then
		event.open_message_window_2(0, "ああ、ポリーの\nお手伝いかい？<page>ごくろうさん。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"ん、パンを２０個も\nどうするかって？<page>今日は「チーズフォンデュ」\nパーティーなんだ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"ユリスお得意の「発明」で言うなら、\nチーズとパンとワインで発明された\n料理のことさ。<page>うまいんだぜ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"みんな、たくさん食べるから、\nこれだけパンがいるんだ。<page>でも、今パンを渡されても\n困るな。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"ユリス、悪いんだが、\nそのパンを家まで\n持っていってくれないか。<page>家は知ってるよな、\nカボチャ畑が目印だ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_save_counter(12, 1)
	end
	if delivery_state == 1 then
		event.open_message_window_2(0, "家は知ってるよな、\nカボチャ畑が目印だ。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
	end
	if delivery_state == 2 then
		event.open_message_window_2(0, "中止だって！？\nそいつは残念だな。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"じゃ、ユリス、\nパンはいらないから、\nポリーに返して来てくれ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_save_counter(12, 3)
	end
	if delivery_state == 3 then
		event.open_message_window_2(0, "悪いな。パンはポリーに\n返して来てくれ。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
	end
	event.set_character_motion(villager_character, "立ち")
	event.finish_event()
end

--- Chooses the gardener's dialogue from his flag and the state of his recruitment request.
function npc.talk_gardener(villager_character: s32, player_character: s32)
	local save_flag_42: s32 = 0
	local gardener_request_status: s32 = 0
	save_flag_42 = event.get_save_flag(42) or save_flag_42
	if save_flag_42 == 0 then
		npc.chat_gardener_busy(villager_character, player_character)
		return
	end
	gardener_request_status = event.get_quest_request_status(0, 0) or gardener_request_status
	if gardener_request_status == 0 then
		party.ask_gardener_to_join(villager_character, player_character)
		return
	end
	if gardener_request_status == 1 then
		party.recruit_gardener_with_holy_water(villager_character, player_character)
		return
	end
	if gardener_request_status == 2 then
		npc.chat_gardener_after_recruit(villager_character, player_character)
		return
	end
end

--- Plays a girl who helps but dislikes bugs, with a railway remark in chapter 8.
function npc.talk_girl_afraid_of_bugs(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"助けてもらったから\n協力するけど、虫がいる\n所には行きたくないわ。"
		)
	else
		event.open_message_window_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Chooses the girl's talk from the quest 0 status and the state of the quest 4 request.
function npc.talk_girl_by_quest_4(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_secret_outings_nag(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		party.ask_claire_to_join(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		party.recruit_after_flower_photos(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_claire(npc_character, player_character)
		return
	end
end

--- Plays the girl being found in hide-and-seek, hiding again on the first find and joining the party on the later one.
function npc.talk_hide_and_seek_found(npc_character: s32, player_character: s32)
	local found_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	found_count = event.get_save_counter(11) or found_count
	if found_count < 1 then
		event.open_message_window_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, found_count + 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_villager_ai_enabled(1, npc_character)
		event.set_character_active(0, npc_character)
		event.delete_villager(npc_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"あぁ、\n見つかっちゃった・・・<page>ふぅ、なんだか\nあきて来ちゃった。<page>なんか、かくれてるのって\n意外とつまんないものね。<page>いいわ、そろそろ冒険に\n出発しましょう！"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- Plays a girl's remark about hide-and-seek being child's play, with a different line in chapter 8.
function npc.talk_hide_and_seek_girl(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "かくれんぼなんて、\nしょせん\n子供の遊びよね。")
	else
		event.open_message_window_2(
			0,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays Patori the magic painter, introducing himself to Monica or asking Yuris for golden paint and starting the quest 1 request.
function npc.talk_magic_painter(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk(npc_character, 0, 0)
		event.open_message_window_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(0, "・・・")
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
		)
		message.show(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "やぁ、ユリス、\nこんにちは。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "・・・")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]いにしえの巨木・・・\n   金の卵が宿っちゃうような、\n   そんなとんでもない木なんて、\n   どこに行けば生えているんでしょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Plays the painter offering his power freely, with a remark about the depth of painting in chapter 8.
function npc.talk_magic_painter_done(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "僕のこの能力、えんりょなく\n存分に使ってくれ。")
	else
		event.open_message_window_2(0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Chooses the maid's talk from the Monica check, the quest 0 status, the quest 7 request state and the clothing progress counter.
function npc.talk_maid_by_quest_7(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local clothing_progress: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_maid_protective(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_maid_clothing_dream(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 7) or quest_status
	if quest_status == 0 then
		party.ask_rene_to_join(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		clothing_progress = event.get_save_counter(8) or clothing_progress
		if clothing_progress == 0 then
			npc.talk_sewing_materials_request(npc_character, player_character)
		end
		if clothing_progress == 1 then
			party.give_tailor_materials(npc_character, player_character)
		end
		if clothing_progress == 2 then
			party.recruit_tailor_after_clothing(npc_character, player_character)
		end
		return
	end
	if quest_status == 2 then
		npc.talk_maid_clothing_fit(npc_character, player_character)
		return
	end
end

--- Plays the maid's talk about her childhood dream of running a clothing shop.
function npc.talk_maid_clothing_dream(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"今はこうしてメイドをして\nますけど、洋服屋さんに\nなるのが小さい頃の夢でした。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "夢は実現しないから\n夢って言うんですよね。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Plays the maid asking how the clothes fit, with a farewell in chapter 8.
function npc.talk_maid_clothing_fit(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"洋服の着心地は\nどうですか？<page>正直な意見を\n聞かせてください。"
		)
	else
		event.open_message_window_2(0, "ご無事をお祈りします・・・")
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays the maid warning Monica to keep the young master safe, with a farewell in chapter 8.
function npc.talk_maid_protective(npc_character: s32, player_character: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "くれぐれも坊ちゃんを\n危ない目には\nあわせないで下さいね。")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"坊ちゃんにすりキズひとつでも\nつけたら、このルネが\nしょうちしませんから！"
		)
	else
		event.open_message_window_2(0, "ご無事をお祈りします・・・")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
end

--- Chooses the mayor's talk from the quest 0 status and the state of the quest 12 request.
function npc.talk_mayor_by_quest_12(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_muttering_numbers(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		party.ask_mayor_to_join(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		npc.talk_mayor_safe_puzzle(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.chat_sort_garbage(npc_character, player_character)
		return
	end
end

--- Plays the mayor's safe puzzle with clues, prompts for the safe code, opens the safe on the right code, then recruits him as a party member.
function npc.talk_mayor_safe_puzzle(npc_character: s32, player_character: s32)
	local choice: any = 0
	local code_result: s32 = 0
	local sound_id: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation_x: f32 = 0
	local npc_rotation_y: f32 = 0
	local npc_rotation_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local player_angle: f32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	while true do
		event.open_message_window_2(
			0,
			"【手がかり１】昔、誕生日に\nちなんだ星座のブローチを\nあげた事があったっけ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"ポリーに用意してもらったから\nよく覚えてないんだが、確か４本足の\n動物だったような気がする・・・"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"【手がかり２】\n今まであげた誕生日の\nプレゼント？<page>う～ん、コートとか\nマフラーとかが\n多いかなぁ。<page>どんなのが良いのか\nさっぱりわからんので、\n毎年苦労するんだよ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"【手がかり３】そうそう、クレアの誕生日は、\n燃えるゴミを出す日と、燃えないゴミを出す日が\n重なってるんで、いつも大変なんだよ。<page>ああ、我が家でゴミを出すのは私の役目だ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"燃えないゴミを出す日は\n日にちが７で割り切れる日、<page>燃えるゴミを出す日は\n３で割り切れる日だよ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "まさか、忘れてたんじゃ\nないだろうね。")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.open_message_window_2(
			0,
			"わかった、謎は解けたぞ！暗証番号は・・・\nわからない・・・もっと話を聞いてみよう。"
		)
		choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
		if choice == 0 then
			break
		else
			if choice == -1 then
				event.finish_event()
				return
			end
			event.set_character_motion(npc_character, "会話")
		end
	end
	event.set_menu_value(0, "暗証番号を入力してください", "１２２１", 0)
	event.open_event_menu(5)
	vm.wait(9)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		code_result = out1 or code_result
	end
	if code_result == -1 then
		event.finish_event()
		return
	end
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	sound_id = event.get_sound_id(2) or sound_id
	do
		local out1, out2, out3 = event.get_character_position(npc_character)
		npc_x = out1 or npc_x
		npc_y = out2 or npc_y
		npc_z = out3 or npc_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(npc_character)
		npc_rotation_x = out1 or npc_rotation_x
		npc_rotation_y = out2 or npc_rotation_y
		npc_rotation_z = out3 or npc_rotation_z
	end
	event.set_character_position(npc_character, -100.0, 0.0, -110.0)
	event.set_character_rotation(npc_character, 0.0, 3.1415927, 0.0)
	event.set_character_motion(npc_character, "立ち")
	do
		local out1, out2, out3 = event.get_character_position(0)
		player_x = out1 or player_x
		player_y = out2 or player_y
		player_z = out3 or player_z
	end
	do
		local out1, out2, out3 = event.get_character_rotation(0)
		player_rotation_x = out1 or player_rotation_x
		player_rotation_y = out2 or player_rotation_y
		player_rotation_z = out3 or player_rotation_z
	end
	player_angle = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or player_angle
	event.set_character_rotation(0, 0.0, player_angle, 0.0)
	event.set_character_motion(0, "立ち")
	do
		local out1, out2, out3 = event.get_camera_position()
		camera_x = out1 or camera_x
		camera_y = out2 or camera_y
		camera_z = out3 or camera_z
	end
	do
		local out1, out2, out3 = event.get_camera_look_at()
		look_at_x = out1 or look_at_x
		look_at_y = out2 or look_at_y
		look_at_z = out3 or look_at_z
	end
	event.set_camera_position(64.64, 46.9, 92.64)
	event.set_camera_look_at(-100.0, 20.0, -110.0)
	event.fade_in_screen(15)
	wait.for_frame_count(30)
	if code_result == 0 then
		event.set_character_motion(npc_character, "会話")
		event.open_message_window_2(
			0,
			"う～ん、開かないな。\n困った・・・<page>とても大事な書類が\n入っているんだが。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.fade_out_screen(15)
		wait.for_frame_count(15)
		event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
		event.set_character_position(npc_character, npc_x, npc_y, npc_z)
		event.set_character_rotation(npc_character, npc_rotation_x, npc_rotation_y, npc_rotation_z)
		event.set_camera_position(camera_x, camera_y, camera_z)
		event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
		event.fade_in_screen(15)
		event.finish_event()
		return
	end
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "え・・・と、\n１、<page>２、<page>２、<page>１・・・")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.play_sound_effect(sound_id, 66)
	event.open_message_window_2(0, "うわっ！<page>やった、\n開いたぞ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.attach_object_handle_to_character(0, npc_character)
	event.clear_object_sequence(0, npc_character)
	event.set_object_sequence_object(0, 0)
	event.set_object_sequence_motion(0, "歩き")
	event.turn_object_sequence_toward(0, player_x, player_y, player_z, 30)
	object.wait_until_done(0)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(0, "おお、これで重要な\n書類が取り出せるよ。<page>ありがとう。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.fade_out_screen(15)
	wait.for_frame_count(15)
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	event.set_character_position(npc_character, npc_x, npc_y, npc_z)
	event.set_character_rotation(npc_character, npc_rotation_x, npc_rotation_y, npc_rotation_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	event.fade_in_screen(15)
	wait.for_frame_count(15)
	event.set_character_motion(npc_character, "会話")
	event.open_message_window_2(
		0,
		"重要な書類って\n何かって？<page>私がいない時は、副町長の\nモートンに、町長の仕事を\n代行してもらうための書類だよ。<page>いささか不安ではあるが、\nまぁ、大丈夫だろう。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"よし、これで私もこの町を\n離れられるようになったぞ。<page>話はスターブルから\n聞いている。<page>さぁ、いっしょに\n連れて行ってくれ！"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Plays Lucio refusing to leave until the moon rises and starts the quest 14 request.
function npc.talk_moon_watcher(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "う～ん、いっしょに\n行ってあげても良いけど、\nそこに月はあるの？")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "本当に？言葉だけじゃ\n信じられないよ。人間は\nうそをつくからね。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "やっぱり、やめとく。\nここで月が出るのを\n待っているよ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]過去に何があったのかわかりませんが、\n   ルーシオは、完全に人間を信じられなく\n   なっているようです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]とにかく、信じてもらう事が先決です。\n   そんなに月を見ていたいと言うなら、\n   写真を撮ってあげたらどうでしょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Plays an officer praising the player's legs, with an offer of help in chapter 8.
function npc.talk_officer_praise(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"見かけによらず、なかなかの\n足を持ってるじゃないか。\n見なおしたぞ。"
		)
	else
		event.open_message_window_2(0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Starts the old man's recruitment talk through the recruit handler.
function npc.talk_old_man_recruit_entry(npc_character: s32, player_character: s32)
	party.ask_grandmother_to_join(npc_character, player_character)
end

--- Shows the painter introducing himself to the second character, or greeting the first.
function npc.talk_painter(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk(villager_character, 0, 0)
		event.open_message_window_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"やぁ、ユリス、\nこんにちは。<page>いつも元気そうで\nうらやましいよ。"
	)
	cutscene.talk(villager_character, -1, 0, 0)
end

--- Chooses the priest's dialogue from the state of his request chain.
function npc.talk_priest(villager_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_wisdom_or_peace(villager_character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		party.ask_priest_to_join(villager_character, player_character)
		return
	end
	if request_status == 1 then
		party.recruit_priest_after_puzzle(villager_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_priest(villager_character, player_character)
		return
	end
end

--- Plays a girl nagging Yuris about secret trips outside town, or the Monica variant when Monica is playable.
function npc.talk_secret_outings_nag(npc_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.greet_second_character(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(
		0,
		"ユリス、最近町の外に\n出かけてるんでしょう？<page>隠したってだめよ、\n知ってるんだから。"
	)
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays the maid asking for cloth, copper and leather to sew again and advances the clothing progress counter.
function npc.talk_sewing_materials_request(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"そうですね、もう一度洋服を作ってみて、\n今度こそ完成させられたら、また自分を\n信じる事が出来るかも知れません。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、洋服を作る材料なんて\n持っていません。<page>坊ちゃん、\n用意できないでしょうか？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"服を作るには、『意外と丈夫な布』\n『銅のかたまり』それと\n『ぶあつい皮』があれば充分です。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.finish_event()
	event.set_save_counter(8, 1)
end

--- Chooses the shopkeeper's talk from the quest 0 status and the state of the quest 2 request.
function npc.talk_shopkeeper_by_quest_2(npc_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_closed_shop_keeper(npc_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 2) or quest_status
	if quest_status == 0 then
		party.ask_coin_collector_to_join(npc_character, player_character)
		return
	end
	if quest_status == 1 then
		party.recruit_coin_collector(npc_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.talk_after_quest_2(npc_character, player_character)
		return
	end
end

--- Plays an NPC advising a tinkerer to study the mine as well.
function npc.talk_study_mine_advice(npc_character: s32, player_character: any)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "機械いじりも良いが、\nそろそろ鉱山の事も\n勉強したらどうだ。")
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays Milene setting the sword build-up challenge, gives a Gladius and starts the quest 10 request.
function npc.talk_sword_challenge_giver(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "モニカって\n言ったっけ？<page>あんた、少しは剣が\n使えるらしいな。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"けどな、剣は子供の\n遊び道具じゃないぜ。<page>そんな腕じゃ\n先が思いやられる。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そうだな、剣を２回くらい\nビルドアップ出来たなら、\n腕を認めてやっても良いかな。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "とりあえず、\nこのグラディウスから\n初めてみな。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(44)
	inventory.announce_received(44, 1)
	inventory.resolve_overflow(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Starts the villager conversation unless the triggering character number lies between 100 and 1000.
function npc.talk_to_ordinary_villager()
	local talk_character_number: s32 = 0
	talk_character_number = event.get_triggered_event_data_2(14) or talk_character_number
	if talk_character_number < 100 or 1000 < talk_character_number then
		npc.talk_to_villager()
	end
end

--- Starts the generic villager talk unless the talked-to character id is within the special range 100 to 1000.
function npc.talk_to_regular_villager()
	local talk_npc_id: s32 = 0
	talk_npc_id = event.get_triggered_event_data_2(14) or talk_npc_id
	if talk_npc_id < 100 or 1000 < talk_npc_id then
		message.chat_with_townsperson()
	end
end

--- Starts the story conversation for the triggered character when its id is at most 34, otherwise the regular villager conversation.
function npc.talk_to_triggered_npc()
	local npc_id: s32 = 0
	local villager_character: s32 = 0
	local player_character: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		villager_character = event.get_triggered_event_data_2(13) or villager_character
		player_character = event.get_player_character_slot() or player_character
		if npc_id <= 34 then
			resume_point = 1
			npc.talk_by_npc_id(villager_character, player_character)
		else
			resume_point = 2
			npc.talk_to_regular_villager()
		end
		return
	end, function(received: { any })
		if resume_point <= 2 then
			if resume_point <= 1 then
				npc.resume_talk_end()
			end
			return 0
		end
		return nil
	end)
end

--- Starts the shop conversation for triggered character numbers up to 34 and the villager conversation otherwise, and runs the shop-up finishing sequence when resumed.
function npc.talk_to_triggering_npc()
	local talk_character_number: s32 = 0
	local talk_slot: s32 = 0
	local player_slot: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		talk_character_number = event.get_triggered_event_data_2(14) or talk_character_number
		talk_slot = event.get_triggered_event_data_2(13) or talk_slot
		player_slot = event.get_player_character_slot() or player_slot
		if talk_character_number <= 34 then
			progress_step = 1
			npc.talk_by_npc_id(talk_slot, player_slot)
		else
			progress_step = 2
			npc.talk_to_ordinary_villager()
		end
		return
	end, function(received: { any })
		if progress_step <= 2 then
			if progress_step <= 1 then
				npc.resume_talk_end()
			end
			return 0
		end
		return nil
	end)
end

--- Opens the chapter-dependent small talk of the villager who triggered the event, or the shop greeting for shopkeepers, and resumes the villager's behavior afterwards.
function npc.talk_to_villager()
	local talk_slot: s32 = 0
	local talk_character_number: s32 = 0
	local message_group: s32 = 0
	local message_index: s32 = 0
	local player_variant: s32 = 0
	local playable_character: s32 = 0
	local chapter: s32 = 0
	local train_running_flag: s32 = 0
	local monica_returned_flag: s32 = 0
	local playable_character_61: s32 = 0
	local playable_character_80: s32 = 0
	event.get_player_character_slot()
	talk_slot = event.get_triggered_event_data_2(13) or talk_slot
	talk_character_number = event.get_triggered_event_data_2(14) or talk_character_number
	print("talk_chara_id=", talk_slot, "talk_chara=", talk_character_number, "\n")
	do
		local out1, out2 = event.get_message_window_option(0, 3, talk_character_number)
		message_group = out1 or message_group
		message_index = out2 or message_index
	end
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		player_variant = 2
	else
		player_variant = 1
	end
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, talk_slot)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	if talk_character_number == 1012 or talk_character_number == 1015 or talk_character_number == 1018 then
		npc.open_shop()
		event.set_villager_ai_enabled(1, talk_slot)
		return
	end
	if talk_character_number == 50 then
		event.open_message_window_2(0, "おい、この先は\n立ち入り禁止だ。")
		cutscene.talk(talk_slot, -1, 0, 0)
		event.set_villager_ai_enabled(1, talk_slot)
		return
	end
	chapter = event.get_chapter() or chapter
	if chapter == 1 then
		train_running_flag = event.get_save_flag(9) or train_running_flag
		if talk_character_number == 2 then
			if train_running_flag == 0 then
				event.open_message_window_2(
					0,
					"見てみろよ、こんなでっかい物が\n動いてたなんて、信じられないだろう。\nでもな、昔は本当に動いてたんだぜ。<page>また、こいつに乗って旅するのがオレの夢だ。\nだから、今でも整備にぬかりはねぇ。\n許しが出たら、いつでも動かせるようにな。"
				)
			else
				event.open_message_window_2(
					0,
					"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
				)
			end
			cutscene.talk(talk_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, talk_slot)
			return
		end
		if talk_character_number == 63 then
			if train_running_flag == 0 then
				event.open_message_window_2(
					0,
					"やあ、ユリス。\n鉄道が廃止されて\nどれだけの時間が流れたかのう。<page>私はたとえ、鉄道が動かずとも\nこうやって毎日駅を見回っているのだよ。"
				)
			else
				event.open_message_window_2(
					0,
					"ようやく町長が、重い腰を上げたのじゃな。\n列車は走っているとはいえ、まだまだ\n一般開放できる状態ではない。<page>早く町のみんなを乗せて\nあげたいのじゃが・・・"
				)
			end
			cutscene.talk(talk_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, talk_slot)
			return
		end
		if talk_character_number == 65 then
			if train_running_flag == 0 then
				event.open_message_window_2(
					0,
					"こんにちは、ユリス。\nそこにいる駅長、うちのパパなの。\nこうやって親子で駅を守っているの。<page>いつの日か、鉄道が復活する日まで・・・"
				)
			else
				event.open_message_window_2(
					0,
					"列車が動いたわ！\nだけど、まだ駅が元通りになるのは、\n時間がかかりそうね・・・"
				)
			end
			cutscene.talk(talk_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, talk_slot)
			return
		end
	end
	if chapter == 8 then
		monica_returned_flag = event.get_save_flag(804) or monica_returned_flag
		if talk_character_number == 61 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"おっちゃん、モニカちゃんの\n隠れファンだったんだけど、\n最近モニカちゃんの姿が見えねーな。<page>おかげで、仕事のやる気が出ねーよ。"
				)
			else
				playable_character_61 = event.get_playable_character() or playable_character_61
				if playable_character_61 ~= 1 then
					event.open_message_window_2(
						0,
						"よお、ユリス。\nモニカが帰って来たらしいな。\n町のみんなも喜ぶぞー！"
					)
				else
					event.open_message_window_2(
						0,
						"モニカー！元気だったか？\nおっちゃん、寂しかったよー。"
					)
				end
			end
			cutscene.talk(talk_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, talk_slot)
			return
		end
		if talk_character_number == 80 then
			if monica_returned_flag == 0 then
				event.open_message_window_2(
					0,
					"やっとモニカちゃんと普通に\nしゃべれるようになったのに\n突然いなくなるんだもんな。<page>ユリス、一体モニカちゃん、\nどこに行ったんだ？"
				)
			else
				playable_character_80 = event.get_playable_character() or playable_character_80
				if playable_character_80 ~= 1 then
					event.open_message_window_2(0, "モニカが帰ってきたんだね。\n一体、どうやって？？")
				else
					event.open_message_window_2(0, "モニカ、帰ってきたんだね。\n一体、どうやって？？")
				end
			end
			cutscene.talk(talk_slot, -1, 0, 0)
			event.set_villager_ai_enabled(1, talk_slot)
			return
		end
	end
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	event.open_message_window_2(0, vm.i32(vm.i32(vm.i32(message_group * 10000) + vm.i32(message_index * 10)) + player_variant))
	cutscene.talk(talk_slot, -1, 0, 0)
	event.set_villager_ai_enabled(1, talk_slot)
end

--- Plays an elder welcoming Yuris's friend, with a line about rebuilding the world in chapter 8.
function npc.talk_welcoming_elder(npc_character: s32, player_character: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "ユリスのお友達かな？<page>まぁ、ゆっくりして\n行きなさい。")
	else
		event.open_message_window_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays a priest's saying about wisdom, or a wish for lasting peace in chapter 8 when the late line is enabled.
function npc.talk_wisdom_or_peace(npc_character: s32, player_character: any, use_late_line: s32)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if use_late_line ~= 0 and chapter == 8 then
		event.open_message_window_2(0, "これから先も、永久に世界が\n平和でありますように。")
	else
		event.open_message_window_2(0, "正しき事を成そうとするなら、\n賢くあらねばなりません。")
	end
	cutscene.talk(npc_character, -1, 0, 0)
end

--- Plays Grin's worry about a tree, followed by a hint that he only responds to Yuris.
function npc.talk_worried_about_tree(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

return npc
