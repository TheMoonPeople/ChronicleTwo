--!strict
--- Queries party members and character switching.

local vm = require("@lib/vm")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local minigame = vm.module("@lib/event/minigame")
local npc = vm.module("@lib/event/npc")
local object = vm.module("@lib/event/object")
local wait = vm.module("@lib/event/wait")

local party = {}

--- Marks the character being talked to as a party member and announces that they joined.
function party.add_talked_npc()
	local npc_id: s32 = 0
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 128)
	party.announce_member_joined(npc_id)
end

--- Shows the system message announcing that an NPC joined the party, naming the NPC already in the party.
function party.announce_member_joined(npc_id: s32)
	local message_id: s32 = 0
	local npc_message_number: s32 = 0
	local current_party_npc_id: s32 = 0
	local party_npc_message_number: s32 = 0
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	event.set_message_window_buffer(1, 1, 1)
	npc_message_number = event.get_npc_message_number_3(npc_id, 0) or npc_message_number
	event.set_message_item_system_message(1, 1, npc_message_number)
	current_party_npc_id = event.get_party_npc() or current_party_npc_id
	if true then
		message_id = 50
	else
		party_npc_message_number = event.get_npc_message_number_3(current_party_npc_id, 0) or party_npc_message_number
		event.set_message_item_system_message(1, 2, party_npc_message_number)
		message_id = 51
	end
	message.show(1, message_id, 8, 0, 0)
	event.set_message_window_buffer(1, 1, 0)
end

--- Opens the message announcing that an NPC joined the party.
function party.announce_new_member(npc_id: s32)
	local message_id: s32 = 0
	message.set_window_mode_skipping(1, 4)
	message_id = 50
	message_id = 51
	message.show_and_wait_skipping(1, message_id, 8, 0, 0)
end

--- Opens the message announcing that an NPC joined the party using the second message routines.
function party.announce_new_member_alt(npc_id: s32)
	local message_id: s32 = 0
	message.set_window_mode_stub(1, 4)
	message_id = 50
	message_id = 51
	message.show_and_close(1, message_id, 8, 0, 0)
end

--- Announces a new party member using the second message routines with the default NPC id.
function party.announce_new_member_alt_default()
	local npc_id: s32 = 0
	party.announce_new_member_alt(npc_id)
end

--- Announces a new party member with the default NPC id.
function party.announce_new_member_default()
	local npc_id: s32 = 0
	party.announce_new_member(npc_id)
end

