--!strict
--- Holds the shared helpers of the Girard House scenes: recruiting villagers into the party and the cutscenes played there.

local vm = require("@lib/vm")
local camera = vm.module("@lib/event/camera")
local character = vm.module("@lib/event/character")
local cutscene = vm.module("@lib/event/cutscene")
local inventory = vm.module("@lib/event/inventory")
local message = vm.module("@lib/event/message")
local minigame = vm.module("@lib/event/minigame")
local npc = vm.module("@lib/event/npc")
local object = vm.module("@lib/event/object")
local party = vm.module("@lib/event/party")
local sound = vm.module("@lib/event/sound")
local wait = vm.module("@lib/event/wait")

local i04_girard_house = {}

--- Plays the angler's challenge to catch a fish of at least sixty centimetres and starts his quest request.
function i04_girard_house.angler_challenges_player(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "俺様に頼み事だって？<page>上等だ、聞いて\nやろうじゃねぇか。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"ただし、俺は\n俺が尊敬する奴の\n言う事しか聞かねぇ。<page>俺が尊敬するのは、俺より\nでかい魚を釣った事が\nある奴だけだ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"ちなみに、俺様が釣った中で\n一番でっかいのは、\n６０センチのノンキーだ。<page>どうだ、びびったかい？\n挑戦するなら、いつでも\n受けて立つぜ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]彼を仲間にするには、６０センチ以上のノンキーを\n   釣るしかなさそうです。でも、そんなにいばるほど\n   大きくはないような・・・"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(0, "[(!)]とりあえず、パームブリンクスの池で\n   釣りをしてみましょう。")
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 15, 1)
end

--- Plays the angler's reaction to the player's biggest catch and has him join if it is at least sixty centimetres.
function i04_girard_house.angler_joins_after_big_catch(villager_character: s32, player_character: s32)
	local catch_length_meters: f32 = 0
	local catch_centimeters: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	catch_length_meters = vm.bits_float(event.get_menu_value(2, 322)) or catch_length_meters
	if catch_length_meters <= 0 then
		event.open_message_window_2(
			0,
			"おい、実はノンキーを釣ったこと\nないんじゃないのか？<page>ははーん、さてはオマエ、\n釣りがヘタクソだろう！"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	if catch_length_meters < vm.f32(0.6) then
		catch_centimeters = vm.ftoi(vm.f32(catch_length_meters * 100.0))
		event.set_message_number(0, 1, catch_centimeters)
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 15, 1)
end

--- Has the baker join the party once her progress counter reaches three, exchanging twenty of one bread item for another.
function i04_girard_house.baker_joins_after_progress(villager_character: s32, player_character: s32)
	local progress_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	progress_count = event.get_save_counter(12) or progress_count
	if progress_count < 3 then
		event.open_message_window_2(
			0,
			"まだ、支度が\n出来てないんだよ。<page>もうちょっと\n待っておくれ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "ところで、\nモートンのところへは\n行ってくれたのかい？")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"なんだって！モートンの奴、\n勝手なことばっかり言って。<page>もう、いいわ、\nそのパンは全部あげる。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そんなことより、ユリス、\n出発しましょう。<page>さぁ、どこへだって\nついて行きますよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.remove_item(300, 20)
	event.add_inventory_item(299, 20)
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 8, 1)
end

--- Has Girard give the player a gun and challenge them to build it up to the belt trigger before he joins.
function i04_girard_house.challenge_belt_trigger_build_up(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"スターブルから聞いたぞ、<page>最近、何やらこそこそ\nやっているそうじゃないか。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"おまえは何でも\n器用にこなすが、<page>逆に言うと、何一つ\nやりとげたものが\nないんじゃないのか。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そんなおまえに力を貸せと\n言われても、うかつに\n信じられるわけがない。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そうだな、このラッパガンを\nベルトリガーまで\nビルドアップしてみろ。<page>どうだ、出来るか？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(24)
	inventory.show_obtained_message_for_item_id(24, 1)
	inventory.resolve_overflow(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ジラードに認めてもらうには、ベルトリガーを\n   持って来るしかなさそうです。もらった銃を成長\n   させても良いですし、ダンジョンで見つけても、\n   どこかで買って来ても良いでしょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 11, 1)
end

--- Has Milene give the player a gladius and challenge them to build it up twice before she joins.
function i04_girard_house.challenge_gladius_build_up(npc_character: s32, player_character: s32)
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
	inventory.show_obtained_message_for_item_id(44, 1)
	inventory.resolve_overflow(1)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ミレーネに認めてもらうには、グラディウスを\n   ２段階ビルドアップさせるしかなさそうです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]買ったり、拾ったりしても良いでしょう。\n   とにかく、強い剣を手に入れない限り、\n   ミレーネは仲間になってくれなさそうです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 10, 1)
end

--- Plays Clare's refusal to join and her request for a photo of a rare flower.
function i04_girard_house.clare_asks_for_flower_photo(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.greet_second_character(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"そうね、ユリスの頼みだから聞いて\nあげたいけど、戦うなんて物騒だし\nなんだか汚れちゃいそう。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"何よりみんなの足手まといに\nなるのはいやだわ。悪いけど\nお断りします。ごめんなさい。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、町の外には、\n珍しい物がたくさん\nあるんでしょうね。<page>どんな木が生えてて、\nどんな花が\n咲いてるのかしら。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"ねぇユリス、めずらしい花を\n見つけたら、写真を撮って来て\nちょうだい。ぜひ見てみたいわ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]一度は断られましたが、あきらめるのは早そうです。\n   クレアが興味を持つような写真を見せれば、\n   いっしょに旅をしてくれるかも知れません。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 4, 1)
end

--- Has the coin collector join the party in exchange for the two rare coins.
function i04_girard_house.coin_collector_joins_party(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local ironclad_coin_count: s32 = 0
	local dark_coin_count: s32 = 0
	local give_answer: any = 0
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
	give_answer = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if give_answer ~= 0 then
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 2, 1)
end

--- Has Stewart explain his book auction and the 1000 gilda he needs, then registers the quest.
function i04_girard_house.explain_book_auction_request(npc_character: s32, player_character: s32)
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
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 6, 1)
end

--- Has Mina describe her illness from space distortion, records the current stage-clear count and registers the quest to repair it.
function i04_girard_house.explain_space_distortion_illness(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local stage_clear_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"最近、身体の調子が悪いの。<page>旅なんてとてもじゃないけど\n無理だわ。<page>ダック先生に看て頂いたけど、\n何の問題もないって。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、普通に\n立っているだけでも\n倒れそうになるの。<page>なんて言うのかな、\n世界がゆがんでしまった\nような感じがするのよ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(
			0,
			"う～ん、ダック先生でも\nわからないんじゃ、ボクに\nわかりっこないなぁ・・・"
		)
		message.say_bubble(0, -1, player_character, npc_character, 0)
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "この症状には\n覚えがあるわ。")
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"私の生まれた時代では、世界がかなり\n崩壊していて、空間のゆがみも、こことは\n比べ物にならないくらいだったの。"
	)
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"そんな世界だったから、特に\n身体の弱い人や神経の細やかな\n人ほど影響をうけていたのね。<page>軽い人はめまいや立ちくらみ、\n重い人だと立っていられなく\nなるくらい。"
	)
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"ミーナさんは、特に\nその影響をうけやすい\n体質なのかも。<page>この程度の空間の\nゆがみでも、体調を\n崩すくらいだから。"
	)
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.open_message_window_2(
		0,
		"せめて近い場所のゆがみだけでも\n減らせれば、少しは楽にして\nあげられるかも知れないわね。"
	)
	message.say_bubble(0, -1, player_character, npc_character, 0)
	event.set_character_motion(player_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]時空のゆがみを修復する方法・・・\n   そうです。スフィーダがありますよね。\n   １０ステージくらいクリアすれば、\n   ミーナの体調も良くなるのではないでしょうか。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	stage_clear_count = event.get_menu_value_2(0) or stage_clear_count
	event.set_save_counter(19, stage_clear_count)
	event.set_quest_request(0, 17, 1)
end

--- Plays the fish racer's reaction to the player's race and has him join if the race was run.
function i04_girard_house.fish_racer_joins_party(villager_character: s32, player_character: s32)
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 16, 1)
end

