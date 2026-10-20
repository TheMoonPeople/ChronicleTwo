--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03b3279b = require("@lib/event/helper_03b3279b")
local helper_2d005f6e = require("@lib/event/helper_2d005f6e")
local helper_f0b5b912 = require("@lib/event/helper_f0b5b912")
local helper_fb74da97 = require("@lib/event/helper_fb74da97")

--- Helper function.
local function helper_73acf5bf()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local player_chara_2: s32 = 0
	local var10: f32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f0b5b912(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_03b3279b(player_chara_2, var16)
		end
		if at <= 3 then
			helper_f0b5b912(0, -1, var1, player_chara_2, 0)
		end
		if at <= 4 then
			helper_2d005f6e(5)
		end
		if at <= 5 then
			helper_2d005f6e(27)
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	var3 = 0
	flag = event.GetFlag(324) or flag
	flag_2 = event.GetFlag(330) or flag_2
	flag_3 = event.GetFlag(372) or flag_3
	flag_4 = event.GetFlag(400) or flag_4
	flag_5 = event.GetFlag(640) or flag_5
	if var2 == 200 then
		if flag_5 == 0 then
			if flag_2 == 0 then
				if flag == 0 then
					event.MesMake_2(
						0,
						"奇跡の料理、つくるには「白き風の花」が\n必要アル。今は切らしていてつくれないアル。\nお役に立てなくて申し訳ないアル。"
					)
				else
					event.MesMake_2(
						0,
						"奇跡のシューマイはもう食べたアルか？\n熱いうちに食べないと効果がうすれるアルよ。"
					)
				end
			else
				event.MesMake_2(
					0,
					"奇跡のシューマイが役に立ったアルか！\nそれはよかったアル。ところで、\n今日は何も食べていかないアルか？"
				)
			end
		else
			event.MesMake_2(
				0,
				"アイヤー、いよいよアルかぁ。\nよくわからないけど、がんばるアルよ。"
			)
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"アイテムにはいろいろな効果がある。\n使って役に立つもの。スペクトル化して\n武器に合成するもの・・・<page>アイテムを駆使すれば、手強い相手にも\n楽に勝てるんだぜ。覚えておけよ。"
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"この寺院がグリフォンと呼ばれる\n悪の皇帝に消されていたなんて・・・\n信じられません。<page>こんなとき、大賢者クレストさまが\nいてくだされば・・・"
			)
		else
			event.MesMake_2(
				0,
				"クレストさまが復活なされれば、もう怖いもの\nなしだ。おまえたちも安心してグリフォンと\n戦うがよいぞ。"
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"この寺院は永遠に夜のままだ。\nなぜなら、月のクリスタルは、夜にこそ、\nその力を発揮するからだ。<page>寺院の法力によって、この周りに\n夜の空間をつくり出しているのだ。"
			)
		else
			event.MesMake_2(
				0,
				"クレストさまは月のクリスタルをお使いになり、\nこの世のすべてのことをお見通しになるのだ。\nクレストさまに隠し事などできぬぞ。"
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"よう、いい武器がそろってるぜ。\n見てってくれよ。うちの武器は、よく\nビルドアップするって評判なんだぜ。"
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"何してるんだい！ぐずぐずしてると\nグリフォンの思うつぼだよ！\n急ぐんだよ！"
				)
			else
				event.MesMake_2(
					0,
					"私にしてやれることはここまでだよ。\nあとはアンタたち自身の力で\nグリフォンをどうにかしておくれ。<page>私を救ってくれたアンタたちなら\nきっとやれるはずさ。"
				)
			end
		else
			event.MesMake_2(
				0,
				"いよいよ、アンタたちの旅も終わりに\n近づいているようだね。グリフォンは、\n先生のカタキでもあるんだ。<page>必ず、倒しておくれ、頼んだよ。\nグリフォンが倒されたその時・・・\n先生も・・・私も、本当の賢者になれるんだ・・・"
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"寺院が元に戻っても、クレストさまがいなければ、\nこのステラ寺院は何の役にも立たない。<page>クレストさましか、すべてを見通す『大占星術』\nを使うことはできないのだ。。"
			)
		else
			event.MesMake_2(
				0,
				"あのクレストさまも、昔はある賢者さまの\n弟子だったらしい。クレストさまの師匠とは\nいったい、どんなすごい賢者さまなのだろう・・・"
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"この店の料理はいつ来てもうまいよなぁ。\n舌がとろけるっていうか、ホント最高なんだよ。"
			)
		else
			event.MesMake_2(
				0,
				"奇跡の料理、見せてもらった！\nやっぱり、ラオチャオ料理長はすごいな。"
			)
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"この店の料理を食べたら、もう他の料理が\nみんなまずく感じちゃうの。どうしましょ。"
			)
		else
			event.MesMake_2(0, "いいなぁ。私も奇跡のシューマイ\n食べたーい！")
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"「星の砂時計」が\n不思議なアイテムだと？<page>そうだな、私も持っているんだが、\n特に強い思いなどないからなぁ・・・\n時間を巻き戻したことなんてないなぁ。"
			)
		else
			event.MesMake_2(
				0,
				"なんとあなたたち、\n大賢者クレストさまの\nお知り合いだったのですね。<page>しかし、やけに\n親しげですね・・・"
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"大賢者クレストさまがいないんだ。\nどこに行かれたのだろう・・・<page>私たちは、あの方がいなければ\n不安でしかたないのだ。"
			)
		else
			event.MesMake_2(
				0,
				"クレストさまから聞いたことがある。遠い昔、\nギルトーニと言うやつに、この月のクリスタルを\n破壊されそうになったと。<page>それを命がけでお守りしたのが、\nクレストさまの師匠であったお方らしい・・・"
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"クレストさまは、月のクリスタルを\nお守りする為に、クリスタルともども\n消えてしまったと言うのか・・・<page>何と言うことだ・・・"
			)
		else
			event.MesMake_2(
				0,
				"見ただろ？月のクリスタルの偉大な力を。\nしかし、あの力を使えるのは\nクレストさまだけ・・・<page>私たちには、一生かかっても\nあの力を手に入れることは\nできないだろうな。"
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"ん？おまえたち、もしかして・・・\nいつか男の子と女の子が私を訪ねてくるだろう、と\nクレストさまがおっしゃっていた、あの２人・・・<page>さすがクレストさま、予言どおりだ。\nだが、残念なことに大賢者クレストさまも\n消されてしまっているんだ・・・"
			)
		else
			event.MesMake_2(
				0,
				"一万年前だって？<page>クレストさまの力でも、どうにも\nならないことが「ルナ研」と言う所に\n行けば可能だと言うのか・・・"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"月と言うものは、いろんな生物に\n影響を与える不思議な力を\n持っている。<page>そして、この力の結晶が、\n月のクリスタルなのだ。"
		)
	end
	if var2 == 214 then
		event.MesMake_2(
			0,
			"君たちか。クレストさまから\n話を聞いたことがあるぞ。ずいぶん昔に\n命を救われたことがあると。<page>なんと、\n子供だったとは・・・"
		)
	end
	if var3 == 0 then
		helper_fb74da97(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 1 then
		helper_f0b5b912(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetMotion(var1, "立ち")
		event.Finish()
	end
	if var3 == 2 then
		event.SetCameraPos(1.39, 51.09, 278.55)
		event.SetCameraRef(-54.8, 23.29, 223.57)
		player_chara_2 = event.GetControlChrid() or player_chara_2
		do
			local out1, _, out3 = event.GetCharaPos(player_chara_2)
			var10 = out1 or var10
			var12 = out3 or var12
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var13 = out1 or var13
			var15 = out3 or var15
		end
		var16 = event.GetRotLookPos(var13 - var10, var15 - var12) or var16
		helper_03b3279b(player_chara_2, var16)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_f0b5b912(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_2d005f6e(5)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var2 == 204 then
		helper_2d005f6e(27)
		if vm.skipping() then
			return skip(6)
		end
	end
end

return helper_73acf5bf