--- Has the baker agree to join, gives the player twenty loaves of bread and starts the delivery request.
function party.ask_baker_to_join(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(0, "私はその間に旅の支度を\nしておくからさ。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.add_inventory_item(300, 20)
	inventory.announce_received(300, 20)
	inventory.resolve_overflow(1)
	event.open_message_window_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Plays Claire's refusal to join the party and starts the flower photo request.
function party.ask_claire_to_join(character_slot: s32, player_slot: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.greet_second_character(character_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"そうね、ユリスの頼みだから聞いて\nあげたいけど、戦うなんて物騒だし\nなんだか汚れちゃいそう。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"何よりみんなの足手まといに\nなるのはいやだわ。悪いけど\nお断りします。ごめんなさい。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"でも、町の外には、\n珍しい物がたくさん\nあるんでしょうね。<page>どんな木が生えてて、\nどんな花が\n咲いてるのかしら。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"ねぇユリス、めずらしい花を\n見つけたら、写真を撮って来て\nちょうだい。ぜひ見てみたいわ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]一度は断られましたが、あきらめるのは早そうです。\n   クレアが興味を持つような写真を見せれば、\n   いっしょに旅をしてくれるかも知れません。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Plays the coin collector's refusal and his request for the two rare coins, or the boy's complaint about the newcomer when the player is the second character.
function party.ask_coin_collector_to_join(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_resent_new_girl(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"聞かなくてもわかるだろう、\nお、こ、と、わ、り、だ。<page>何で俺様が人様の為に\n働かなくちゃいけないんだ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "大してもうかりそうもないし\nおっかないのはごめんだよ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でもなぁ、他ならぬ\nユリスの頼みだし、曲げて\n話を聞いても良いぜ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "でもよ、俺も商人のせがれ、\nもうからない事はやらない\n主義だ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"知ってるだろう、俺が\nコインを集めてるって事。<page>コインは商いの象徴だ。\nなんとしてもコンプリート\nしたいんだ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、『鉄壁のコイン』\n『暗黒のコイン』が\nどうしても手に入らないんだ。<page>なんとかしてくれたら、\n俺もなんとかしてやるぜ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 2, 1)
end

--- Asks the cook whether the pointed chestnuts were found and has him join the party once the player hands them over.
function party.ask_cook_to_join(character_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(0, "『とんがりマロン』は\n手に入りましたか？")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(
			0,
			"やっぱり無理ですか・・・\n仕方ないですね。<page>「カスタニャッチョ」は\nあきらめます。"
		)
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"おお、これです。\nありがとうございます。<page>これで「カスタニャッチョ」を\n作ってみます。<page>出来たら真っ先に坊ちゃんに\n食べていただきますからね。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"そう言えば、\n私に何かご用で？<page>へ、坊ちゃんの冒険に\nついて来いですって。<page>はは、そりゃもちろん\nついて行きますとも。<page>なんで最初にそう言って\n下さらなかったんですか？"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Plays the fisherman's challenge to catch a large fish and starts that request.
function party.ask_fisherman_to_join(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(0, "俺様に頼み事だって？<page>上等だ、聞いて\nやろうじゃねぇか。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"ただし、俺は\n俺が尊敬する奴の\n言う事しか聞かねぇ。<page>俺が尊敬するのは、俺より\nでかい魚を釣った事が\nある奴だけだ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"ちなみに、俺様が釣った中で\n一番でっかいのは、\n６０センチのノンキーだ。<page>どうだ、びびったかい？\n挑戦するなら、いつでも\n受けて立つぜ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]彼を仲間にするには、６０センチ以上のノンキーを\n   釣るしかなさそうです。でも、そんなにいばるほど\n   大きくはないような・・・"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]とりあえず、パームブリンクスの池で\n   釣りをしてみましょう。")
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Plays the gardener's reasons for not leaving and explains the party request tutorial.
function party.ask_gardener_to_join(character_slot: s32, player_slot: s32)
	local playable_character: s32 = 0
	local notebook_count: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_worried_about_tree(character_slot, player_slot)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]グリンをシャーロットに移住させるためには、\n   まず、グリンを冒険に連れ出さねばなりません。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	message.show(0, -1, 8, 0, 0)
	notebook_count = event.get_owned_item_count(386) or notebook_count
	if notebook_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		message.show(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Asks the grandmother to join the party by entering a phrase in the input menu.
function party.ask_grandmother_to_join(character_slot: s32, player_slot: s32)
	local input_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"なんだって？<page>すまないけど、もっとゆっくり\n話してもらえんかね。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_quest_request(0, 19, 1)
	event.set_menu_value(
		0,
		"「いっしょに冒険しよう」と入力してください",
		"いっしょに冒険しよう",
		0
	)
	event.open_event_menu(5)
	vm.wait(3)
	event.fade_in_screen(15)
	do
		local out1, _, _, _ = event.get_menu_results_4()
		input_result = out1 or input_result
	end
	if input_result == -1 then
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	if input_result == 0 then
		event.open_message_window_2(0, "う～ん、何を言ってるのか\nよくわからないねぇ・・・")
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"冒険にかい？\n良いですとも。<page>こんなおいぼれが何の役に\n立つのか知れないけど。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Asks the gun expert to join the party depending on whether the player owns the required item.
function party.ask_gun_expert_to_join(character_slot: s32, player_slot: s32)
	local item_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	item_count = event.get_item_count(25) or item_count
	if item_count <= 0 then
		event.open_message_window_2(
			0,
			"どうした、また\nあきらめるのか？<page>それも良かろう。\n部屋で機械いじりでも\nしていることだ。"
		)
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"ほう、銃の扱いにも\nだいぶ慣れて来たようだな。<page>撃っている姿を見なくても、\n持ち方を見ればわかる。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"そうだな、力を貸してやろう。\nただし、これはおまえのためじゃない。<page>この町に良からぬ事が起きるのであれば、\nだまっているわけにいかないからな。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Plays the mayor's lost safe code story and starts that request.
function party.ask_mayor_to_join(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player_slot, character_slot)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"何ぶつぶつ\n言ってるのかって？<page>金庫の暗証番号を\n思い出してるんだ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"どこの金庫かって？<page>町長室のがくぶちの裏に\n隠してある金庫に\n決まっているだろう・・・"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	character.face_toward(character_slot, player_slot)
	event.set_character_motion(character_slot, "会話")
	event.open_message_window_2(
		0,
		"わぁ、おどかさないで\nくれよ。<page>あ、しまった！<page>町長の最大の秘密を\nしゃべってしまった！<page>でも、ここまで聞かれた\nのならしようがない。<page>たのむ、知恵を貸して\nくれないか。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(0, "困った事に、金庫の\n暗証番号を忘れて\nしまったんだよ。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"４桁の数字なんだが、絶対\n忘れないようにと、クレアの\n誕生日にしておいたんだ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"まさか、それを\n忘れてしまうなんて・・・<page>親として恥ずかしいやら、\n情けないやら。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]町長はとても困っているみたいです。\n   クレアの誕生日にまつわる話を聞いて、\n   そこから暗証番号を推理してみましょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Plays Mina's description of her illness and starts the Sphida clearing request.
function party.ask_mina_to_join(character_slot: s32, player_slot: s32)
	local playable_character: s32 = 0
	local menu_value: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"最近、身体の調子が悪いの。<page>旅なんてとてもじゃないけど\n無理だわ。<page>ダック先生に看て頂いたけど、\n何の問題もないって。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"でも、普通に\n立っているだけでも\n倒れそうになるの。<page>なんて言うのかな、\n世界がゆがんでしまった\nような感じがするのよ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(
			0,
			"う～ん、ダック先生でも\nわからないんじゃ、ボクに\nわかりっこないなぁ・・・"
		)
		message.say_bubble(0, -1, player_slot, character_slot, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "この症状には\n覚えがあるわ。")
	message.say_bubble(0, -1, player_slot, character_slot, 0)
	event.open_message_window_2(
		0,
		"私の生まれた時代では、世界がかなり\n崩壊していて、空間のゆがみも、こことは\n比べ物にならないくらいだったの。"
	)
	message.say_bubble(0, -1, player_slot, character_slot, 0)
	event.open_message_window_2(
		0,
		"そんな世界だったから、特に\n身体の弱い人や神経の細やかな\n人ほど影響をうけていたのね。<page>軽い人はめまいや立ちくらみ、\n重い人だと立っていられなく\nなるくらい。"
	)
	message.say_bubble(0, -1, player_slot, character_slot, 0)
	event.open_message_window_2(
		0,
		"ミーナさんは、特に\nその影響をうけやすい\n体質なのかも。<page>この程度の空間の\nゆがみでも、体調を\n崩すくらいだから。"
	)
	message.say_bubble(0, -1, player_slot, character_slot, 0)
	event.open_message_window_2(
		0,
		"せめて近い場所のゆがみだけでも\n減らせれば、少しは楽にして\nあげられるかも知れないわね。"
	)
	message.say_bubble(0, -1, player_slot, character_slot, 0)
	event.set_character_motion(player_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]時空のゆがみを修復する方法・・・\n   そうです。スフィーダがありますよね。\n   １０ステージくらいクリアすれば、\n   ミーナの体調も良くなるのではないでしょうか。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	menu_value = event.get_menu_value_2(0) or menu_value
	event.set_save_counter(19, menu_value)
	event.set_quest_request(0, 17, 1)
end

--- Asks for the golden paint through the item menu and has the painter join the party when the player hands it over.
function party.ask_painter_to_join(character_slot: s32, player_slot: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(
			0,
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		message.say_bubble(0, -1, character_slot, player_slot, 0)
		event.set_character_motion(character_slot, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	party.add_talked_npc()
	event.set_npc_party_status(22, 130)
	party.announce_member_joined(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Plays the priest's candle puzzle challenge and starts that request.
function party.ask_priest_to_join(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"そうですか、私の力が\n必要ですか。<page>ならば、ひとつ\n問いを出しましょう。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"この教会のロウソクには、\nいささか仕掛けが\nしてありましてね。<page>点いていれば消え、\n消えていれば点く。<page>ひとつが変化すれば、\nその隣り合うロウソクにもまた、\n変化が訪れます。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"うまく全てのロウソクを\n消す事が出来れば、賢者と認め、\n同行いたしましょう。<page>解ければ良し、解けなくば\n力は得られぬと心得なさい。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]これまたよくわからない問題ですね。\n   何回か挑戦してみて、決まりを知る事から\n   始めた方が良さそうです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]教会から外に出てまた入れば、ロウソクは全て\n   元に戻るみたいです。失敗を恐れずやってみましょう。\n   実は正解って、すごく簡単な事かも知れませんよ。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Plays Rene's refusal to join the party and starts the clothes request.
function party.ask_rene_to_join(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]あらら、ルネは完全に自信をなくしている\n   みたいですね。このままではいけません。\n   もう一度、洋服を作ってもらいましょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Plays the baker's chapter-dependent small talk.
function party.chat_with_baker(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"さぁ、ユリス、\n出発しましょう。<page>どこへだって\nついて行きますよ。"
		)
	else
		event.open_message_window_2(0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the book buyer's chapter-dependent small talk.
function party.chat_with_book_buyer(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"落札した本ですか？\n実はまだ読んでないんです。<page>なんだか、手に入った事で、\n満足してしまったようです。"
		)
	else
		event.open_message_window_2(
			0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the official's line that he is too busy to talk.
function party.chat_with_busy_official(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.finish_event()
end

--- Plays the circus performer's chapter-dependent small talk.
function party.chat_with_circus_performer(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"サーカスで見かけたって？\n結構、かっこよかったろう。<page>まぁ、アルバイトと言うか\n趣味みたいなもんかな。"
		)
	else
		event.open_message_window_2(0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays Claire's chapter-dependent small talk and hands over to her greeting of Monica.
function party.chat_with_claire(character_slot: s32, player_slot: s32)
	local chapter: s32 = 0
	local playable_character: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		playable_character = event.get_playable_character() or playable_character
		if playable_character == 1 then
			npc.greet_second_character(character_slot, player_slot)
			return
		end
		event.open_message_window_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.open_message_window_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the grandmother's chapter-dependent small talk.
function party.chat_with_grandmother(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "こんなおばあちゃんでも、\n何かの役に立つのかねぇ。")
	else
		event.open_message_window_2(
			0,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the gun expert's chapter-dependent small talk.
function party.chat_with_gun_expert(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(
			0,
			"銃は子供の\nおもちゃじゃない。<page>扱いに気をつけないと\n怪我をするぞ。"
		)
	else
		event.open_message_window_2(
			0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the moon photo friend's chapter-dependent small talk.
function party.chat_with_moon_photo_friend(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "キミは月の写真をとってくれた。\nキミは良い人間なんだね。")
	else
		event.open_message_window_2(
			0,
			"バース鉄道が世界中に広がったら\nいろんなところにいけるようになるね。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the podium hopeful's chapter-dependent small talk.
function party.chat_with_podium_hopeful(character_slot: s32, player_slot: any)
	local chapter: s32 = 0
	event.apply_message_window_preset(0, 0)
	chapter = event.get_chapter() or chapter
	if chapter ~= 8 then
		event.open_message_window_2(0, "私もいつの日か、\n表彰台の真ん中に\n立ってみたいものです。")
	else
		event.open_message_window_2(
			0,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

--- Plays the priest's chapter-dependent small talk, including the final chapter's prayer for peace.
function party.chat_with_priest(character_slot: s32, player_slot: s32)
	npc.talk_wisdom_or_peace(character_slot, player_slot, 1)
end

--- Restores the view and message windows and ends the event after a talk with an NPC, seating a villager back at their train seat when the talker is a villager.
function party.finish_recruit_talk(character_slot: s32, npc_kind: s32)
	local villager_id: s32 = 0
	event.set_eye_view_map_parts(0)
	event.set_message_window_option(1, 4, -1, -1, -1, -1)
	event.set_message_window_option(1, 9, -1, -1)
	if npc_kind ~= 0 then
		message.close(1)
	else
		event.apply_message_window_preset(1, 3)
	end
	event.finish_event()
	if npc_kind == 0 then
		villager_id = event.get_local_event_counter(character_slot) or villager_id
		character.sit_at_train_seat(character_slot, villager_id)
	end
end

--- Returns 0 for a character; this stands in for reading whether a character can be switched to when events are skipped.
function party.get_change_state_skipping(character_id: s32)
	local state: s32 = 0
	return state
end

--- Plays the scene where the player hands the tailor the three materials for the clothing and the tailor leaves to make it.
function party.give_tailor_materials(villager_character: s32, player_character: s32)
	local leather_count: s32 = 0
	local copper_count: s32 = 0
	local cloth_count: s32 = 0
	local give_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	leather_count = event.get_item_count(214) or leather_count
	copper_count = event.get_item_count(245) or copper_count
	cloth_count = event.get_item_count(227) or cloth_count
	if leather_count <= 0 or copper_count <= 0 or cloth_count <= 0 then
		event.open_message_window_2(
			0,
			"材料がないと服は作れません。<page>『ぶあつい皮』『銅のかたまり』\nそれと『意外と丈夫な布』です。<page>甘えるようですが、\nお願いします。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "これで服を作ってみなよ！\nやっぱり、もったいないや")
	give_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if give_choice ~= 0 then
		event.open_message_window_2(0, "材料がないと服は作れません。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(214)
	event.remove_item(245)
	event.remove_item(227)
	event.set_save_counter(8, 2)
	event.open_message_window_2(
		0,
		"ありがとうございます！\nこれで服を作ってみます。<page>坊ちゃんのお気持ち、\n決してむだにはしません。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_villager_ai_enabled(1, villager_character)
	event.set_character_active(0, villager_character)
	event.delete_villager(villager_character)
	event.finish_event()
	event.fade_in_screen(30)
end

--- Fades out, opens event menu 6 with the given parameter for an NPC, ends the talk and fades back in.
function party.open_npc_menu(character_slot: s32, npc_kind: s32, menu_parameter: s32)
	event.fade_out_screen(25)
	wait.frames(30)
	event.open_event_menu(6, menu_parameter)
	vm.wait(2)
	party.finish_recruit_talk(character_slot, npc_kind)
	event.fade_in_screen(30)
end

--- Fades out, opens event menu 6 with the given parameter for an NPC, ends the talk and fades back in, waiting with the main-script frame wait.
function party.open_npc_menu_primary(character_slot: s32, npc_kind: s32, menu_parameter: s32)
	event.fade_out_screen(25)
	wait.for_frame_count(30)
	event.open_event_menu(6, menu_parameter)
	vm.wait(2)
	party.finish_recruit_talk(character_slot, npc_kind)
	event.fade_in_screen(30)
end

--- Queries the change state of character 1 twice and returns five of its input values unchanged.
function party.query_change_state_twice(value_a: any, value_b: any, value_c: f32, value_d: any, value_e: any, value_f: any, value_g: any)
	local _ = party.get_change_state_skipping(1)
	local _ = party.get_change_state_skipping(1)
	return value_a, value_c, value_d, value_e, value_g
end

--- Reads the boat race stopwatch result and recruits the soldier if the time met his limit, otherwise offers a retry.
function party.recruit_after_boat_race(villager_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local centiseconds: s32 = 0
	local met_time_limit: s32 = 0
	local race_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		centiseconds = out3 or centiseconds
		met_time_limit = out4 or met_time_limit
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	race_state = event.get_save_counter(7) or race_state
	if race_state == 0 then
		event.open_message_window_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		minigame.offer_boat_race(villager_character, player_character)
		return
	end
	if race_state == 1 then
		event.open_message_window_2(
			0,
			"こら、ボートまで行かなかった\nだろう。俺にはお見通しだぞ。\nインチキするな！"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		minigame.offer_boat_race(villager_character, player_character)
		return
	end
	if minutes < 0 then
		event.open_message_window_2(0, "こら、インチキするな！")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		minigame.offer_boat_race(villager_character, player_character)
		return
	end
	event.open_message_window_2(0, "お、戻ってきたな。\nじゃ、タイム発表！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_message_number(0, 1, minutes)
	event.set_message_number(0, 2, seconds)
	event.set_message_number(0, 3, centiseconds)
	if met_time_limit == 0 then
		event.open_message_window_2(0, "おいおい、\n[数値１]分[数値２]秒[数値３]なんて\n遅すぎるぞ。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"また、挑戦するか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		minigame.offer_boat_race(villager_character, player_character)
		return
	end
	event.open_message_window_2(
		0,
		"お、[数値１]分[数値２]秒[数値３]とは\nなかなかのタイムじゃないか。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"見かけによらず、良い足を\nしている。わかった、\nいっしょに悪と戦おう！"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- Plays the scene where the spectator of the fish race refuses to talk or joins the party depending on the race flag.
function party.recruit_after_fish_race(villager_character: s32, player_character: s32)
	local fish_race_flag: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	fish_race_flag = event.get_save_flag(41) or fish_race_flag
	if fish_race_flag == 0 then
		event.open_message_window_2(0, "魚は飼い主に似ると言います。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "あんな弱っちい魚の飼い主と\n話す事なんて、ありません。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"こっそり見てましたよ。\nすばらしいレースでしたね。<page>あそこまで魚を育て上げるなんて、\n私には出来そうもありません。<page>いっしょに連れて行ってください。\nそして、勉強させてください。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Plays the scene where the angler joins the party if the player's best catch reached sixty centimeters.
function party.recruit_after_fishing(villager_character: s32, player_character: s32)
	local best_catch_meters: f32 = 0
	local best_catch_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	best_catch_meters = vm.bits_float(event.get_menu_value(2, 322)) or best_catch_meters
	if best_catch_meters <= 0 then
		event.open_message_window_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	if best_catch_meters < vm.f32(0.6) then
		best_catch_centimeters = vm.ftoi(vm.f32(best_catch_meters * 100.0))
		event.set_message_number(0, 1, best_catch_centimeters)
		event.open_message_window_2(0, "ぷぷっ、[数値１]センチのしか\n釣れてないでやんの。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"そんな腕前で\n俺様を使おうなんて\n１００年早い！<page>顔を洗って\n出直してきやがれ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "・・・お、おみそれしました。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "よし、俺も男だ。\n男に二言はない。<page>約束通り\n言う事を聞くぜ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "さぁ、煮るなり焼くなり\n好きにしやがれ！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Plays the scene where the flower girl joins the party once the player has photographed any of the flower subjects.
function party.recruit_after_flower_photos(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.greet_second_character(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	photo_count_2009 = event.get_photo_count_of_subject(2009) or photo_count_2009
	photo_count_52 = event.get_photo_count_of_subject(52, 3) or photo_count_52
	photo_count_53 = event.get_photo_count_of_subject(53, 3) or photo_count_53
	photo_count_54 = event.get_photo_count_of_subject(54, 3) or photo_count_54
	photo_count_55 = event.get_photo_count_of_subject(55, 3) or photo_count_55
	if vm.i32(vm.i32(vm.i32(vm.i32(photo_count_2009 + photo_count_52) + photo_count_53) + photo_count_54) + photo_count_55) <= 0 then
		event.open_message_window_2(
			0,
			"めずらしい花の写真は\n撮れたのかしら？<page>私もいろいろな花を\n知ってるから、ちょっとや\nそっとじゃおどろかないわよ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Plays the scene where the moon-loving boy joins the party once the player has photographed the moon.
function party.recruit_after_moon_photo(villager_character: s32, player_character: s32)
	local moon_photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	moon_photo_count = event.get_photo_count_of_subject(193) or moon_photo_count
	if moon_photo_count <= 0 then
		event.open_message_window_2(
			0,
			"キミだけは違うような気がしてたんだけど、\nやっぱり人間には変わりないって事だね。<page>でも、いいんだ。人間はうそをつくんだって\nもうなれっこになってるからね。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"わぁ、すごい！まるで\nここにあるみたいだ。<page>これなら、いつでもどこでも\n月を見られるね。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"いっしょに来いって\n言うんでしょ。<page>いいよ。他に\n行く所もないし。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Plays the scene where the ailing girl joins the party once the clear count has risen by ten over its starting value, otherwise complains of ill health.
function party.recruit_ailing_girl(villager_character: s32, player_character: s32)
	local current_clear_count: s32 = 0
	local start_clear_count: s32 = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		resume_point = 1
		cutscene.begin_talk(villager_character, 0, 0)
		current_clear_count = event.get_menu_value_2(0) or current_clear_count
		start_clear_count = event.get_save_counter(19) or start_clear_count
		print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", vm.i32(current_clear_count - start_clear_count), "\n")
		if vm.i32(current_clear_count - start_clear_count) < 10 then
			event.open_message_window_2(0, "まだ体調はすぐれないわ。")
			resume_point = 2
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.open_message_window_2(
				0,
				"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
			)
			resume_point = 3
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.set_character_motion(villager_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
		resume_point = 4
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
		)
		resume_point = 5
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
		)
		resume_point = 6
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		resume_point = 7
		party.add_talked_npc()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if resume_point <= 3 then
			if resume_point <= 1 then
				print("start=", start_clear_count, ",now=", current_clear_count, ",clear=", current_clear_count - start_clear_count, "\n")
				message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
			end
			if resume_point <= 2 then
				message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
			end
			return 0
		end
		if resume_point <= 7 then
			if resume_point <= 4 then
				message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
			end
			if resume_point <= 5 then
				message.say_bubble_skipping(0, -1, villager_character, player_character, 0)
			end
			if resume_point <= 6 then
				party.announce_new_member_default()
			end
			return 0
		end
		return nil
	end)
end

--- Plays the butler's auction scenes that ask the player for money in stages and end with him joining the party.
function party.recruit_auction_butler(villager_character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local give_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	auction_stage = event.get_save_counter(9) or auction_stage
	money = event.get_money() or money
	if auction_stage == 0 then
		if money < 1000 then
			event.open_message_window_2(
				0,
				"坊ちゃん、そんな額では、\nオークションにすら\n出られませんよ。<page>１０００ギルダです。\nしっかりして下さい。"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"坊ちゃん、大変です！<page>値がつり上がって\n１２００ギルダに\nなってしまいました。"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.open_message_window_2(
				0,
				"申し訳ないのですが、\n１５００ギルダ\n用立ててもらえませんか？"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.set_save_counter(9, 1)
		end
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 1 then
		if money < 1500 then
			event.open_message_window_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>１５００ギルダ、\n急いでください。"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
		else
			event.open_message_window_2(
				0,
				"坊ちゃん、最悪です！\n１８００ギルダ出す\n方が現れました。<page>もう、２０００ギルダ\nくらい出さないと\n勝ち目はないです！"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.set_save_counter(9, 2)
		end
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	if auction_stage == 2 then
		if money < 2000 then
			event.open_message_window_2(
				0,
				"坊ちゃん、\nぼやぼやしていると、\n落札されてしまいます。<page>２０００ギルダ、\n急いでください。"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.set_character_motion(villager_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "坊ちゃん、２０００ギルダは\n用意できましたか？")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.set_message_bubble_tail(0, 0)
		event.set_message_selection_top_line(0, 0)
		event.set_message_window_option(0, 0, 1)
		event.open_message_window_2(0, "しょうがない、あげるよ。\nやっぱり、もったいないや。")
		give_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if give_choice ~= 0 then
			event.open_message_window_2(
				0,
				"そうですか・・・やはり２０００ギルダは\n大金ですから、惜しくなってしまうのですね。\nこんなに裕福な坊ちゃんと言えども・・・<page>わかりました。あきらめます！\nでも、オークションはまだ続いています。\n私は待っていますよ、いつまでも・・・"
			)
			message.say_bubble(0, -1, villager_character, player_character, 0)
			event.set_character_motion(villager_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(
			0,
			"あぁ、坊ちゃん、\nありがとうございます。<page>では、急いで\nオークショニアの所へ\n行って来ます！"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.add_money(-2000)
		event.set_save_counter(9, 3)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_villager_ai_enabled(1, villager_character)
		event.set_character_active(0, villager_character)
		event.delete_villager(villager_character)
		event.fade_in_screen(30)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "坊ちゃん、\nありがとうございました。\n無事、落札できました。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"実は強気に出たら、\n相手が早めに降りまして、<page>１４００ギルダで\n落札できてしまいました。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "なので、余った\n６００ギルダは\nお返しします。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.add_money(600)
	event.open_message_window_2(
		0,
		"坊ちゃんからお借りした分は、\nこれからお仕えする事で\n返していきたいと思います。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"私のわがままのために、\n坊ちゃんには苦労をおかけしました。<page>今度は私が\nお力になる番でございます。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Plays the scene where the blade shopkeeper joins the party if the player carries one of two swords.
function party.recruit_blade_shopkeeper_with_sword(villager_character: s32, player_character: s32)
	local first_sword_count: s32 = 0
	local second_sword_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	first_sword_count = event.get_item_count(67) or first_sword_count
	second_sword_count = event.get_item_count(69) or second_sword_count
	if first_sword_count <= 0 and second_sword_count <= 0 then
		event.open_message_window_2(
			0,
			"なんだよ、その剣は？\nけっきょく口だけかい。<page>なら、帰んな。\n商売のじゃまだ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "ほう、なかなかの\n剣じゃないか。<page>試したみたいで\n悪かったな。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "しろうとといっしょに戦うと、\nこっちも危なくなるからね。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、あんたの腕なら\nそんな心配はなさそうだ。<page>わかった、いっしょに\n戦うよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

--- Chooses the busy official's dialogue from the playable character, his position and his quest.
function party.recruit_busy_official(character_slot: s32, player_slot: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local npc_x: f32 = 0
	local npc_z: f32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_town_guard(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_bored_guard(character_slot, player_slot)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(character_slot)
		npc_x = out1 or npc_x
		npc_z = out3 or npc_z
	end
	if npc_x ~= vm.f32(1182.3) or npc_z ~= vm.f32(210.6) then
		party.chat_with_busy_official(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 9) or quest_status
	if quest_status == 0 then
		party.start_boat_race_challenge(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.recruit_after_boat_race(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		npc.talk_officer_praise(character_slot, player_slot)
		return
	end
end

--- Chooses the circus performer's dialogue from the playable character and his quest.
function party.recruit_circus_performer(character_slot: s32, player_slot: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		party.chat_with_circus_performer(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_blade_shop(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		npc.talk_sword_challenge_giver(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.recruit_blade_shopkeeper_with_sword(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		npc.talk_blade_admirer(character_slot, player_slot)
		return
	end
end

--- Plays the scene where the coin collector joins the party after the player hands over the Ironclad and Dark coins.
function party.recruit_coin_collector(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local ironclad_coin_count: s32 = 0
	local dark_coin_count: s32 = 0
	local give_choice: any = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_resent_new_girl(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	ironclad_coin_count = event.get_item_count(201) or ironclad_coin_count
	dark_coin_count = event.get_item_count(202) or dark_coin_count
	if ironclad_coin_count <= 0 or dark_coin_count <= 0 then
		event.open_message_window_2(
			0,
			"なんだよ、あぁ、\nコイン集めの話か？<page>『鉄壁のコイン』\n『暗黒のコイン』だぜ。\nなかなか手に入らないだろう。<page>なんせ俺が探しまくっても\nお目にかかれなかった\nシロモノだからな。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"え？\nコインを集めちまったのか、\nマジでか！<page>なにもったいぶってんだよ、\nくれくれくれー！"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "わかったよ。\nどうしようかな？")
	give_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if give_choice ~= 0 then
		event.open_message_window_2(
			0,
			"あぁ！そんないじわる\nするんなら、俺も仲間に\nなんかならないぜ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(201)
	event.remove_item(202)
	event.open_message_window_2(
		0,
		"すげぇ、本当にそろっちまった。\n絶対無理だと思ってたのに・・・<page>しょうがねぇ、めんどくさいけど\nいっしょに行ってやるよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Plays the scene where the gardener joins the party after the player uses the holy water on his tree.
function party.recruit_gardener_with_holy_water(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local used_item: s32 = 0
	local npc_id: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_worried_about_tree(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"ユリス坊ちゃん。この木を\n治すのがアッシの仕事です。<page>この木を治すためには・・・"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_use_item_menu(276)
	vm.wait(4)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 276 then
		event.open_message_window_2(
			0,
			"坊ちゃん、これじゃあ\nどうにもなりません。<page>やはり、ブルーノさんの\n「聖水」でないと。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"おお！坊ちゃん。これで\nこの木は助かります。<page>ありがとうございます。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"さて、坊ちゃん。これで\nひとまず仕事は済みました。<page>坊ちゃんの冒険に\n同行させてもらいます。<page>あ、それと「聖水」のことは、\nダンナ様にはナイショですよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]グリンが仲間になった。\n   メインメニューの「キャラクター」から\n   「ステータスを見る」で能力が使えます。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]仲間がさらにふえた場合\n   列車の中に乗って、冒険に同行するので\n   話しかけてキャラを切り換えます。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]仲間を他の土地に移住させるためには、\n   建てた家の扉に出るメニューから\n   「移住させる」を選んでください。"
	)
	message.show(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]他にもいろいろな場所に、\n   仲間になってくれる人がいるかも\n   しれません。探してみましょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	npc_id = event.get_triggered_event_data_2(14) or npc_id
	event.set_npc_party_status(npc_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Chooses the grandmother's dialogue from the states of the main request and her quest.
function party.recruit_grandmother(character_slot: s32, player_slot: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_hard_of_hearing(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 19) or quest_status
	if quest_status == 0 then
		party.ask_grandmother_to_join(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		npc.talk_old_man_recruit_entry(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		party.chat_with_grandmother(character_slot, player_slot)
		return
	end
end

--- Chooses Mina's dialogue from a save flag and the state of her quest.
function party.recruit_mina(character_slot: s32, player_slot: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		party.talk_mina_unwell(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 17) or quest_status
	if quest_status == 0 then
		party.ask_mina_to_join(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.recruit_ailing_girl(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		npc.talk_girl_afraid_of_bugs(character_slot, player_slot)
		return
	end
end

--- Chooses the moon photo friend's dialogue from the main request and his quest.
function party.recruit_moon_photo_friend(character_slot: s32, player_slot: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_longing_for_moon(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		npc.talk_moon_watcher(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.recruit_after_moon_photo(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		party.chat_with_moon_photo_friend(character_slot, player_slot)
		return
	end
end

--- Chooses the painter's dialogue from the states of the main request and his quest.
function party.recruit_painter(character_slot: s32, player_slot: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_painter(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 1) or quest_status
	if quest_status == 0 then
		npc.talk_magic_painter(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.ask_painter_to_join(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		npc.talk_magic_painter_done(character_slot, player_slot)
		return
	end
end

--- Chooses the podium hopeful's dialogue from the main request, a save flag and her quest.
function party.recruit_podium_hopeful(character_slot: s32, player_slot: s32)
	local quest_status: s32 = 0
	local story_flag: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	story_flag = event.get_save_flag(424) or story_flag
	if quest_status ~= 2 or story_flag == 0 then
		npc.talk_fabris_pride(character_slot, player_slot)
		return
	end
	quest_status = event.get_quest_request_status(0, 16) or quest_status
	if quest_status == 0 then
		npc.talk_fish_race_request(character_slot, player_slot)
		return
	end
	if quest_status == 1 then
		party.recruit_after_fish_race(character_slot, player_slot)
		return
	end
	if quest_status == 2 then
		party.chat_with_podium_hopeful(character_slot, player_slot)
		return
	end
end

--- Plays the scene where the priest joins the party once no puzzle parts remain visible, otherwise says the time has not come.
function party.recruit_priest_after_puzzle(villager_character: s32, player_character: s32)
	local visible_part_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	visible_part_count = object.count_visible_map_parts()
	if 0 < visible_part_count then
		event.open_message_window_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"よく分かりましたね。\nすばらしい。<page>君なら私の期待にも\n答えてくれることでしょう。<page>約束でしたね。私も\n君と共に行きましょう。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Plays the scene where the tailor hands over the finished clothing and joins the party.
function party.recruit_tailor_after_clothing(villager_character: s32, player_character: s32)
	local clothing_item: s32 = 0
	local owned_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	clothing_item = 259
	owned_count = event.get_item_count(258) or owned_count
	if owned_count <= 0 then
		clothing_item = 258
	else
		owned_count = event.get_item_count(260) or owned_count
		if owned_count <= 0 then
			clothing_item = 260
		end
	end
	event.add_inventory_item(clothing_item)
	inventory.announce_received(clothing_item, 1)
	inventory.resolve_overflow(1)
	event.open_message_window_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	party.add_talked_npc()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Stands in for talk_to_blaster when events are skipped, running only its skip-mode conversation and the skipped recruit dialogue.
function party.skip_talk_to_blaster()
	local character_slot: s32 = 0
	local recruit_character_slot: s32 = 0
	message.set_window_mode_stub(0, 1)
	character.talk_to_skipped_variant(character_slot, -1, 0, 0)
	party.skip_talk_to_recruit(recruit_character_slot, 3)
end

--- Stands in for talk_to_blaster when events are skipped in the main map scripts, running only its skip-mode conversation and the skipped recruit dialogue.
function party.skip_talk_to_blaster_primary()
	local character_slot: s32 = 0
	local recruit_character_slot: s32 = 0
	message.set_window_mode_skipping(0, 1)
	cutscene.talk_skipping_variant(character_slot, -1, 0, 0)
	party.skip_talk_to_recruit(recruit_character_slot, 3)
end

--- Stands in for talk_to_engineer when events are skipped, running only its skip-mode conversation and the skipped recruit dialogue.
function party.skip_talk_to_engineer()
	local character_slot: s32 = 0
	local recruit_character_slot: s32 = 0
	message.set_window_mode_stub(0, 1)
	character.talk_to_skipped_variant(character_slot, -1, 0, 0)
	party.skip_talk_to_recruit(recruit_character_slot, 2)
end

--- Stands in for talk_to_engineer when events are skipped in the main map scripts, running only its skip-mode conversation and the skipped recruit dialogue.
function party.skip_talk_to_engineer_primary()
	local character_slot: s32 = 0
	local recruit_character_slot: s32 = 0
	message.set_window_mode_skipping(0, 1)
	cutscene.talk_skipping_variant(character_slot, -1, 0, 0)
	party.skip_talk_to_recruit(recruit_character_slot, 2)
end

--- Accepts a character slot and NPC kind and does nothing; this stands in for talk_to_recruit when events are skipped.
function party.skip_talk_to_recruit(character_slot: s32, npc_kind: s32) end

--- Stands in for talk_to_waiting_npc when events are skipped, running only its skip-mode conversation.
function party.skip_talk_to_waiting_npc()
	local character_slot: s32 = 0
	message.set_window_mode_stub(0, 1)
	character.talk_to_skipped_variant(character_slot, -1, 0, 0)
end

--- Stands in for talk_to_waiting_npc when events are skipped in the main map scripts, running only its skip-mode conversation.
function party.skip_talk_to_waiting_npc_primary()
	local character_slot: s32 = 0
	message.set_window_mode_skipping(0, 1)
	cutscene.talk_skipping_variant(character_slot, -1, 0, 0)
end

--- Plays the soldier's introduction of the pond boat race challenge and asks whether to take it.
function party.start_boat_race_challenge(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "やぁ、ユリス。私を\n呼びに来たのかい？<page>待っていたよ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"城壁のおかげでこの町は\nとりあえず無事だ。<page>今度は我々が\n打って出る番だ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"しかし、ユリスは\n機械いじりばかりしてるけど、\n体力は大丈夫なんだろうね。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"戦いの基本はスピードと\nフットワークだ。<page>私よりのろまだと\n話にならんよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そうだな、試しに\n池のボートまで行って\n戻って来てみろ。<page>私の記録は２分１秒だ。\nそれ以上かかるようなら\n話にならんね。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_quest_request(0, 9, 1)
	event.open_message_window_2(0, "どうだ、挑戦してみるか？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	minigame.offer_boat_race(villager_character, player_character)
end

--- Plays the villager's challenge to build the Trumpet Gun up into the Belt Trigger and gives the player the Trumpet Gun.
function party.start_gun_upgrade_challenge(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.add_inventory_item(24)
	inventory.announce_received(24, 1)
	inventory.resolve_overflow(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Plays Colin's request to join and begins the hide-and-seek search when the player agrees.
function party.start_hide_and_seek(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local join_choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		event.open_message_window_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.open_message_window_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "わかったよ\nおことわり")
	join_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(villager_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if join_choice ~= 0 then
		event.open_message_window_2(0, "なによ、いじわる！\nけちんぼ！")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"ほんとに連れて\n行ってくれるの？<page>ダメモトでも\n言ってみるものね。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	wait.for_frame_count(30)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_villager_ai_enabled(1, villager_character)
	event.set_character_active(0, villager_character)
	event.delete_villager(villager_character)
	event.fade_in_screen(30)
	wait.for_frame_count(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	message.show(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Plays Mina's lines about feeling unwell without starting any request.
function party.talk_mina_unwell(character_slot: s32, player_slot: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(character_slot, 0, 0)
	event.open_message_window_2(0, "最近、身体の\n調子が悪いの。")
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.open_message_window_2(
		0,
		"ダック先生に診て頂いたけど、\n身体には何の問題もないって。<page>なぜかしら？"
	)
	message.say_bubble(0, -1, character_slot, player_slot, 0)
	event.set_character_motion(character_slot, "立ち")
	event.finish_event()
end

--- Plays the blasting worker's chapter-specific remarks when he is the party NPC, otherwise opens the recruit dialogue for him.
function party.talk_to_blaster()
	local character_slot: s32 = 0
	local party_npc_id: s32 = 0
	local chapter: s32 = 0
	local flag_280: s32 = 0
	local flag_372: s32 = 0
	local flag_448: s32 = 0
	local recruit_character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id == 13 then
		message.set_window_mode(0, 1)
		event.open_message_window_2(
			0,
			"俺は、火薬の匂いが大好きなんだ。\nだから、今の仕事は天職だと思ってる。<page>親方は、頭が固くて古臭くて、\n頑固でわからずやだけどな。"
		)
		chapter = event.get_chapter() or chapter
		flag_280 = event.get_save_flag(280) or flag_280
		if chapter == 2 and flag_280 == 0 then
			event.open_message_window_2(
				0,
				"こんな岩、ファイナルボムなら\n一発で吹っ飛ばせるんだけどなぁ。"
			)
		end
		flag_372 = event.get_save_flag(372) or flag_372
		if chapter == 3 and flag_372 == 0 then
			event.open_message_window_2(
				0,
				"ちびちび削るしかないなんて、\n性に合わない仕事だぜ。<page>でも、下手に爆破して、\n崩れちまったら大変だからな。"
			)
		end
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(
				0,
				"正直言って、俺は何かを作ったり、\n修理したりするのって苦手なんだよな。"
			)
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		recruit_character_slot = event.get_triggered_event_data_2(13) or recruit_character_slot
		party.talk_to_recruit(recruit_character_slot, 3)
	end
end

--- Asks whether to depart when the area's story flags allow it and returns 1 if the player agrees; otherwise plays the elder's remarks when he is the party NPC or opens his recruit dialogue, and returns 0.
function party.talk_to_elder()
	local character_slot: s32 = 0
	local is_departure_ready: s32 = 0
	local map_number: s32 = 0
	local flag_280: s32 = 0
	local flag_283: s32 = 0
	local flag_372: s32 = 0
	local flag_360: s32 = 0
	local flag_448: s32 = 0
	local flag_452: s32 = 0
	local original_angle: f32 = 0
	local player_slot: s32 = 0
	local choice: any = 0
	local party_npc_id: s32 = 0
	local map_number_recheck: s32 = 0
	local flag_300: s32 = 0
	local flag_400: s32 = 0
	local flag_500: s32 = 0
	local recruit_character_slot: s32 = 0
	local resume_step: number = 0
	return vm.guard(function()
		character_slot = event.get_triggered_event_data_2(13) or character_slot
		is_departure_ready = 0
		map_number = event.get_current_map() or map_number
		if map_number == 16 then
			flag_280 = event.get_save_flag(280) or flag_280
			flag_283 = event.get_save_flag(283) or flag_283
			if flag_280 ~= 0 and flag_283 == 0 then
				is_departure_ready = 1
			end
		end
		if map_number == 54 then
			flag_372 = event.get_save_flag(372) or flag_372
			flag_360 = event.get_save_flag(360) or flag_360
			if flag_372 ~= 0 and flag_360 == 0 then
				is_departure_ready = 1
			end
		end
		if map_number == 83 then
			flag_448 = event.get_save_flag(448) or flag_448
			flag_452 = event.get_save_flag(452) or flag_452
			if flag_448 ~= 0 and flag_452 == 0 then
				is_departure_ready = 1
			end
		end
		if is_departure_ready == 1 then
			message.set_window_mode(0, 1)
			resume_step = 1
			original_angle = cutscene.begin_talk(character_slot, 0, 0)
			player_slot = event.get_player_character_slot() or player_slot
			event.open_message_window_2(0, "出発するか？")
			resume_step = 2
			message.say_bubble(0, -1, character_slot, player_slot, 0)
			event.set_character_motion(character_slot, "立ち")
			event.set_message_bubble_tail(0, 0)
			event.set_message_selection_top_line(0, 0)
			event.set_message_window_option(0, 0, 1)
			event.open_message_window_2(0, "うん！\nもう少しここにいるよ。")
			resume_step = 3
			choice = message.ask_choice(0, -1, 5, 256, 208, 2, 0)
			event.set_message_window_option(0, 0, 0)
			event.set_message_bubble_tail(0, 1)
			if choice ~= 0 then
				event.set_character_motion(character_slot, "会話")
				event.open_message_window_2(0, "うむ、しっかりがんばるんじゃぞ。")
				resume_step = 4
				message.say_bubble(0, -1, character_slot, player_slot, 0)
			end
			resume_step = 5
			cutscene.end_talk(character_slot, original_angle, 0, 0)
			if choice == 0 then
				return 1
			else
				return 0
			end
		end
		party_npc_id = event.get_party_npc() or party_npc_id
		if party_npc_id == 1 then
			message.set_window_mode(0, 1)
			event.open_message_window_2(0, "二人とも気をつけてな。")
			map_number_recheck = event.get_current_map() or map_number_recheck
			flag_300 = event.get_save_flag(300) or flag_300
			if map_number_recheck == 16 and flag_300 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			flag_400 = event.get_save_flag(400) or flag_400
			if map_number_recheck == 54 and flag_400 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			flag_500 = event.get_save_flag(500) or flag_500
			if map_number_recheck == 83 and flag_500 == 0 then
				event.open_message_window_2(0, "まだ出発はできんなぁ・・・\nもう少し待ってくれ。")
			end
			resume_step = 6
			cutscene.talk(character_slot, -1, 0, 0)
		else
			recruit_character_slot = event.get_triggered_event_data_2(13) or recruit_character_slot
			resume_step = 7
			party.talk_to_recruit(recruit_character_slot, 1)
		end
		return 0
	end, function(received: { any })
		if resume_step <= 5 then
			if resume_step == 1 then
				original_angle = received[1] :: number
			end
			if resume_step == 3 then
				choice = received[1] :: number
			end
			if resume_step <= 1 then
				message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 2 then
				choice = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 0)
			end
			if resume_step <= 3 then
				message.show_then_close_variant(0, -1, character_slot, player_slot, 0)
			end
			if resume_step <= 4 then
				character.restore_facing_skipping(character_slot, original_angle, 0, 0)
			end
			return 1
		end
		if resume_step <= 7 then
			if resume_step <= 6 then
				party.skip_talk_to_recruit(recruit_character_slot, 1)
			end
			return 0
		end
		return nil
	end)
end

--- Plays the engineer's chapter-specific remarks when he is the party NPC, otherwise opens the recruit dialogue for him.
function party.talk_to_engineer()
	local character_slot: s32 = 0
	local party_npc_id: s32 = 0
	local chapter: s32 = 0
	local flag_448: s32 = 0
	local recruit_character_slot: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	party_npc_id = event.get_party_npc() or party_npc_id
	if party_npc_id == 2 then
		message.set_window_mode(0, 1)
		event.open_message_window_2(0, "オレは常に身体を\n動かしてないと\nイライラするんだ。")
		chapter = event.get_chapter() or chapter
		flag_448 = event.get_save_flag(448) or flag_448
		if chapter == 4 and flag_448 == 0 then
			event.open_message_window_2(
				0,
				"線路や橋がめちゃくちゃじゃねえか。\nひでぇことしやがるぜ、まったく・・・"
			)
		end
		if chapter == 3 then
			event.open_message_window_2(
				0,
				"動かしてない間も整備してたんだけどな、\n実際に動かしてみると、あちこちガタが\n来てやがった。<page>毎日動かしてないと鈍っちまうってのは、\n機械も身体もいっしょだな。"
			)
		end
		cutscene.talk(character_slot, -1, 0, 0)
	else
		recruit_character_slot = event.get_triggered_event_data_2(13) or recruit_character_slot
		party.talk_to_recruit(recruit_character_slot, 2)
	end
end

--- Frames an NPC with the camera and lets the player ask them to join the party, hear a hint or open their menu, returning at once when the NPC is already the party NPC, and restores the scene afterwards.
function party.talk_to_recruit(character_slot: s32, npc_kind: s32)
	local npc_id: s32 = 0
	local party_npc_id: s32 = 0
	local window_x_offset: s32 = 0
	local npc_x: f32 = 0
	local npc_y: f32 = 0
	local npc_z: f32 = 0
	local npc_rotation: f32 = 0
	local seat_id: s32 = 0
	local camera_x: f32 = 0
	local camera_y: f32 = 0
	local camera_z: f32 = 0
	local look_at_x: f32 = 0
	local look_at_y: f32 = 0
	local look_at_z: f32 = 0
	local player_x: f32 = 0
	local player_y: f32 = 0
	local player_z: f32 = 0
	local player_rotation_x: f32 = 0
	local player_rotation_y: f32 = 0
	local player_rotation_z: f32 = 0
	local choice: any = 0
	local message_id: s32 = 0
	local chapter: s32 = 0
	local name_message_id: s32 = 0
	local option_count: s32 = 0
	local party_npc_slot: s32 = 0
	if npc_kind == 1 then
		npc_id = 1
	elseif npc_kind == 2 then
		npc_id = 2
	elseif npc_kind == 3 then
		npc_id = 13
	else
		npc_id = event.get_local_event_counter(character_slot) or npc_id
	end
	party_npc_id = event.get_party_npc() or party_npc_id
	if npc_id == party_npc_id then
		return
	end
	event.set_character_motion(0, "立ち")
	event.initialize_event()
	event.apply_message_window_preset(1, 0)
	window_x_offset = 0
	if npc_id == 10 or npc_id == 18 then
		window_x_offset = 8
	end
	if npc_id == 1 or npc_id == 6 or npc_id == 17 then
		window_x_offset = 16
	end
	if npc_id == 2 or npc_id == 15 or npc_id == 16 or npc_id == 19 or npc_id == 20 or npc_id == 21 or npc_id == 22 then
		window_x_offset = 24
	end
	if npc_id == 3 or npc_id == 4 or npc_id == 5 or npc_id == 7 or npc_id == 8 or npc_id == 23 or npc_id == 24 then
		window_x_offset = 32
	end
	if npc_id == 9 or npc_id == 11 or npc_id == 13 then
		window_x_offset = 40
	end
	event.set_message_window_option(1, 4, 30, 60, 144, -1)
	event.set_message_window_option(1, 9, 20 + window_x_offset, 16)
	event.set_eye_view_map_parts(1)
	if npc_kind ~= 0 then
		event.attach_object_handle_to_character(0, character_slot)
		do
			local out1, out2, out3 = event.get_object_handle_position(0)
			npc_x = out1 or npc_x
			npc_y = out2 or npc_y
			npc_z = out3 or npc_z
		end
		do
			local _, out2, _ = event.get_object_handle_rotation(0)
			npc_rotation = out2 or npc_rotation
		end
	else
		seat_id = event.get_villager_training_value(1, npc_id) or seat_id
		do
			local out1, out2, out3, out4 = event.get_train_seat_position(seat_id)
			npc_x = out1 or npc_x
			npc_y = out2 or npc_y
			npc_z = out3 or npc_z
			npc_rotation = out4 or npc_rotation
		end
		event.attach_object_handle_to_character(0, character_slot)
		event.set_object_handle_position(0, npc_x, npc_y, npc_z)
		event.set_object_handle_rotation(0, 0.0, npc_rotation, 0.0)
		event.set_character_motion(character_slot, "立ち", 4)
	end
	camera_x = vm.f32(vm.sin(npc_rotation) * 75.0)
	camera_x = vm.f32(camera_x + npc_x)
	camera_y = vm.f32(npc_y + 45.0)
	camera_z = vm.f32(vm.cos(npc_rotation) * 75.0)
	camera_z = vm.f32(camera_z + npc_z)
	event.set_camera_position(camera_x, camera_y, camera_z)
	look_at_x = npc_x
	look_at_y = vm.f32(npc_y + 30.0)
	look_at_z = npc_z
	event.set_camera_look_at(look_at_x, look_at_y, look_at_z)
	player_x = vm.f32(vm.sin(npc_rotation) * 30.0)
	player_x = vm.f32(player_x + npc_x)
	player_y = npc_y
	player_z = vm.f32(vm.cos(npc_rotation) * 30.0)
	player_z = vm.f32(player_z + npc_z)
	event.set_character_position(0, player_x, player_y, player_z)
	player_rotation_x = 0
	player_rotation_y = vm.f32(npc_rotation + vm.f32(3.1415927))
	if player_rotation_y > vm.f32(3.1415927) then
		player_rotation_y = vm.f32(player_rotation_y - vm.f32(6.2831855))
	end
	player_rotation_z = 0
	event.set_character_rotation(0, player_rotation_x, player_rotation_y, player_rotation_z)
	vm.wait(1)
	event.start_crossfade(10)
	choice = 0
	while true do
		message.set_window_mode(3, 1)
		chapter = event.get_chapter() or chapter
		if chapter ~= 8 then
			message_id = event.get_npc_message_number_3(npc_id, 2) or message_id
		else
			message.show_villager_remark_variant(3, npc_id)
			message_id = -1
		end
		event.set_message_draw_speed(3, 0, 0)
		message.open(3, message_id, 3, 256, 208)
		message.set_window_mode(1, 8)
		event.set_message_draw_speed(1, 0, 0)
		name_message_id = event.get_npc_message_number_3(npc_id, 0) or name_message_id
		event.set_message_item_system_message(1, 1, name_message_id)
		message.open(1, 1, 1, 0, 0)
		message.set_window_mode(2, 2)
		do
			local out1, out2 = event.get_npc_message_number_4(npc_id, 4)
			message_id = out1 or message_id
			option_count = out2 or option_count
		end
		if option_count == 3 then
			message_id = 30
		end
		if option_count == 4 then
			event.set_message_item_system_message(2, 1, message_id)
			message_id = 31
		end
		if option_count == 5 then
			event.set_message_item_system_message(2, 1, message_id)
			event.set_message_item_system_message(2, 2, vm.i32(message_id + 1))
			message_id = 32
		end
		choice = message.ask_choice(2, message_id, 7, 0, 0, option_count, vm.i32(option_count - 1))
		message.close(3)
		if choice == 0 then
			if party_npc_id ~= 26 then
				event.fade_out_screen(25)
				wait.for_frame_count(30)
				if npc_kind == 0 then
					event.set_character_active(0, character_slot)
					party_npc_slot = event.find_local_event_counter(party_npc_id) or party_npc_slot
					if 0 <= party_npc_slot then
						event.set_character_active(party_npc_slot)
					end
				end
				event.set_npc_party_status(npc_id, 1)
				event.open_party_select_menu()
				vm.wait(4)
				party.finish_recruit_talk(character_slot, npc_kind)
				event.fade_in_screen(30)
				return
			end
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			event.open_message_window_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			message.show(3, -1, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if choice == 1 then
			message.set_window_mode(3, 8)
			event.set_message_draw_speed(3, 0, 0)
			message_id = event.get_npc_message_number_3(npc_id, 3) or message_id
			message.show(3, message_id, 9, 0, 0)
			event.set_message_draw_speed(3, 0, 0.6)
		end
		if 3 < option_count then
			if option_count == 5 then
				if choice == 2 then
					if npc_id == 1 then
						event.set_save_data_value(2)
						event.open_message_window_2(3, "よし、これで\n修理完了じゃ！")
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, npc_kind)
						event.start_crossfade(10)
					end
					if not (npc_id == 4) then
						break
					end
					party.open_npc_menu_primary(character_slot, npc_kind, 6)
					break
				end
				if choice == 3 then
					if npc_id == 1 then
						party.open_npc_menu_primary(character_slot, npc_kind, 23)
						return
					end
					if npc_id == 4 then
						if minigame.report_scoop_progress() ~= 0 then
							party.open_npc_menu_primary(character_slot, npc_kind, 33)
							return
						end
					end
				end
				if choice == 4 then
					break
				end
				if choice == -1 then
					break
				end
			else
				if choice == 2 then
					if npc_id == 15 then
						party.open_npc_menu_primary(character_slot, npc_kind, 0)
					end
					if npc_id == 12 then
						party.open_npc_menu_primary(character_slot, npc_kind, 1)
					end
					if npc_id == 6 then
						party.open_npc_menu_primary(character_slot, npc_kind, 2)
					end
					if npc_id == 7 then
						party.open_npc_menu_primary(character_slot, npc_kind, 3)
					end
					if npc_id == 2 then
						party.open_npc_menu_primary(character_slot, npc_kind, 7)
					end
					if npc_id == 3 then
						party.open_npc_menu_primary(character_slot, npc_kind, 8)
					end
					if npc_id == 5 then
						party.open_npc_menu_primary(character_slot, npc_kind, 9)
					end
					if npc_id == 8 then
						party.open_npc_menu_primary(character_slot, npc_kind, 10)
					end
					if npc_id == 10 then
						party.open_npc_menu_primary(character_slot, npc_kind, 11)
					end
					if npc_id == 11 then
						party.open_npc_menu_primary(character_slot, npc_kind, 12)
					end
					if npc_id == 13 then
						party.open_npc_menu_primary(character_slot, npc_kind, 13)
					end
					if npc_id == 16 then
						party.open_npc_menu_primary(character_slot, npc_kind, 14)
					end
					if npc_id == 18 then
						party.open_npc_menu_primary(character_slot, npc_kind, 15)
					end
					if npc_id == 19 then
						party.open_npc_menu_primary(character_slot, npc_kind, 16)
					end
					if npc_id == 20 then
						party.open_npc_menu_primary(character_slot, npc_kind, 17)
					end
					if npc_id == 21 then
						party.open_npc_menu_primary(character_slot, npc_kind, 18)
					end
					if npc_id == 22 then
						party.open_npc_menu_primary(character_slot, npc_kind, 19)
					end
					if npc_id == 23 then
						party.open_npc_menu_primary(character_slot, npc_kind, 20)
					end
					if npc_id == 24 then
						party.open_npc_menu_primary(character_slot, npc_kind, 21)
					end
					if npc_id == 25 then
						party.open_npc_menu_primary(character_slot, npc_kind, 22)
					end
					if npc_id == 17 then
						party.open_npc_menu_primary(character_slot, npc_kind, 32)
					end
					if npc_id == 9 then
						message.show_story_hint()
						event.set_message_draw_speed(3, 0.6, 0.6)
						message.show(3, -1, 3, 256, 208)
						party.finish_recruit_talk(character_slot, npc_kind)
						event.start_crossfade(10)
					end
					if npc_id == 14 then
						event.fade_out_screen(25)
						wait.for_frame_count(30)
						event.open_event_menu(25)
						vm.wait(35)
						party.finish_recruit_talk(character_slot, npc_kind)
						event.fade_in_screen(30)
					end
					return
				end
				if choice == 3 then
					break
				end
				if choice == -1 then
					break
				end
			end
		else
			if choice == 2 then
				break
			end
			if choice == -1 then
				break
			end
		end
	end
	party.finish_recruit_talk(character_slot, npc_kind)
	event.start_crossfade(10)
end

--- Says the waiting NPC's good-luck line, or a reminder to defeat the griffin once flag 648 is set, then ends the talk.
function party.talk_to_waiting_npc()
	local character_slot: s32 = 0
	local flag_648: s32 = 0
	character_slot = event.get_triggered_event_data_2(13) or character_slot
	message.set_window_mode(0, 1)
	flag_648 = event.get_save_flag(648) or flag_648
	if flag_648 == 0 then
		event.open_message_window_2(0, "オレはここで待ってる。\n幸運を祈ってるぜ！")
	else
		event.open_message_window_2(0, "オレはここで待ってるぜ。\n絶対、グリフォンを倒せよ。")
	end
	cutscene.talk(character_slot, -1, 0, 0)
end

return party