--- Plays Grin's explanation of the sick tree and the quest hints, and starts his quest request.
function i04_girard_house.grin_explains_sick_tree(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local memo_pad_count: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		i04_girard_house.grin_ignores_non_ulis(villager_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"あっ、ユリス坊ちゃん。\n最近、出歩かれることが多いようですが、\nくれぐれも気をつけてくださいよ。<page>それで、アッシに何かご用で？"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "何と！アッシに坊ちゃんの\n冒険について来いと？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"う～む、いっしょに行きたいところなのですが、\nこいつが病気にかかっているようなんです。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"アッシの第一の仕事は、この屋敷の\n木や花たちのお世話をすること。<page>それをほったらかしにして留守になどしたら\nダンナ様に怒られてしまいます。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"教会のブルーノさんが売っている「聖水」なら、\nこの木の病気を治せると思うんですけどね。<page>ダンナ様とブルーノ神父は、坊ちゃんも\n知ってのとおり犬猿の仲。<page>ブルーノさんの聖水を買うと言っても、\nお金はもらえませんし。<page>どうしたものでしょう・・・。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]グリンをシャーロットに移住させるためには、\n   まず、グリンを冒険に連れ出さねばなりません。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]グリンの頼みごとを聞いて、解決してあげることで、\n   グリンを冒険の仲間として、列車に乗せることができます。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]頼まれごと（クエスト）は、アイテムメニュー内にある\n   「メモ帳」で確認することができます。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	memo_pad_count = event.get_owned_item_count(386) or memo_pad_count
	if memo_pad_count <= 0 then
		event.open_message_window_2(
			0,
			"[(!)]おや、メモ帳を持っていないようですね。\n   メモ帳は、メンテナンスショップ奥の\n   テーブルの上に置いてあります。"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.open_message_window_2(
			0,
			"[(!)]ドニーのアジトにも同じような物が\n   落ちています。どちらでも良いので、\n   急いで取りに行きましょう。"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
	end
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 0, 1)
end

--- Plays Grin ignoring the player unless Ulis speaks to him.
function i04_girard_house.grin_ignores_non_ulis(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	event.set_character_motion(player_character, "立ち")
	event.open_message_window_2(0, "この木は・・・イカンな。\nなんとかせねば。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]ユリスが話しかけないと、グリンは\n   取り合ってくれないようです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
end

--- Plays Grin's request for holy water and, when it is given, has him join the party.
function i04_girard_house.grin_joins_after_holy_water(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local used_item: s32 = 0
	local villager_id: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		i04_girard_house.grin_ignores_non_ulis(villager_character, player_character)
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
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]仲間がさらにふえた場合\n   列車の中に乗って、冒険に同行するので\n   話しかけてキャラを切り換えます。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]仲間を他の土地に移住させるためには、\n   建てた家の扉に出るメニューから\n   「移住させる」を選んでください。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]他にもいろいろな場所に、\n   仲間になってくれる人がいるかも\n   しれません。探してみましょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	event.set_npc_party_status(villager_id, 130)
	event.finish_event()
	event.set_quest_request(1, 0, 1)
end

--- Starts the conversation with the villager that triggered the event, falling back to a default handler for other triggers and cleaning up if interrupted.
function i04_girard_house.handle_villager_trigger()
	local npc_id: s32 = 0
	local villager_character: s32 = 0
	local player_character: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		npc_id = event.get_triggered_event_data_2(14) or npc_id
		villager_character = event.get_triggered_event_data_2(13) or villager_character
		player_character = event.get_player_character_slot() or player_character
		if npc_id <= 34 then
			progress_step = 1
			i04_girard_house.talk_to_villager(villager_character, player_character)
		else
			progress_step = 2
			npc.talk_to_regular_villager()
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

--- Plays the hide-and-seek girl being found, hiding again after the first find and joining the party after the second.
function i04_girard_house.hide_and_seek_girl_joins_party(villager_character: s32, player_character: s32)
	local found_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	found_count = event.get_save_counter(11) or found_count
	if found_count < 1 then
		event.open_message_window_2(0, "あはっ、見つかっちゃった！<page>じゃ、次はどうかしら？")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.finish_event()
		event.set_save_counter(11, found_count + 1)
		event.fade_out_screen(30)
		wait.for_frame_count(30)
		event.set_villager_ai_enabled(1, villager_character)
		event.set_character_active(0, villager_character)
		event.delete_villager(villager_character)
		event.fade_in_screen(30)
		return
	end
	event.open_message_window_2(
		0,
		"あぁ、\n見つかっちゃった・・・<page>ふぅ、なんだか\nあきて来ちゃった。<page>なんか、かくれてるのって\n意外とつまんないものね。<page>いいわ、そろそろ冒険に\n出発しましょう！"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 18, 1)
end

--- Plays a villager's boat time trial challenge, judges the player's recorded time and has him join if it is fast enough.
function i04_girard_house.judge_boat_time_trial(villager_character: s32, player_character: s32)
	local minutes: s32 = 0
	local seconds: s32 = 0
	local centiseconds: s32 = 0
	local passed: s32 = 0
	local attempt_state: s32 = 0
	do
		local out1, out2, out3, out4 = event.control_stopwatch_5(1)
		minutes = out1 or minutes
		seconds = out2 or seconds
		centiseconds = out3 or centiseconds
		passed = out4 or passed
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	attempt_state = event.get_save_counter(7) or attempt_state
	if attempt_state == 0 then
		event.open_message_window_2(
			0,
			"やぁ、ユリス。\n挑戦しに来たのか？<page>２分１秒で、ボートまで行って\n戻って来るんだぞ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		minigame.offer_boat_race(villager_character, player_character)
		return
	end
	if attempt_state == 1 then
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
	if passed == 0 then
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 9, 1)
end

--- Plays Lucio's refusal to join and starts his quest request.
function i04_girard_house.lucio_declines_join(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "う～ん、いっしょに\n行ってあげても良いけど、\nそこに月はあるの？")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "本当に？言葉だけじゃ\n信じられないよ。人間は\nうそをつくからね。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "やっぱり、やめとく。\nここで月が出るのを\n待っているよ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]過去に何があったのかわかりませんが、\n   ルーシオは、完全に人間を信じられなく\n   なっているようです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]とにかく、信じてもらう事が先決です。\n   そんなに月を見ていたいと言うなら、\n   写真を撮ってあげたらどうでしょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 14, 1)
end

--- Plays the mayor's request for help recalling his safe code and starts his quest request.
function i04_girard_house.mayor_asks_for_safe_code(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	character.face_toward(player_character, villager_character)
	event.open_message_window_2(0, "ぶつぶつ・・・")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"何ぶつぶつ\n言ってるのかって？<page>金庫の暗証番号を\n思い出してるんだ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"どこの金庫かって？<page>町長室のがくぶちの裏に\n隠してある金庫に\n決まっているだろう・・・"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	character.face_toward(villager_character, player_character)
	event.set_character_motion(villager_character, "会話")
	event.open_message_window_2(
		0,
		"わぁ、おどかさないで\nくれよ。<page>あ、しまった！<page>町長の最大の秘密を\nしゃべってしまった！<page>でも、ここまで聞かれた\nのならしようがない。<page>たのむ、知恵を貸して\nくれないか。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "困った事に、金庫の\n暗証番号を忘れて\nしまったんだよ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"４桁の数字なんだが、絶対\n忘れないようにと、クレアの\n誕生日にしておいたんだ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"まさか、それを\n忘れてしまうなんて・・・<page>親として恥ずかしいやら、\n情けないやら。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]町長はとても困っているみたいです。\n   クレアの誕生日にまつわる話を聞いて、\n   そこから暗証番号を推理してみましょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 12, 1)
end

--- Plays the mayor muttering possible safe codes before the player can help him.
function i04_girard_house.mayor_mutters_safe_code(villager_character: s32, player_character: s32)
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
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
end

--- Plays Patri's greeting, which for Monica only introduces Julia and for Ulis also includes his request for the gold paint.
function i04_girard_house.patri_asks_for_gold_paint(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		event.apply_message_window_preset(0, 0)
		cutscene.begin_talk(villager_character, 0, 0)
		event.open_message_window_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.open_message_window_2(
			0,
			"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
		)
		message.say_bubble(0, -1, villager_character, player_character, 0)
		event.set_character_motion(villager_character, "立ち")
		event.open_message_window_2(0, "・・・")
		message.say_bubble(0, -1, player_character, villager_character, 0)
		event.apply_message_window_preset(0, 4)
		event.set_message_window_mode(0, 4)
		event.open_message_window_2(
			0,
			"[(!)]モニカはこういうタイプが苦手みたい。\n   まぁ、無理ないかも。仕方ありません。\n   ユリスで話しかけてみましょう。"
		)
		message.show_and_wait(0, -1, 8, 0, 0)
		event.apply_message_window_preset(0, 0)
		event.finish_event()
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(0, "やぁ、ユリス、\nこんにちは。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"まだ紹介して\nいなかったね。<page>彼女はジュリア、\n僕の妻になる女性だ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "・・・")
	message.say_bubble(0, -1, player_character, villager_character, 0)
	event.open_message_window_2(
		0,
		"ふっ、おかしいだろう、\n笑ってくれて良いよ。<page>絵の中の女性に惚れて\nしまったなんてさ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でも、僕は魔法絵師だ。\n描いた物を本物にする力がある。<page>僕が描けば、それはそこに\n存在するんだ。それが\n生命のない物なら・・・"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "魔法絵師の力では、\n生命を描く事は\nどうしても出来ないんだ。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(0, "ただ、聞いた事がある。\nいにしえの巨木に宿る\n黄金の卵。")
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そこから得られる金色を\n用いれば、描いた物に\n生命を与えられると。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"なぁ、ユリス、君は\n町の外に出かけている\nそうじゃないか。<page>この『金色の絵の具』\nどこかで手に\n入らないかな？"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"もちろん、ただとは\n言わない。<page>手に入れて来てくれたら、\n僕のこの能力を君のために\n使わせてもらうよ。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]いにしえの巨木・・・\n   金の卵が宿っちゃうような、\n   そんなとんでもない木なんて、\n   どこに行けば生えているんでしょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 1, 1)
end

--- Plays the event 101 dinner cutscene in which Mints argues with Girard and leaves.
function i04_girard_house.play_dinner_argument_scene()
	local saved_time_of_day: f32 = 0
	local sound_bank: s32 = 0
	vm.section(function()
		event.set_save_flag(101, 1)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day(12.0)
		event.initialize_event()
		event.enable_drama_skip()
		event.set_message_window_mode(0, 0)
		event.stop_environment_music()
		event.stop_music(0)
		event.set_character_active(0, 0)
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.load_message_file(0, 5, "event/e100/e101/e101_1.txt")
		event.fade_in_screen(0)
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_sound_reverb_enabled(0)
		i04_girard_house.show_voiced_message(1010005)
		wait.frames(20)
		i04_girard_house.show_voiced_message(1010007)
		vm.wait(4)
		vm.wait(5)
		event.set_sound_reverb_enabled(1)
		event.set_event_sprite_draw_pass(0, 0)
		event.fade_out_screen(0)
		event.load_map_sounds(1804)
		sound_bank = event.load_sound_effect_file_2(1804) or sound_bank
		event.change_directory("event/e100/e101/")
		event.set_message_window_mode(0, 7)
		event.load_character(5, "e101_mints.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.set_object_handle_footstep_sound(0, 2)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.set_object_sequence_position(0, 82.0, 0.0, 0.0)
		event.set_object_sequence_rotation(0, 0.0, -1.57, 0.0)
		event.set_object_sequence_motion(0, "たてひじ座り", 4)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "けだる目")
		event.set_object_sequence_texture_animation(0, 1, "怒り口")
		event.load_character(5, "e101_girard.gltf", "info", 9)
		event.set_character_active(9)
		event.attach_object_handle_to_character(1, 9)
		event.set_object_handle_sound_bank(1, sound_bank)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.set_object_sequence_position(1, -148.0, 0.0, 0.0)
		event.set_object_sequence_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_sequence_motion(1, "食べループ", 4)
		event.set_object_sequence_texture_animation(1, 0)
		event.set_object_sequence_texture_animation(1, 1, "目をつぶる")
		event.set_object_sequence_texture_animation(1, 1, "食べる")
		event.load_character(5, "e101_pork.gltf", "info", 10)
		event.set_character_active(10)
		event.attach_object_handle_to_character(2, 10)
		event.set_object_handle_sound_bank(2, sound_bank)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_position(2, 87.42, 0.0, -62.0)
		event.set_object_sequence_rotation(2, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(2, "立ち", 4)
		event.set_object_sequence_texture_animation(2, 0)
		event.load_character(5, "e101_rene.gltf", "info", 11)
		event.set_character_active(11)
		event.attach_object_handle_to_character(3, 11)
		event.set_object_handle_sound_bank(3, sound_bank)
		event.clear_object_sequence(3)
		event.set_object_sequence_object(3, 3)
		event.set_object_sequence_position(3, 92.0, 0.0, 21.66)
		event.set_object_sequence_rotation(3, 0.0, -2.04, 0.0)
		event.set_object_sequence_motion(3, "立ち", 4)
		event.set_object_sequence_texture_animation(3, 0)
		event.load_character(5, "e101_chair.gltf", "info", 13)
		event.set_character_active(13)
		event.attach_object_handle_to_character(5, 13)
		event.clear_object_sequence(5)
		event.set_object_sequence_object(5, 5)
		event.set_object_sequence_position(5, -5.0, 0.0, 0.0)
		event.set_object_sequence_rotation(5, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(5, "待機", 4)
		event.load_character(5, "e101_door.gltf", "info", 14)
		event.set_character_active(14)
		event.set_scene_status_flags(14, 64)
		event.attach_object_handle_to_character(6, 14)
		event.clear_object_sequence(6)
		event.set_object_sequence_object(6, 6)
		event.set_object_sequence_position(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_rotation(6, 0.0, 0.0, 0.0)
		event.set_object_sequence_motion(6, "待機", 4)
		event.load_character(5, "e101_stuart.gltf", "info", 12)
		event.set_character_active(12)
		event.attach_object_handle_to_character(4, 12)
		event.clear_object_sequence(4)
		event.set_object_sequence_object(4, 4)
		event.set_object_sequence_position(4, -155.82, 0.0, 30.0)
		event.set_object_sequence_rotation(4, 0.0, 2.28, 0.0)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_object_sequence_texture_animation(4, 0)
		event.change_directory("")
		event.attach_object_handle_to_map_part_3(11, "p01_i04h01b", "i04h01b_11-m0")
		event.set_object_handle_visible(11, 0)
		event.attach_object_handle_to_map_part_2(31, "p06_i04h01b")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_2(31, "p04_i04h01b")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_3(31, "p01_i04h01b", "i04h01b_04-m0")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_3(31, "p01_i04h01b", "i04h01b_04-m1")
		event.set_object_handle_visible(31, 0)
		event.attach_object_handle_to_map_part_3(31, "p01_i04h01b", "i04h01b_10-m0")
		event.set_object_handle_visible(31, 1)
		wait.frames(30)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(-214.86, 63.21, -58.86)
		event.set_camera_sequence_look_at(-141.84, 19.73, 0.0)
		event.move_camera_sequence(-46.95, 63.21, -58.86, 26.07, 19.73, 0.0, 160)
		event.slow_down_camera_sequence_position(0.96, 40)
		event.mark_camera_sequence_fade_track()
		event.fade_in_camera_sequence(30)
		camera.wait_until_done()
		wait.frames(30)
		event.set_camera_sequence_position(17.64, 49.88, 36.05)
		event.set_camera_sequence_look_at(83.43, 20.0, -4.7)
		event.set_object_sequence_motion(2, "料理持ち歩き", 6)
		event.queue_object_sequence_next_motion(2, "料理置き", 6)
		event.queue_object_sequence_next_motion(2, "皿置きループ", 4)
		event.move_object_sequence(2, 87.42, 0.0, -49.0, 34)
		event.set_object_sequence_motion(3, "皿置き", 6)
		event.queue_object_sequence_next_motion(3, "皿置き立ち", 4)
		event.set_object_sequence_texture_animation(3, 1, "閉じた目")
		event.set_object_sequence_texture_animation(3, 1, "閉じた口")
		object.wait_until_done(2)
		object.wait_until_done(3)
		event.set_mouth_texture_animations(2, "口パク")
		message.show_voiced(1010010)
		event.reset_mouth_texture_animations()
		event.set_object_sequence_texture_animation(3, 0)
		event.set_camera_sequence_position(60.47, 24.78, 0.0)
		event.set_camera_sequence_look_at(85.9, 24.2, 0.0)
		event.set_object_handle_visible(11, 1)
		event.set_character_active(0, 10)
		event.set_object_sequence_position(3, 139.0, 0.0, 39.86)
		event.set_object_sequence_rotation(3, 0.0, -2.04, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "ため息目")
		event.set_object_sequence_texture_animation(0, 1, "ため息口")
		event.set_object_sequence_motion(0, "ため息", 6)
		event.queue_object_sequence_next_motion(0, "たてひじ座り", 4)
		wait.frames(16)
		event.open_voice_stream_wave(1, 1010015)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		wait.frames(30)
		event.close_voice_stream(1)
		object.wait_until_done(0)
		wait.frames(30)
		event.set_camera_sequence_position(-80.78, 46.58, 17.69)
		event.set_camera_sequence_look_at(-146.75, 20.92, 1.93)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(1010020)
		event.set_camera_sequence_position(47.24, 39.28, 21.08)
		event.set_camera_sequence_look_at(89.08, 20.92, -0.6)
		wait.frames(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "真剣目")
		event.set_object_sequence_motion(0, "姿勢を正す", 6)
		event.queue_object_sequence_next_motion(0, "姿勢を正すL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced(1010030)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.set_camera_sequence_position(87.41, 29.46, 0.0)
		event.set_camera_sequence_look_at(15.12, 20.92, 0.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(1010040)
		event.set_camera_sequence_position(79.19, 21.98, 37.21)
		event.set_camera_sequence_look_at(87.23, 22.33, 0.0)
		event.set_object_sequence_motion(0, "身を乗りだす", 6)
		event.queue_object_sequence_next_motion(0, "身を乗りだすL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced(1010050)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.move_camera_sequence_eased(-134.51, 21.98, 37.21, -146.28, 22.33, 0.0, 120, 0, 0.4)
		camera.wait_until_done()
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(1010060)
		event.set_camera_sequence_position(47.24, 39.28, 21.08)
		event.set_camera_sequence_look_at(89.08, 20.92, -0.6)
		event.set_object_sequence_motion(0, "身を乗りだす戻り", 6)
		event.queue_object_sequence_next_motion(0, "姿勢を正すL", 4)
		event.set_mouth_texture_animations(0, "通常口パク", "真剣口")
		message.show_voiced(1010070)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.set_camera_sequence_position(-102.31, 28.59, 0.0)
		event.set_camera_sequence_look_at(-153.69, 24.83, 0.0)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(1010080)
		event.set_camera_sequence_position(-11.79, 43.33, 0.0)
		event.set_camera_sequence_look_at(85.09, 23.18, 0.0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "怒り目")
		event.set_object_sequence_motion(0, "立ち上がる", 6)
		event.queue_object_sequence_next_motion(0, "立ち上がるL", 4)
		event.set_object_sequence_motion(5, "立ち上がる", 6)
		event.set_object_sequence_motion(3, "驚く", 6)
		event.queue_object_sequence_next_motion(3, "驚くループ", 4)
		event.set_object_sequence_texture_animation(3, 1, "瞬き")
		event.set_object_sequence_texture_animation(3, 1, "開閉口")
		event.play_sound_effect(sound_bank, 6)
		event.set_mouth_texture_animations(0, "通常口パク", "怒り口")
		message.show_voiced(1010090)
		event.reset_mouth_texture_animations()
		object.wait_until_done(0)
		event.open_voice_stream_wave(1, 1010095)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.set_object_sequence_motion(3, "待って", 6)
		event.queue_object_sequence_next_motion(3, "待ってループ", 6)
		event.set_object_sequence_texture_animation(3, 0)
		event.set_object_sequence_texture_animation(3, 1, "デフォルト目")
		event.set_object_sequence_texture_animation(3, 1, "開きっぱなし口")
		event.set_object_sequence_motion(0, "→走り", 6)
		event.queue_object_sequence_next_motion(0, "走り", 4)
		event.rotate_object_sequence(0, 0.0, 1.56, 0.0, 10)
		event.move_object_sequence(0, 111.88, 0.0, 16.89, 10)
		object.wait_until_done(0)
		event.clear_object_sequence_path(0)
		event.set_object_sequence_path_frames(0, 40)
		event.add_object_sequence_path_point(0, 111.88, 0.0, 16.89)
		event.add_object_sequence_path_point(0, 138.16, 0.0, 18.14)
		event.add_object_sequence_path_point(0, 199.13, 2.56, 10.02)
		event.add_object_sequence_path_point(0, 246.27, 11.9, 0.0)
		event.start_object_sequence_path(0)
		object.wait_until_done(0)
		event.set_object_sequence_motion(0, "出て行く", 2)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(6, "出て行く", 2)
		wait.frames(24)
		event.play_sound_effect(sound_bank, 7)
		wait.frames(40)
		event.play_sound_effect(sound_bank, 8)
		object.wait_until_done(0)
		event.close_voice_stream(1)
		event.set_camera_sequence_position(-96.15, 33.86, -18.14)
		event.set_camera_sequence_look_at(-148.11, 23.87, 3.05)
		event.set_object_sequence_motion(4, "驚き", 6)
		event.queue_object_sequence_next_motion(4, "驚きループ", 4)
		event.set_mouth_texture_animations(4, "口パク")
		message.show_voiced(1010100)
		event.open_voice_stream_wave(1, 1010105)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		wait.frames(30)
		event.close_voice_stream(1)
		event.set_object_sequence_motion(4, "屈み", 6)
		event.queue_object_sequence_next_motion(4, "屈みループ", 4)
		event.set_mouth_texture_animations(4, "口パク")
		message.show_voiced(1010110)
		event.set_mouth_texture_animations(1, "通常口パク")
		message.show_voiced(1010120)
		event.set_object_sequence_motion(4, "立ち", 4)
		event.set_camera_sequence_position(119.25, 51.22, 0.0)
		event.set_camera_sequence_look_at(19.04, 39.52, 0.0)
		event.move_camera_sequence(157.82, 52.56, 0.0, 19.04, 39.52, 0.0, 220)
		wait.frames(190)
		event.mark_camera_sequence_fade_track()
		event.fade_out_camera_sequence(30)
		camera.wait_until_done()
	end)
	event.cancel_drama_scene_skip()
	event.set_sound_reverb_enabled(1)
	event.set_event_sprite_draw_pass(0, 0)
	event.set_time_of_day(saved_time_of_day)
	event.stop_port_sound_effects(4)
	event.delete_character(8)
	event.delete_character(9)
	event.delete_character(10)
	event.delete_character(11)
	event.delete_character(12)
	event.delete_character(13)
	event.delete_character(14)
	event.clear_object_sequence(0)
	event.clear_object_sequence(1)
	event.clear_object_sequence(2)
	event.clear_object_sequence(3)
	event.clear_object_sequence(4)
	event.clear_object_sequence(5)
	event.clear_object_sequence(6)
	event.load_message_file(0, -1)
	event.set_character_active(0)
end

--- Plays the event 102 cutscene of Mints and Eina crying, then fades to a loading image.
function i04_girard_house.play_mints_and_eina_crying_scene()
	local saved_time_of_day: f32 = 0
	local image_block: s32 = 0
	vm.section(function()
		event.set_save_flag(102, 1)
		event.initialize_event()
		event.set_message_window_mode(0, 0)
		event.allow_next_music_play()
		event.allow_next_music_load()
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.change_directory("event/e100/e102/")
		event.load_message_file(0, 5, "e102_1.txt")
		event.load_character(5, "e102_minchu.gltf", "info", 32)
		event.set_character_active(32)
		event.attach_object_handle_to_character(0, 32)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.load_character(5, "e102_eina.gltf", "info", 33)
		event.set_character_active(33)
		event.attach_object_handle_to_character(1, 33)
		event.clear_object_sequence(1)
		event.set_object_sequence_object(1, 1)
		event.change_directory("")
		event.reset_event_sprite(0)
		event.set_event_sprite_type(0, 0)
		event.set_event_sprite_color(0, 0, 0, 0, 128)
		event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
		event.set_event_sprite_size(0, 512, 416)
		event.set_event_sprite_position(0, 256, 208)
		event.set_event_sprite_draw_pass(0, 0)
		event.attach_object_handle_to_sprite(2, 0)
		event.clear_object_sequence(2)
		event.set_object_sequence_object(2, 2)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "泣き目")
		event.set_object_sequence_texture_animation(0, 1, "泣き口")
		event.set_character_active(0, 0)
		event.set_object_handle_position(0, 40.0, 0.0, 0.0)
		event.set_object_handle_rotation(0, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(0, "泣く", 4)
		event.set_object_handle_position(1, 40.0, 0.0, 0.0)
		event.set_object_handle_rotation(1, 0.0, 1.57, 0.0)
		event.set_object_handle_motion(1, "泣く", 4)
		event.enable_drama_skip()
		event.set_drama_skip_fade_color(255.0, 255.0, 255.0)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day(12.0)
		event.set_map_lighting(0)
		event.clear_camera_sequence()
		event.set_camera_sequence_position(83.479996, 26.18, -32.23)
		event.set_camera_sequence_look_at(46.18, 11.82, 0.13)
		event.set_event_sprite_draw_pass(0, 1)
		event.fade_in_screen(0)
		event.set_message_window_mode(0, 0)
		i04_girard_house.show_timed_voiced_message(1020010, 120)
		i04_girard_house.show_timed_voiced_message(1020020, 210)
		event.set_message_window_mode(0, 7)
		event.set_message_button_prompt(0, 1)
		event.set_event_sprite_color(0, 255, 255, 255, 32)
		event.fade_out_screen(0)
		event.stop_music(0)
		wait.frames(4)
		event.load_music(58)
		event.play_music(0)
		event.fade_in_screen(30)
		wait.frames(30)
		event.open_voice_stream_wave(1, 1020030)
		sound.wait_voice_stream_ready(1)
		event.play_voice_stream(1)
		event.open_message_window_2(0, 1020030)
		message.show_timed(0, -1, 8, 0, 0, 45)
		event.fade_out_screen(30, 255, 255, 255)
		wait.frames(30)
		event.set_event_sprite_draw_pass(0, 1)
		event.set_event_sprite_color(0, 255, 255, 255, 128)
		event.fade_in_screen(0, 255, 255, 255)
		event.set_message_window_mode(0, 12)
		event.set_message_button_prompt(0, 0)
		event.open_message_window_2(0, 1020040)
		message.show_timed(0, -1, 5, 0, 0, 210)
		event.close_voice_stream(1)
		event.set_message_button_prompt(0, 1)
		vm.wait(9)
		event.fade_out_screen(30, 255, 255, 255)
		event.fade_out_music(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	event.set_background_color(255.0, 255.0, 255.0, 255.0)
	vm.wait(11)
	event.fade_in_screen(0, 255, 255, 255)
	image_block = event.load_event_image_4(5, "textures/event/e100/e102/e102_load02_1.json", 0) or image_block
	event.reset_event_sprite(0)
	event.set_event_sprite_type(0, 0)
	event.set_event_sprite_texture(0, "e102_load02", image_block)
	event.set_event_sprite_color(0, 128, 128, 128, 0)
	event.set_event_sprite_texture_rect(0, 0, 0, 512, 416)
	event.set_event_sprite_size(0, 512, 416)
	event.set_event_sprite_position(0, 256, 208)
	event.set_event_sprite_draw_pass(0, 0)
	event.attach_object_handle_to_sprite(10, 0)
	event.clear_object_sequence(10)
	event.set_object_sequence_object(10, 10)
	event.set_event_sprite_draw_pass(0, 1)
	event.set_object_sequence_color(10, 128.0, 128.0, 128.0, 128.0, 0)
	vm.wait(12)
	event.stop_music(0)
	event.set_message_window_mode(0, 1)
	event.set_character_active(0)
	event.set_map_lighting(0)
	event.set_time_of_day(saved_time_of_day)
	event.delete_character(32)
	event.delete_character(33)
end

--- Plays the event 736 cutscene of Mints writing a letter.
function i04_girard_house.play_mints_letter_scene()
	local sound_bank: s32 = 0
	local saved_time_of_day: f32 = 0
	vm.section(function()
		event.initialize_event()
		event.set_message_window_mode(0, 7)
		event.stop_all_sounds()
		event.load_map_sounds(0)
		sound_bank = event.load_sound_effect_file_2(6244) or sound_bank
		event.assign_memory_stack(5)
		event.clear_memory_stack(5)
		event.set_character_active(0, 0)
		event.change_directory("event/e700/e736/")
		event.load_message_file(0, 5, "e736_1.txt")
		event.load_character(5, "e736_mints2.gltf", "info", 8)
		event.set_character_active(8)
		event.attach_object_handle_to_character(0, 8)
		event.clear_object_sequence(0)
		event.set_object_sequence_object(0, 0)
		event.change_directory("")
		event.attach_object_handle_to_map_part_3(1, "p01_i04h01", "i04h01_06-m0")
		event.attach_object_handle_to_map_part_3(6, "p01_i04h01", "i04h01_07-m0")
		event.set_object_sequence_position(0, 70.93, 0.0, -135.77)
		event.set_object_sequence_rotation(0, 0.0, 3.12, 0.0)
		event.set_object_sequence_motion(0, "手紙書く", 4)
		saved_time_of_day = event.get_scene_time_of_day() or saved_time_of_day
		event.set_time_of_day(24.0)
		event.enable_drama_skip()
		event.set_camera_sequence_look_at(68.06, 28.91, 95.45)
		event.fade_in_screen(30)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "下目パチ")
		event.set_object_handle_visible(1, 1)
		event.set_object_handle_visible(6, 1)
		event.clear_camera_sequence_path()
		event.set_camera_sequence_path_frames(200)
		event.add_camera_sequence_path_point(-58.83, 74.1, -57.22, 65.76, 32.77, -130.49)
		event.add_camera_sequence_path_point(-17.1, 74.1, -81.76, 65.76, 32.77, -130.49)
		event.start_camera_sequence_path()
		message.show_voiced_for(7360270, -1)
		camera.wait_until_done()
		wait.frames(30)
		event.set_camera_sequence_position(96.22, 35.83, -174.85)
		event.set_camera_sequence_look_at(67.95, 23.82, -123.84)
		event.play_sound_effect(sound_bank, 0)
		event.set_object_sequence_motion(0, "手紙書く", 4)
		event.set_object_handle_visible(1, 0)
		event.set_object_handle_visible(6, 0)
		message.show_voiced_for(7360280, -1)
		wait.frames(15)
		message.show_voiced_for(7360290, -1)
		wait.frames(15)
		event.set_object_handle_visible(1, 1)
		event.set_object_handle_visible(6, 1)
		event.set_camera_sequence_position(-58.83, 74.1, -57.22)
		event.set_camera_sequence_look_at(65.76, 32.77, -130.49)
		message.show_voiced_for(7360300, -1)
		wait.frames(15)
		event.set_object_handle_visible(1, 0)
		event.set_object_handle_visible(6, 0)
		event.set_camera_sequence_position(70.85, 28.26, -161.24)
		event.set_camera_sequence_look_at(70.53, 23.82, -123.26)
		event.set_object_sequence_motion(0, "手紙書く", 4)
		event.play_sound_effect(sound_bank, 1)
		message.show_voiced_for(7360310, -1)
		event.wait_object_sequence_motion_end(0)
		event.set_object_sequence_motion(0, "ひとやすみ", 2)
		event.queue_object_sequence_next_motion(0, "ひとやすみL", 4)
		event.delay_object_sequence_texture_animation_track(0, 200)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "前向き～上向き")
		event.delay_object_sequence_sound_track(0, 165)
		event.play_object_sequence_sound(0, sound_bank, 2)
		event.delay_object_sequence_sound_track(0, 210)
		event.play_object_sequence_sound(0, sound_bank, 3)
		message.show_voiced_for(7360320, -1)
		wait.frames(15)
		object.wait_until_done(0)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "上向き～目とじ")
		event.set_object_sequence_texture_animation(0, 1, "口ためいき")
		event.set_object_sequence_motion(0, "ため息", 6)
		event.queue_object_sequence_next_motion(0, "ひとやすみL", 4)
		wait.frames(120)
		event.set_object_sequence_texture_animation(0, 0)
		event.set_object_sequence_texture_animation(0, 1, "デフォルト顔")
		event.set_object_sequence_texture_animation(0, 1, "上向き～目とじ")
		event.set_object_sequence_texture_animation(0, 1, "口あけ～ほほえみ")
		wait.frames(120)
	end)
	event.cancel_drama_scene_skip()
	event.fade_out_screen(60)
	wait.frames(60)
	event.set_time_of_day(saved_time_of_day)
	event.stop_all_sounds()
	event.delete_character(8)
	event.set_object_handle_visible(1, 1)
	event.set_object_handle_visible(6, 1)
	event.load_message_file(0, -1)
	event.set_character_active(0)
	vm.wait(17)
end

--- Plays the cutscene of a character delivering potato pie to a seated character.
function i04_girard_house.play_potato_pie_scene()
	vm.section(function()
		event.initialize_event()
		cutscene.load_e209_actors()
		event.enable_drama_skip()
		event.fade_in_screen(30)
		event.set_character_active(1, 32)
		event.set_character_active(1, 33)
		event.set_character_active(1, 34)
		event.set_character_active(1, 35)
		event.attach_character_to_frame(33, "pie", 34)
		event.attach_character_to_frame(33, "pie", 35)
		event.set_camera_sequence_position(-22.48, 31.6, -71.45)
		event.set_camera_sequence_look_at(74.99, 21.39, -133.6)
		event.set_object_sequence_position(0, 71.93, 0.0, -137.17)
		event.set_object_sequence_rotation(0, 0.0, -3.12, 0.0)
		event.set_object_sequence_position(1, -32.7, 0.0, -81.53)
		event.set_object_sequence_rotation(1, 0.0, 1.92, 0.0)
		event.set_object_sequence_motion(0, "座り", 4)
		event.delay_object_sequence_motion_track(0, 90)
		event.set_object_sequence_motion(0, "左を見る", 6)
		event.queue_object_sequence_next_motion(0, "左を見るL", 0)
		event.set_object_sequence_motion(1, "ポテトパイ歩き", 4)
		event.move_object_sequence(1, 29.44, 0.0, -115.61, 120)
		wait.frames(120)
		event.detach_character_from_frame(34)
		event.detach_character_from_frame(35)
		event.set_character_active(0, 33)
		event.set_character_active(1, 36)
		event.attach_character_to_frame(32, "pie", 36)
		event.set_camera_sequence_position(15.46, 33.35, -97.19)
		event.set_camera_sequence_look_at(39.19, 15.77, -110.22)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_motion(0, "喜ぶ", 6)
		event.queue_object_sequence_next_motion(0, "喜ぶL", 0)
		wait.frames(60)
		event.set_character_active(1, 33)
		event.set_camera_sequence_position(73.92, 10.61, -94.01)
		event.set_camera_sequence_look_at(36.84, 20.8, -109.04)
		event.set_object_sequence_position(0, 45.12, 0.0, -113.39)
		event.set_object_sequence_rotation(0, 0.0, -1.08, 0.0)
		event.set_object_sequence_position(1, 28.93, 0.0, -101.8)
		event.set_object_sequence_rotation(1, 0.0, 2.04, 0.0)
		event.set_object_sequence_motion(0, "食べる", 4)
		event.set_object_sequence_motion(1, "ユリス見立ち", 4)
		event.open_message_window_2(0, 2090590)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(0, 2090591)
		message.show(0, -1, 8, 0, 0)
		event.open_message_window_2(0, 2090592)
		message.show(0, -1, 8, 0, 0)
		event.fade_out_screen(30)
		wait.frames(30)
	end)
	event.cancel_drama_scene_skip()
	cutscene.unload_e209_actors()
	event.fade_in_screen(30)
end

--- Has the priest pose the church candle puzzle and registers the quest.
function i04_girard_house.pose_candle_puzzle(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"そうですか、私の力が\n必要ですか。<page>ならば、ひとつ\n問いを出しましょう。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"この教会のロウソクには、\nいささか仕掛けが\nしてありましてね。<page>点いていれば消え、\n消えていれば点く。<page>ひとつが変化すれば、\nその隣り合うロウソクにもまた、\n変化が訪れます。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"うまく全てのロウソクを\n消す事が出来れば、賢者と認め、\n同行いたしましょう。<page>解ければ良し、解けなくば\n力は得られぬと心得なさい。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]これまたよくわからない問題ですね。\n   何回か挑戦してみて、決まりを知る事から\n   始めた方が良さそうです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.open_message_window_2(
		0,
		"[(!)]教会から外に出てまた入れば、ロウソクは全て\n   元に戻るみたいです。失敗を恐れずやってみましょう。\n   実は正解って、すごく簡単な事かも知れませんよ。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 13, 1)
end

--- Recruits the cook when the player hands over the pointed chestnut item.
function i04_girard_house.recruit_cook_with_chestnut(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "『とんがりマロン』は\n手に入りましたか？")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(301)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 301 then
		event.open_message_window_2(
			0,
			"やっぱり無理ですか・・・\n仕方ないですね。<page>「カスタニャッチョ」は\nあきらめます。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"おお、これです。\nありがとうございます。<page>これで「カスタニャッチョ」を\n作ってみます。<page>出来たら真っ先に坊ちゃんに\n食べていただきますからね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そう言えば、\n私に何かご用で？<page>へ、坊ちゃんの冒険に\nついて来いですって。<page>はは、そりゃもちろん\nついて行きますとも。<page>なんで最初にそう言って\n下さらなかったんですか？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 3, 1)
end

--- Recruits the flower girl when the player has photographed rare flowers.
function i04_girard_house.recruit_flower_girl_with_photos(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local photo_count_2009: s32 = 0
	local photo_count_52: s32 = 0
	local photo_count_53: s32 = 0
	local photo_count_54: s32 = 0
	local photo_count_55: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc.greet_second_character(npc_character, player_character)
		return
	end
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
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
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(0, "めずらしい花の\n写真が撮れたの？\n見せて、見せて！")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"あはっ、すごい、すごい！！\n外にはこんなにすごい花が\n咲いてるのね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "う～ん、\nどうしよう・・・<page>いいわ、私も\n連れて行って！")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 4, 1)
end

--- Has Girard join the party when the player owns the belt trigger gun, otherwise sends the player away.
function i04_girard_house.recruit_girard_with_belt_trigger(npc_character: s32, player_character: s32)
	local gun_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	gun_count = event.get_item_count(25) or gun_count
	if gun_count <= 0 then
		event.open_message_window_2(
			0,
			"どうした、また\nあきらめるのか？<page>それも良かろう。\n部屋で機械いじりでも\nしていることだ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"ほう、銃の扱いにも\nだいぶ慣れて来たようだな。<page>撃っている姿を見なくても、\n持ち方を見ればわかる。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"そうだな、力を貸してやろう。\nただし、これはおまえのためじゃない。<page>この町に良からぬ事が起きるのであれば、\nだまっているわけにいかないからな。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 11, 1)
end

--- Recruits the mayor after the player solves his birthday-clue safe code and opens the safe.
function i04_girard_house.recruit_mayor_with_safe_puzzle(npc_character: s32, player_character: s32)
	local clue_choice: any = 0
	local code_result: s32 = 0
	local safe_sound_id: s32 = 0
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
	local angle_to_npc: f32 = 0
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
		clue_choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
		if clue_choice == 0 then
			break
		else
			if clue_choice == -1 then
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
	safe_sound_id = event.get_sound_id(2) or safe_sound_id
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
	angle_to_npc = event.get_arc_tangent(-100.0 - player_x, -110.0 - player_z) or angle_to_npc
	event.set_character_rotation(0, 0.0, angle_to_npc, 0.0)
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
	event.play_sound_effect(safe_sound_id, 66)
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 12, 1)
end

--- Recruits the boy who loves the moon when the player has photographed it.
function i04_girard_house.recruit_moon_boy_with_photo(npc_character: s32, player_character: s32)
	local photo_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	photo_count = event.get_photo_count_of_subject(193) or photo_count
	if photo_count <= 0 then
		event.open_message_window_2(
			0,
			"キミだけは違うような気がしてたんだけど、\nやっぱり人間には変わりないって事だね。<page>でも、いいんだ。人間はうそをつくんだって\nもうなれっこになってるからね。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"わぁ、すごい！まるで\nここにあるみたいだ。<page>これなら、いつでもどこでも\n月を見られるね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"いっしょに来いって\n言うんでしょ。<page>いいよ。他に\n行く所もないし。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 14, 1)
end

--- Has the old man ask the player to type the invitation phrase and joins the party when it is entered correctly.
function i04_girard_house.recruit_old_man(npc_character: s32, player_character: s32)
	local menu_result: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"なんだって？<page>すまないけど、もっとゆっくり\n話してもらえんかね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
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
		menu_result = out1 or menu_result
	end
	if menu_result == -1 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if menu_result == 0 then
		event.open_message_window_2(0, "う～ん、何を言ってるのか\nよくわからないねぇ・・・")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"冒険にかい？\n良いですとも。<page>こんなおいぼれが何の役に\n立つのか知れないけど。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 19, 1)
end

--- Recruits the painter when the player hands over the gold paint item.
function i04_girard_house.recruit_painter_with_gold_paint(npc_character: s32, player_character: s32)
	local used_item: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"待ちくたびれたよ。<page>さぁ、早く絵に生命を\n宿らせる絵の具をくれ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_use_item_menu(376)
	vm.wait(3)
	used_item = vmhost.used_item() or used_item
	if used_item <= 0 then
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	if used_item ~= 376 then
		event.open_message_window_2(
			0,
			"これは何の冗談なんだい？<page>僕が欲しいのは『金色の絵の具』だ。\n間違えないでくれ。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.remove_item(376)
	event.open_message_window_2(0, "これが『金色の絵の具』か・・・\n早速、使ってみるよ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"は、ははっ、本当に\n本物になった・・・<page>すばらしい、まさに\n完璧な女性だ！"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"ありがとう、ユリス。\n約束だったね。僕のこの能力、\nえんりょなく存分に使ってくれ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.set_npc_party_status(22, 130)
	i04_girard_house.show_join_announcement(22)
	event.finish_event()
	event.set_quest_request(1, 1, 1)
end

--- Has the priest join the party if all church candles are out, otherwise turns the player away.
function i04_girard_house.recruit_priest_after_candle_puzzle(npc_character: s32, player_character: s32)
	local lit_candle_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	lit_candle_count = object.count_visible_map_parts()
	if 0 < lit_candle_count then
		event.open_message_window_2(0, "どうやら、時はまだ\n満ちていないようですね。")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"未来の君には期待していますが、\n今の君に協力する事はできません。"
		)
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"よく分かりましたね。\nすばらしい。<page>君なら私の期待にも\n答えてくれることでしょう。<page>約束でしたね。私も\n君と共に行きましょう。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 13, 1)
end

--- Has Mina join the party once at least ten stages have been cleared since her quest began.
function i04_girard_house.recruit_sick_woman_after_stage_clears(npc_character: s32, player_character: s32)
	local stage_clear_count: s32 = 0
	local start_stage_clear_count: s32 = 0
	local progress_step: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		progress_step = 1
		cutscene.begin_talk(npc_character, 0, 0)
		stage_clear_count = event.get_menu_value_2(0) or stage_clear_count
		start_stage_clear_count = event.get_save_counter(19) or start_stage_clear_count
		print("start=", start_stage_clear_count, ",now=", stage_clear_count, ",clear=", vm.i32(stage_clear_count - start_stage_clear_count), "\n")
		if vm.i32(stage_clear_count - start_stage_clear_count) < 10 then
			event.open_message_window_2(0, "まだ体調はすぐれないわ。")
			progress_step = 2
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.open_message_window_2(
				0,
				"もしかして、\n悪い病気なんじゃ\nないかしら？<page>ダック先生がああ言う\nのも、もう手おくれ\nだからなのかも・・・"
			)
			progress_step = 3
			message.say_bubble(0, -1, npc_character, player_character, 0)
			event.set_character_motion(npc_character, "立ち")
			event.finish_event()
			return
		end
		event.open_message_window_2(0, "こんにちは。<page>身体の調子？\n快調よ！")
		progress_step = 4
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"最近、うそみたいに\n楽になったわ。<page>なんていうか、世界が\nしっかりしてる感じ。"
		)
		progress_step = 5
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(
			0,
			"そう言えば、何か\n頼み事があったのよね。<page>私に出来る事なら\n協力するわ。<page>助けてもらったんだもの。\n助けてあげなきゃね。"
		)
		progress_step = 6
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		progress_step = 7
		i04_girard_house.recruit_triggered_villager()
		event.finish_event()
		event.set_quest_request(1, 17, 1)
		return
	end, function(received: { any })
		if progress_step <= 3 then
			if progress_step <= 1 then
				print("start=", start_stage_clear_count, ",now=", stage_clear_count, ",clear=", stage_clear_count - start_stage_clear_count, "\n")
				message.say_bubble_skipping(0, -1, npc_character, player_character, 0)
			end
			if progress_step <= 2 then
				message.say_bubble_skipping(0, -1, npc_character, player_character, 0)
			end
			return 0
		end
		if progress_step <= 7 then
			if progress_step <= 4 then
				message.say_bubble_skipping(0, -1, npc_character, player_character, 0)
			end
			if progress_step <= 5 then
				message.say_bubble_skipping(0, -1, npc_character, player_character, 0)
			end
			if progress_step <= 6 then
				party.announce_new_member_default()
			end
			return 0
		end
		return nil
	end)
end

--- Has the tailor hand over the finished clothes that the player does not yet own and join the party.
function i04_girard_house.recruit_tailor_after_clothes(npc_character: s32, player_character: s32)
	local clothes_item: s32 = 0
	local owned_count: s32 = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(0, "あ、坊ちゃん。やっと\n洋服が出来ました！")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"頂いた材料をむだにしては\nいけないと思って、最後まで\nがんばる事が出来ました。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "まだまだ満足いく出来じゃ\nないんですけど、\n着て頂けますか？")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	clothes_item = 259
	owned_count = event.get_item_count(258) or owned_count
	if owned_count <= 0 then
		clothes_item = 258
	else
		owned_count = event.get_item_count(260) or owned_count
		if owned_count <= 0 then
			clothes_item = 260
		end
	end
	event.add_inventory_item(clothes_item)
	inventory.show_obtained_message_for_item_id(clothes_item, 1)
	inventory.resolve_overflow(1)
	event.open_message_window_2(
		0,
		"はぁ、何かをやりとげるって\n良い気持ちですね。<page>これで私も\n自分に自信がつきました。<page>私なりに精一杯がんばりますので、\n旅のお供をさせてください。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 7, 1)
end

--- Marks the villager that triggered the event as a party member and announces it.
function i04_girard_house.recruit_triggered_villager()
	local villager_id: s32 = 0
	villager_id = event.get_triggered_event_data_2(14) or villager_id
	event.set_npc_party_status(villager_id, 128)
	i04_girard_house.show_join_announcement(villager_id)
end

--- Plays Rene's refusal to join the party and starts her quest request.
function i04_girard_house.rene_declines_join(villager_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(villager_character, 0, 0)
	event.open_message_window_2(
		0,
		"そうですね・・・坊ちゃんの\nお願いですし、お引き受け\nしたいのはやまやまなんですけど、<page>私、自分に自信がないんです。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"なんでも途中で投げ出してしまって、\n何かをやりとげた事がないんです。<page>小さい頃、洋服屋になるのが夢で、\n自分で何度も作ってみたんですけど、\n一着も完成させられなかったんです。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.open_message_window_2(
		0,
		"こんな私がいっしょにいると、\nきっとめいわくをかけて\nしまうでしょう。<page>だから、ごめんなさい。"
	)
	message.say_bubble(0, -1, villager_character, player_character, 0)
	event.set_character_motion(villager_character, "立ち")
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]あらら、ルネは完全に自信をなくしている\n   みたいですね。このままではいけません。\n   もう一度、洋服を作ってもらいましょう。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 7, 1)
end

--- Repeats the old man's recruitment conversation.
function i04_girard_house.repeat_old_man_request(npc_character: s32, player_character: s32)
	i04_girard_house.recruit_old_man(npc_character, player_character)
end

--- Has the baker ask the player to deliver 20 loaves of bread to Morton's shop, gives them the bread and registers her quest request.
function i04_girard_house.request_bread_delivery(npc_character: s32, player_character: s32)
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	event.open_message_window_2(
		0,
		"いっしょに旅をしてくれって？<page>パンを焼く事しか取り得のない\nおばさんだけど、ユリスの役に\n立つんなら、お安いご用さ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"あ、そうそう、その前に、\nモートンの所に配達する\n物があったんだっけ。<page>ユリス、すまないけど、\nモートンの店にパンを２０個\n届けてくれないかい？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "私はその間に旅の支度を\nしておくからさ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.add_inventory_item(300, 20)
	inventory.show_obtained_message_for_item_id(300, 20)
	inventory.resolve_overflow(1)
	event.open_message_window_2(0, "しかし、２０個のパンなんて\n何に使うんだろう？")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.finish_event()
	event.set_quest_request(0, 8, 1)
	event.set_save_counter(12, 0)
end

--- Has the fish racer demand a win in the beginner fish race before she helps, then registers her quest request.
function i04_girard_house.request_fish_race_victory(npc_character: s32, player_character: s32)
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
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 16, 1)
end

--- Plays the servant's auction bidding requests for money and has him join once the auction is won.
function i04_girard_house.servant_asks_for_auction_money(villager_character: s32, player_character: s32)
	local auction_stage: s32 = 0
	local money: s32 = 0
	local give_answer: any = 0
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
		give_answer = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
		event.set_message_bubble_tail(0, 1)
		event.set_message_window_option(0, 0, 0)
		if give_answer ~= 0 then
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 6, 1)
end

--- Shows or hides the p03_i04h01 map part and enables or disables its function point.
function i04_girard_house.set_map_part_visible(visible: s32)
	event.attach_object_handle_to_map_part_2(0, "p03_i04h01")
	event.set_object_handle_visible(0, visible)
	event.set_function_point_enabled("", "func", visible)
end

--- Shows the system message announcing that the given villager joined the party.
function i04_girard_house.show_join_announcement(villager_id: s32)
	local system_message_index: s32 = 0
	local villager_message_number: s32 = 0
	local party_character: s32 = 0
	local party_message_number: s32 = 0
	event.apply_message_window_preset(1, 4)
	message.set_window_mode(1, 4)
	event.set_message_window_buffer(1, 1, 1)
	villager_message_number = event.get_npc_message_number_3(villager_id, 0) or villager_message_number
	event.set_message_item_system_message(1, 1, villager_message_number)
	party_character = event.get_party_npc() or party_character
	if true then
		system_message_index = 50
	else
		party_message_number = event.get_npc_message_number_3(party_character, 0) or party_message_number
		event.set_message_item_system_message(1, 2, party_message_number)
		system_message_index = 51
	end
	message.show_and_wait(1, system_message_index, 8, 0, 0)
	event.set_message_window_buffer(1, 1, 0)
end

--- Plays a voiced message line and waits for it up to the given duration.
function i04_girard_house.show_timed_voiced_message(message_id: s32, duration_frames: s32)
	event.open_voice_stream_wave(1, message_id)
	sound.wait_voice_stream_ready(1)
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 5, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_for(0, duration_frames)
	message.close(0)
	event.close_voice_stream(1)
end

--- Plays a voiced message line and waits for it to finish.
function i04_girard_house.show_voiced_message(message_id: s32)
	event.open_voice_stream_wave(1, message_id)
	sound.wait_voice_stream_ready(1)
	event.open_message_window_2(0, message_id)
	message.open(0, -1, 5, 0, 0)
	event.play_voice_stream(1)
	message.wait_voice_for(0, -1)
	message.close(0)
	event.close_voice_stream(1)
end

--- Loads villager 24, the hide-and-seek girl, as scene character 28 and registers her as a villager.
function i04_girard_house.spawn_hide_and_seek_girl()
	event.initialize_event()
	event.assign_memory_stack(4)
	event.clear_memory_stack(4)
	event.load_npc_character(0, 4, 24, 28)
	event.set_character_position(28, -69.3, 0.0, 124.6)
	event.set_character_rotation(28, 0.0, 2.97, 0.0)
	event.set_character_motion(28, "立ち", 4)
	event.set_scene_character_number(28, 24)
	event.register_villager(28, 24)
	event.set_character_active(28)
end

--- Has Colin ask to join, then starts a hide-and-seek quest by removing her from town.
function i04_girard_house.start_hide_and_seek(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local choice: any = 0
	event.apply_message_window_preset(0, 0)
	cutscene.begin_talk(npc_character, 0, 0)
	active_character = event.get_playable_character() or active_character
	if active_character == 0 then
		event.open_message_window_2(0, "ねぇねぇ、お兄ちゃんって、\n町の外に出かけてるんでしょ。")
	else
		event.open_message_window_2(0, "ねぇねぇ、お姉ちゃんって、\n町の外に出かけてるんでしょ。")
	end
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "いいなぁ、あたしも\n連れて行ってよ。")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"子供だから役に立たないと\n思ってるでしょう？<page>実はね、私って幸運を呼ぶ\nラッキーガールなのよ。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"お出かけの日に雨だったことないし、\nくじの外れ券なんて見た事ないわ。<page>どうよ？"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	event.set_message_bubble_tail(0, 0)
	event.set_message_selection_top_line(0, 0)
	event.set_message_window_option(0, 0, 1)
	event.open_message_window_2(0, "わかったよ\nおことわり")
	choice = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
	event.set_character_motion(npc_character, "会話")
	event.set_message_bubble_tail(0, 1)
	event.set_message_window_option(0, 0, 0)
	if choice ~= 0 then
		event.open_message_window_2(0, "なによ、いじわる！\nけちんぼ！")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.open_message_window_2(0, "おたんこなす！<page>とうへんぼく！<page>ぼくねんじん！")
		message.say_bubble(0, -1, npc_character, player_character, 0)
		event.set_character_motion(npc_character, "立ち")
		event.finish_event()
		return
	end
	event.open_message_window_2(
		0,
		"ほんとに連れて\n行ってくれるの？<page>ダメモトでも\n言ってみるものね。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(
		0,
		"でもさ、他の人はたのまれてるのに、\nあたしだけ自分からたのむのって\nしゃくだわ。<page>あくまで、たのまれて\n協力してるってことにしないと、\nわたしの女がすたる。"
	)
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "そうね、あたしを見つけたら\n仲間になってあげるってのは\nどう？")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.open_message_window_2(0, "ようするに「かくれんぼ」よ。<page>じゃあ、スタート！")
	message.say_bubble(0, -1, npc_character, player_character, 0)
	event.set_character_motion(npc_character, "立ち")
	wait.for_frame_count(30)
	event.fade_out_screen(30)
	wait.for_frame_count(30)
	event.set_villager_ai_enabled(1, npc_character)
	event.set_character_active(0, npc_character)
	event.delete_villager(npc_character)
	event.fade_in_screen(30)
	wait.for_frame_count(60)
	event.apply_message_window_preset(0, 4)
	event.set_message_window_mode(0, 4)
	event.open_message_window_2(
		0,
		"[(!)]しかたありませんね・・・\n   コリンを探しに行きましょう。\n   パームブリンクスのどこかに\n   かくれているはずです。"
	)
	message.show_and_wait(0, -1, 8, 0, 0)
	event.apply_message_window_preset(0, 0)
	event.finish_event()
	event.set_quest_request(0, 18, 1)
	event.set_save_counter(11, 0)
end

--- Has the swordsman join the party when the player owns a good sword.
function i04_girard_house.swordsman_joins_after_sword_check(villager_character: s32, player_character: s32)
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
	i04_girard_house.recruit_triggered_villager()
	event.finish_event()
	event.set_quest_request(1, 10, 1)
end

--- Talks to the angler according to the state of his quest request.
function i04_girard_house.talk_angler(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_fishing_enthusiast(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 15) or quest_status
	if quest_status == 0 then
		i04_girard_house.angler_challenges_player(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.angler_joins_after_big_catch(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.chat_fishing_tips_request(villager_character, player_character)
		return
	end
end

--- Talks to the auction servant according to the playable character and the state of his quest request.
function i04_girard_house.talk_auction_servant(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.chat_noble_servant(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_offer_help(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 6) or quest_status
	if quest_status == 0 then
		i04_girard_house.explain_book_auction_request(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.servant_asks_for_auction_money(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_book_buyer(villager_character, player_character)
		return
	end
end

--- Dispatches the baker's conversation on the active character and the bread quest state.
function i04_girard_house.talk_baker(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc.chat_baker_to_second_character(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.chat_shopkeeper_advice(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 8) or request_status
	if request_status == 0 then
		i04_girard_house.request_bread_delivery(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.baker_joins_after_progress(npc_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_baker(npc_character, player_character)
		return
	end
end

--- Talks to the boat trial host according to the playable character, his position and the state of his quest request.
function i04_girard_house.talk_boat_trial_host(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	local position_x: f32 = 0
	local position_z: f32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc.chat_town_guard(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_bored_guard(npc_character, player_character)
		return
	end
	do
		local out1, _, out3 = event.get_character_position(npc_character)
		position_x = out1 or position_x
		position_z = out3 or position_z
	end
	if position_x ~= vm.f32(1182.3) or position_z ~= vm.f32(210.6) then
		party.chat_with_busy_official(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 9) or request_status
	if request_status == 0 then
		party.start_boat_race_challenge(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.judge_boat_time_trial(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc.talk_officer_praise(npc_character, player_character)
		return
	end
end

--- Talks to Clare according to the state of her quest request.
function i04_girard_house.talk_clare(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_secret_outings_nag(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 4) or quest_status
	if quest_status == 0 then
		i04_girard_house.clare_asks_for_flower_photo(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.recruit_flower_girl_with_photos(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_claire(villager_character, player_character)
		return
	end
end

--- Talks to the coin collector according to the state of his quest request.
function i04_girard_house.talk_coin_collector(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_closed_shop_keeper(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 2) or request_status
	if request_status == 0 then
		party.ask_coin_collector_to_join(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.coin_collector_joins_party(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc.talk_after_quest_2(npc_character, player_character)
		return
	end
end

--- Dispatches the cook's conversation on the active character and his quest state.
function i04_girard_house.talk_cook(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc.talk_chef_with_monica(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.chat_cooking_invention(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 3) or request_status
	if request_status == 0 then
		npc.talk_chef_chestnut_request(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.recruit_cook_with_chestnut(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc.chat_aspiring_cook(npc_character, player_character)
		return
	end
end

--- Talks to the fish racer according to the race flag and the state of his quest request.
function i04_girard_house.talk_fish_racer(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	local state_flag: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	state_flag = event.get_save_flag(424) or state_flag
	if quest_status ~= 2 or state_flag == 0 then
		npc.talk_fabris_pride(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 16) or quest_status
	if quest_status == 0 then
		i04_girard_house.request_fish_race_victory(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.fish_racer_joins_party(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_podium_hopeful(villager_character, player_character)
		return
	end
end

--- Dispatches Girard's conversation on the active character and his quest state.
function i04_girard_house.talk_girard(npc_character: s32, player_character: s32)
	local active_character: s32 = 0
	local request_status: s32 = 0
	active_character = event.get_playable_character() or active_character
	if active_character == 1 then
		npc.talk_welcoming_elder(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_study_mine_advice(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 11) or request_status
	if request_status == 0 then
		i04_girard_house.challenge_belt_trigger_build_up(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.recruit_girard_with_belt_trigger(npc_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_gun_expert(npc_character, player_character)
		return
	end
end

--- Talks to Grin according to a save flag and the state of his quest request.
function i04_girard_house.talk_grin(npc_character: s32, player_character: s32)
	local save_flag: s32 = 0
	local request_status: s32 = 0
	save_flag = event.get_save_flag(42) or save_flag
	if save_flag == 0 then
		npc.chat_gardener_busy(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status == 0 then
		i04_girard_house.grin_explains_sick_tree(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.grin_joins_after_holy_water(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc.chat_gardener_after_recruit(npc_character, player_character)
		return
	end
end

--- Talks to the hide-and-seek girl according to the state of her quest request.
function i04_girard_house.talk_hide_and_seek_girl(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_child_wants_to_join(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 18) or quest_status
	if quest_status == 0 then
		i04_girard_house.start_hide_and_seek(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.hide_and_seek_girl_joins_party(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.talk_hide_and_seek_girl(villager_character, player_character)
		return
	end
end

--- Talks to Lucio according to the state of his quest request.
function i04_girard_house.talk_lucio(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_longing_for_moon(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 14) or quest_status
	if quest_status == 0 then
		i04_girard_house.lucio_declines_join(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.recruit_moon_boy_with_photo(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		party.chat_with_moon_photo_friend(villager_character, player_character)
		return
	end
end

--- Talks to the mayor according to the state of his quest request.
function i04_girard_house.talk_mayor(villager_character: s32, player_character: s32)
	local quest_status: s32 = 0
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		i04_girard_house.mayor_mutters_safe_code(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 12) or quest_status
	if quest_status == 0 then
		i04_girard_house.mayor_asks_for_safe_code(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.recruit_mayor_with_safe_puzzle(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.chat_sort_garbage(villager_character, player_character)
		return
	end
end

--- Dispatches the old man's conversation on the state of his quest request.
function i04_girard_house.talk_old_man(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.chat_hard_of_hearing(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 19) or request_status
	if request_status == 0 then
		i04_girard_house.recruit_old_man(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.repeat_old_man_request(npc_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_grandmother(npc_character, player_character)
		return
	end
end

--- Dispatches the painter's conversation on the state of the painter quest.
function i04_girard_house.talk_painter(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_painter(npc_character, player_character)
		return
	end
	request_status = event.get_quest_request_status(0, 1) or request_status
	if request_status == 0 then
		i04_girard_house.patri_asks_for_gold_paint(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.recruit_painter_with_gold_paint(npc_character, player_character)
		return
	end
	if request_status == 2 then
		npc.talk_magic_painter_done(npc_character, player_character)
		return
	end
end

--- Dispatches the priest's conversation on the state of the candle puzzle quest.
function i04_girard_house.talk_priest(npc_character: s32, player_character: s32)
	local request_status: s32 = 0
	request_status = event.get_quest_request_status(0, 0) or request_status
	if request_status ~= 2 then
		npc.talk_wisdom_or_peace(npc_character, player_character, 0)
		return
	end
	request_status = event.get_quest_request_status(0, 13) or request_status
	if request_status == 0 then
		i04_girard_house.pose_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 1 then
		i04_girard_house.recruit_priest_after_candle_puzzle(npc_character, player_character)
		return
	end
	if request_status == 2 then
		party.chat_with_priest(npc_character, player_character)
		return
	end
end

--- Talks to the villager of quest request 17 according to its state.
function i04_girard_house.talk_quest_17_villager(villager_character: s32, player_character: s32)
	local story_flag: s32 = 0
	local quest_status: s32 = 0
	story_flag = event.get_save_flag(314) or story_flag
	if story_flag == 0 then
		party.talk_mina_unwell(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 17) or quest_status
	if quest_status == 0 then
		i04_girard_house.explain_space_distortion_illness(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.recruit_sick_woman_after_stage_clears(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.talk_girl_afraid_of_bugs(villager_character, player_character)
		return
	end
end

--- Talks to Rene according to the playable character and the state of her quest request.
function i04_girard_house.talk_rene(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	local reminder_stage: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 1 then
		npc.talk_maid_protective(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.talk_maid_clothing_dream(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 7) or quest_status
	if quest_status == 0 then
		i04_girard_house.rene_declines_join(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		reminder_stage = event.get_save_counter(8) or reminder_stage
		if reminder_stage == 0 then
			npc.talk_sewing_materials_request(villager_character, player_character)
		end
		if reminder_stage == 1 then
			party.give_tailor_materials(villager_character, player_character)
		end
		if reminder_stage == 2 then
			i04_girard_house.recruit_tailor_after_clothes(villager_character, player_character)
		end
		return
	end
	if quest_status == 2 then
		npc.talk_maid_clothing_fit(villager_character, player_character)
		return
	end
end

--- Talks to the swordsman according to the playable character and the state of his quest request.
function i04_girard_house.talk_swordsman(villager_character: s32, player_character: s32)
	local playable_character: s32 = 0
	local quest_status: s32 = 0
	playable_character = event.get_playable_character() or playable_character
	if playable_character == 0 then
		party.chat_with_circus_performer(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 0) or quest_status
	if quest_status ~= 2 then
		npc.chat_blade_shop(villager_character, player_character)
		return
	end
	quest_status = event.get_quest_request_status(0, 10) or quest_status
	if quest_status == 0 then
		i04_girard_house.challenge_gladius_build_up(villager_character, player_character)
		return
	end
	if quest_status == 1 then
		i04_girard_house.swordsman_joins_after_sword_check(villager_character, player_character)
		return
	end
	if quest_status == 2 then
		npc.talk_blade_admirer(villager_character, player_character)
		return
	end
end

--- Runs the conversation with the villager that was talked to, dispatching on its villager id and offering to recruit it when the party quest allows.
function i04_girard_house.talk_to_villager(villager_character: s32, player_character: s32)
	local chapter: s32 = 0
	local villager_id: s32 = 0
	local submap: s32 = 0
	local state_flag: s32 = 0
	local intro_quest_status_12: s32 = 0
	local quest_8_status: s32 = 0
	local recruit_answer_12: any = 0
	local intro_quest_status_15: s32 = 0
	local quest_10_status: s32 = 0
	local recruit_answer_15: any = 0
	local intro_quest_status_18: s32 = 0
	local quest_13_status: s32 = 0
	local recruit_answer_18: any = 0
	local shop_quest_8_status: s32 = 0
	local playable_character: s32 = 0
	local shop_answer: any = 0
	local resume_point: number = 0
	return vm.guard(function()
		event.apply_message_window_preset(0, 0)
		event.set_message_bubble_tail(0, 1)
		chapter = event.get_chapter() or chapter
		villager_id = event.get_triggered_event_data_2(14) or villager_id
		event.get_current_map()
		submap = event.get_current_submap() or submap
		event.stop_camera_control_movement()
		event.set_villager_ai_enabled(0, villager_character)
		if villager_id == 3 then
			resume_point = 1
			i04_girard_house.talk_grin(villager_character, player_character)
		end
		if villager_id == 5 then
			resume_point = 2
			i04_girard_house.talk_painter(villager_character, player_character)
		end
		if villager_id == 4 then
			state_flag = event.get_save_flag(104) or state_flag
			if state_flag == 0 then
				resume_point = 3
				npc.open_shop()
			else
				resume_point = 4
				i04_girard_house.talk_coin_collector(villager_character, player_character)
			end
		end
		if villager_id == 7 then
			resume_point = 5
			i04_girard_house.talk_cook(villager_character, player_character)
		end
		if villager_id == 8 then
			resume_point = 6
			i04_girard_house.talk_clare(villager_character, player_character)
		end
		if villager_id == 10 then
			resume_point = 7
			i04_girard_house.talk_auction_servant(villager_character, player_character)
		end
		if villager_id == 11 then
			resume_point = 8
			i04_girard_house.talk_rene(villager_character, player_character)
		end
		if villager_id == 12 then
			intro_quest_status_12 = event.get_quest_request_status(0, 0) or intro_quest_status_12
			quest_8_status = event.get_quest_request_status(0, 8) or quest_8_status
			if intro_quest_status_12 == 2 and quest_8_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 9
				recruit_answer_12 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if recruit_answer_12 < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if recruit_answer_12 == 1 then
					resume_point = 10
					i04_girard_house.talk_baker(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap == 28 then
				resume_point = 11
				npc.open_shop()
			else
				resume_point = 12
				i04_girard_house.talk_baker(villager_character, player_character)
			end
		end
		if villager_id == 14 then
			resume_point = 13
			i04_girard_house.talk_boat_trial_host(villager_character, player_character)
		end
		if villager_id == 15 then
			intro_quest_status_15 = event.get_quest_request_status(0, 0) or intro_quest_status_15
			quest_10_status = event.get_quest_request_status(0, 10) or quest_10_status
			if intro_quest_status_15 == 2 and quest_10_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 14
				recruit_answer_15 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if recruit_answer_15 < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if recruit_answer_15 == 1 then
					resume_point = 15
					i04_girard_house.talk_swordsman(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap == 30 then
				resume_point = 16
				npc.open_shop()
			else
				resume_point = 17
				i04_girard_house.talk_swordsman(villager_character, player_character)
			end
		end
		if villager_id == 16 then
			resume_point = 18
			i04_girard_house.talk_girard(villager_character, player_character)
		end
		if villager_id == 17 then
			resume_point = 19
			i04_girard_house.talk_mayor(villager_character, player_character)
		end
		if villager_id == 18 then
			intro_quest_status_18 = event.get_quest_request_status(0, 0) or intro_quest_status_18
			quest_13_status = event.get_quest_request_status(0, 13) or quest_13_status
			if intro_quest_status_18 == 2 and quest_13_status ~= 2 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "こんにちは。\n仲間になってよ！")
				resume_point = 20
				recruit_answer_18 = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if recruit_answer_18 < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if recruit_answer_18 == 1 then
					resume_point = 21
					i04_girard_house.talk_priest(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			if submap == 33 then
				resume_point = 22
				npc.open_shop()
			else
				resume_point = 23
				i04_girard_house.talk_priest(villager_character, player_character)
			end
		end
		if villager_id == 19 then
			resume_point = 24
			i04_girard_house.talk_lucio(villager_character, player_character)
		end
		if villager_id == 20 then
			resume_point = 25
			i04_girard_house.talk_angler(villager_character, player_character)
		end
		if villager_id == 21 then
			resume_point = 26
			i04_girard_house.talk_fish_racer(villager_character, player_character)
		end
		if villager_id == 23 then
			resume_point = 27
			i04_girard_house.talk_quest_17_villager(villager_character, player_character)
		end
		if villager_id == 24 then
			resume_point = 28
			i04_girard_house.talk_hide_and_seek_girl(villager_character, player_character)
		end
		if villager_id == 25 then
			resume_point = 29
			i04_girard_house.talk_old_man(villager_character, player_character)
		end
		if villager_id == 33 then
			shop_quest_8_status = event.get_quest_request_status(0, 8) or shop_quest_8_status
			playable_character = event.get_playable_character() or playable_character
			if shop_quest_8_status == 1 and playable_character == 0 then
				event.set_character_motion(player_character, "立ち")
				event.open_message_window_2(0, "買い物させて\nこんにちは")
				resume_point = 30
				shop_answer = message.ask_choice(0, -1, 5, 256, 208, 2, 1)
				if shop_answer < 0 then
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
				if shop_answer == 1 then
					resume_point = 31
					npc.talk_fondue_host(villager_character, player_character)
					event.set_villager_ai_enabled(1, villager_character)
					return
				end
			end
			resume_point = 32
			npc.open_shop()
		end
		if villager_id == 1 then
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
		if villager_id == 2 then
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
		if villager_id == 6 then
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
		if villager_id == 13 then
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
		if villager_id == 22 then
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
				recruit_answer_12 = received[1] :: number
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
				recruit_answer_12 = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 10 then
			return 0
		end
		if resume_point <= 14 then
			if resume_point == 14 then
				recruit_answer_15 = received[1] :: number
			end
			if resume_point <= 11 then
				message.resume_talk_pages_third(villager_character, player_character)
			end
			if resume_point <= 12 then
				message.resume_finish_dialogue(villager_character, player_character)
			end
			if resume_point <= 13 then
				recruit_answer_15 = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 15 then
			return 0
		end
		if resume_point <= 20 then
			if resume_point == 20 then
				recruit_answer_18 = received[1] :: number
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
				recruit_answer_18 = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
			end
			return 0
		end
		if resume_point <= 21 then
			return 0
		end
		if resume_point <= 30 then
			if resume_point == 30 then
				shop_answer = received[1] :: number
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
				shop_answer = message.open_choice_skipping(0, -1, 5, 256, 208, 2, 1)
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

--- Shows the hide-and-seek map part from a save flag and places Colin in the room while the hide-and-seek quest is active and the found counter is 1.
function i04_girard_house.update_hide_and_seek_state()
	local save_flag: s32 = 0
	local request_status: s32 = 0
	local found_counter: s32 = 0
	save_flag = event.get_save_flag(38) or save_flag
	i04_girard_house.set_map_part_visible(if save_flag == 0 then 1 else 0)
	request_status = event.get_quest_request_status(0, 18) or request_status
	if request_status == 1 then
		found_counter = event.get_save_counter(11) or found_counter
		if found_counter == 1 then
			i04_girard_house.spawn_hide_and_seek_girl()
		end
	end
end

return i04_girard_house
