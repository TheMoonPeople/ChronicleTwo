--!strict
-- map/g/g00/g00.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05ce8bed = require("@lib/event/helper_05ce8bed")
local helper_4d8a1bec = require("@lib/event/helper_4d8a1bec")
local helper_4f147a6f = require("@lib/event/helper_4f147a6f")
local helper_6c76a9f4 = require("@lib/event/helper_6c76a9f4")
local helper_7408556b = require("@lib/event/helper_7408556b")
local helper_781c97dd = require("@lib/event/helper_781c97dd")
local helper_baeaba52 = require("@lib/event/helper_baeaba52")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d76d5fd4 = require("@lib/event/helper_d76d5fd4")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")
local helper_f3577a67 = require("@lib/event/helper_f3577a67")
local helper_f72b3bd7 = require("@lib/event/helper_f72b3bd7")

--- Helper function.
local function helper_b8bc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"バース鉄道が大陸全土に\n行き渡ることは、わしとニードの\n夢なのじゃ。協力頼むぞ。"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"ゼルマイトが発見されたら\nオレも忙しくなるな。そうなったら、\n掘って掘って堀りまくるぜい！！"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(
			arg0,
			"世界にはアッシの知らない植物が\nまだまだたくさんあるんですかねぇ。"
		)
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"おう。ゼルマイト探しは進んでるか？\nなんか手伝うことがあったら\n遠慮なく言ってくれ。"
		)
	end
	if arg1 == 5 then
		event.MesMake_2(arg0, "絵の世界は本当に奥が深い。\n未だ極めることができない・・・")
	end
	if arg1 == 6 then
		event.MesMake_2(arg0, "ゼルマイト探しもいいが\nはりきりすぎて体を壊さんようにな。")
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"料理の勉強をして世界一の\nコックをめざします。そしたら、\n坊ちゃんに一番にごちそうしますね。"
		)
	end
	if arg1 == 8 then
		event.MesMake_2(arg0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "よっ！元気か。オレも元気だぜ。")
	end
	if arg1 == 10 then
		event.MesMake_2(
			arg0,
			"ゼルマイト鉱山は怖いところです。\nくれぐれも気をつけてくださいませ。"
		)
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "ご無事をお祈りします・・・")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "パンが食べたくなったら\nあたしのところへおいで。")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "おまえ、ホントに冒険が好きだよなぁ。")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "本官に頼みたいことがあったら、\nいつでも言ってくれ。")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "どうだい？ゼルマイト鉱山には\n歯ごたえのある奴はいるかい？")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"これからは、ニードやスターブルとともに\n世界の建て直しに協力するつもりだ。\nおたがい、がんばらねばならんな。"
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"頼みごとをしていて言うのも変だが、\n鉱山は危険な場所だ。\nあまり無理をしないようにな。"
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "これから先も、永久に世界が\n平和でありますように。")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"バース鉄道が世界中に広がったら\nいろんなところにいけるようになるね。"
		)
	end
	if arg1 == 20 then
		event.MesMake_2(arg0, "はやく、いろんなところに行って\n釣りをしてみたいよね。")
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"フラビンたら、少しは釣り以外の\nことにも興味を持って欲しいわ。"
		)
	end
	if arg1 == 22 then
		event.MesMake_2(
			arg0,
			"ゼルマイト鉱山から、何か恐ろしい気を\n感じるの。気をつけてね。"
		)
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"バース鉄道が世界中に広がったら\nいろんなところに旅行とか\n行っちゃおっかな。"
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"ねぇねぇ、最近なんか、こっそり\n楽しいことしてるでしょ？\nわたしにも教えてよ～。"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			"そうだねぇ、バース鉄道が完成したら\n”世界の果て”を見てみたいねぇ。"
		)
	end
end

--- Helper function.
local function helper_1f748(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_b8bc(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"わしはここに住む事になったが\nバース壱号の事も心配じゃ。<page>今まで通り、列車は\nわしが動かすからな。<page>ボルネオはちと荒っぽいし、\nトムはまだ若造じゃからの。<page>これからは、この家と列車を\n行き来する事になるのう。<page>大変じゃ・・・"
				)
			else
				event.MesMake_2(arg0, "スティーブの調子はどうじゃな？")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "部屋でおとなしくしてるなんて、\nがまんできないぞ。")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"草木や花は世話した分だけ\nキッチリ育ちます。手を抜くなんて\nできませんぜ。"
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"秘密基地は大丈夫かな？\n誰かに確かめて来て欲しいけど、\n秘密だから頼めないよなぁ・・・"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"むらさき色って素晴らしい色だよ。\n暖かいようで冷たくて、\n明るいようで暗くてさ。"
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "病に苦しむ人がいるなら、\nどこへでも行くつもりだよ。")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "どこに行っても美味い物を作るのが\nプロの料理人です。")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "やっぱりお家はがんじょうな方が\n良いじゃない？")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"木の実も美味いけど、やっぱ\nあの赤いのが最高だ。\nまた、持ってきてくれよな。"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"書物にとって湿気は大敵です。\n水の近くに住むなんてとんでもない。"
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"おしゃれでも可愛くもないけど、\n私にしか作れない服を作っていきます。"
			)
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "新しい場所で心機一転だ。\n初心に戻ってパンを焼くよ。")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "何でも良いから\n派手にぶっ壊したいぜ。")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "未知のモンスターを発見したら、\nただちに報告するように。")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"まだ男だ女だと区別する奴がいるけど、\n剣の道は剣の道だ。強い奴が正しいのさ。"
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "こんな小さな家に、家族だけで住むのも\n悪くないかもな。")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "モートンはちゃんとやっているかな。\n心配だ・・・")
		end
		if arg1 == 18 then
			event.MesMake_2(arg0, "まだ教会のない町があるのなら、\n私がそこに赴きましょう。")
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"最近はあまり月の事を考えなくなったよ。\nトモダチがたくさん出来たからかな？"
			)
		end
		if arg1 == 20 then
			event.MesMake_2(arg0, "土地が違えば魚も変わる。\n釣りの仕方も工夫しないとな。")
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "ここの水は魚が良く育ちそうだわ。")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"パトリったら、また女の人の絵を\n描き始めたの。私以上の美人に\nするんですって。"
			)
		end
		if arg1 == 23 then
			event.MesMake_2(
				arg0,
				"虫ってどうしてあんな気味の悪い形を\nしているのかしら・・・"
			)
		end
		if arg1 == 24 then
			event.MesMake_2(
				arg0,
				"もっとかわいいお家にしてちょうだい。\nかわいさに限界なんてないのよ！"
			)
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "まさかこの歳になって引っ越すとは\n思わなかったよ。")
		end
	else
		helper_b8bc(arg0, arg1)
	end
end

--- Helper function.
local function helper_8d08(arg0: s32, arg1: any, arg2: any)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var13: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local offset_x: f32 = 0
	local offset_y: f32 = 0
	local offset_z: f32 = 0
	local middle_x: f32 = 0
	local var21: f32 = 0
	local middle_z: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local angle: f32 = 0
	local var30: f32 = 0
	local var31: f32 = 0
	local angle_2: f32 = 0
	local var33: f32 = 0
	local var34: f32 = 0
	local var35: f32 = 0
	local var36: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local out1, out2, out3 = event.GetCharaPos(arg0)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	do
		local _, out2, _ = event.GetCharaRot(arg0)
		var10 = out2 or var10
	end
	do
		local out1, out2, out3 = event.GetCharaPos(arg1)
		var6 = out1 or var6
		var7 = out2 or var7
		var8 = out3 or var8
	end
	do
		local _, out2, _ = event.GetCharaRot(arg1)
		var13 = out2 or var13
	end
	var15 = event.GetRotLookPos(var6 - var3, var8 - var5) or var15
	var16 = event.GetRotLookPos(var3 - var6, var5 - var8) or var16
	if arg2 ~= 0 then
		do
			local out1, out2, out3, out4, out5, out6 = event.SetTalkCamera(var3, var4, var5, var6, var7, var8, var15)
			offset_x = out1 or offset_x
			offset_y = out2 or offset_y
			offset_z = out3 or offset_z
			middle_x = out4 or middle_x
			var21 = out5 or var21
			middle_z = out6 or middle_z
		end
		event.SetCameraPos(offset_x, offset_y, offset_z)
		event.SetCameraRef(middle_x, var21, middle_z)
		event.SetCrossfade(10)
	end
	var27 = var10
	var28 = var15
	angle = vm.f32(var28 - var27)
	angle = event.AngleLimit(angle) or angle
	var30 = var13
	var31 = var16
	angle_2 = vm.f32(var31 - var30)
	angle_2 = event.AngleLimit(angle_2) or angle_2
	if -0.5 < angle and angle < 0.5 then
		event.SetMotion(arg0, "立ち")
	else
		event.SetMotion(arg0, "歩き")
	end
	if -0.5 < angle_2 and angle_2 < 0.5 then
	else
		event.SetMotion(arg1, "歩き")
	end
	var33 = 0.0
	var34 = vm.f32(helper_baeaba52(helper_05ce8bed(angle), helper_05ce8bed(angle_2)) * 8.0)
	while var33 < var34 do
		var35 = helper_f72b3bd7(0.0, angle, var33, var34)
		var35 = vm.f32(var35 + var27)
		event.SetCharaRot(arg0, 0.0, var35, 0.0)
		var36 = helper_f72b3bd7(0.0, angle_2, var33, var34)
		var36 = vm.f32(var36 + var30)
		event.SetCharaRot(arg1, 0.0, var36, 0.0)
		var33 = vm.f32(var33 + 1.0)
		if vm.wait() then
			return skip(1)
		end
	end
	event.SetCharaRot(arg0, 0.0, var15, 0.0)
	event.SetMotion(arg0, "立ち")
	event.SetCharaRot(arg1, 0.0, var16, 0.0)
	event.SetMotion(arg1, "会話")
end

--- Helper function.
local function helper_a23c(arg0: any, arg1: any, arg2: any)
	local rot_y: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return rot_y
	end
	if arg2 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local _, out2, _ = event.EohGetRot(0)
			rot_y = out2 or rot_y
		end
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_8d08(player_chara, arg0, arg1)
	if vm.skipping() then
		return skip(1)
	end
	return rot_y
end

--- Helper function.
local function helper_a4fc(arg0: s32, arg1: s32, arg2: s32, arg3: s32)
	local var4: f32 = 0
	local player_chara: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dbd14b96(0, arg1, arg0, player_chara, 0)
		end
		if at <= 2 then
			helper_4f147a6f(arg0, var4, arg2, arg3)
		end
	end
	var4 = helper_a23c(arg0, arg2, arg3)
	if vm.skipping() then
		return skip(1)
	end
	player_chara = event.GetControlChrid() or player_chara
	helper_dbd14b96(0, arg1, arg0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
	helper_4f147a6f(arg0, var4, arg2, arg3)
	if vm.skipping() then
		return skip(3)
	end
end

--- Helper function.
local function helper_20a60()
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "こんにちは。\nいい天気だね。")
	helper_1f748(0, var2)
	helper_a4fc(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_20d54()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_781c97dd(1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(0)
	helper_781c97dd(1)
	event.Finish()
end

--- Helper function.
local function helper_20e10(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f3577a67(30)
		end
		helper_20d54()
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_f3577a67(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	helper_20d54()
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_de20()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_4d8a1bec(3, 1)
			helper_6c76a9f4(3, -1, 3, 256, 208)
		end
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	do
		local out1, out2 = event.GetMenuEtc_3(6)
		var0 = out1 or var0
		var1 = out2 or var1
	end
	if 0 < var0 then
		return 1
	end
	if var1 == 1 then
		helper_4d8a1bec(3, 1)
		event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
		helper_6c76a9f4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 2 then
		helper_4d8a1bec(3, 1)
		event.MesMake_2(
			3,
			"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
		)
		helper_6c76a9f4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_e268()
	local argc: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 0
		end
		if at <= 2 then
			return helper_de20()
		end
		if at <= 3 then
			helper_4d8a1bec(3, 1)
			helper_6c76a9f4(3, -1, 3, 256, 208)
		end
		return helper_de20()
	end
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_4d8a1bec(3, 1)
		event.MesMake_2(3, "スクープメモを\n買ってくれ。")
		helper_6c76a9f4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(1)
		end
		return 0
	end
	do
		local out1, out2 = event.GetMenuEtc_3(5)
		var1 = out1 or var1
		var2 = out2 or var2
	end
	if var1 == var2 then
		helper_4d8a1bec(3, 1)
		event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
		helper_6c76a9f4(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		return helper_de20()
	end
	var3 = event.GetMenuEtc_2(3) or var3
	if 0 < var3 then
		helper_4d8a1bec(3, 8)
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
		event.SetMesDrawspeed(3, 0)
		helper_6c76a9f4(3, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_4d8a1bec(3, 1)
	var3 = event.GetMenuEtc_2(4) or var3
	if var3 <= 0 then
		event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
	else
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
	end
	helper_6c76a9f4(3, -1, 3, 256, 208)
	if vm.skipping() then
		return skip(4)
	end
	return helper_de20()
end

--- Helper function.
local function helper_c9f4()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(732) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "やったな！ニンゲンも\n少しはやるもんだ。<page>見直したぜ。")
		return
	end
	flag = event.GetFlag(728) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"いよいよ最後だね。\n奴を倒せば全て終わる。<page>そして、新しい何かが\n始まるんだ。"
		)
		return
	end
	flag = event.GetFlag(712) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"グリフォンの気持ちもわかるけど、\n彼のした事は許されないと思うんだ。"
		)
		return
	end
	flag = event.GetFlag(702) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "庭園を元に戻して、グリフォン、\nいやサンの秘密をあばくんだ。")
		return
	end
	flag = event.GetFlag(700) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"「サンの思い出」って何の事かな？\n宮殿に入ってみなきゃわかんないよ。"
		)
		return
	end
	flag = event.GetFlag(640) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ぼやぼやしているとグリフォンを\n逃がしてしまうよ。<page>早く月花宮殿へ行かなきゃ。"
		)
		return
	end
	flag_2 = event.GetFlag(624) or flag_2
	flag_3 = event.GetFlag(628) or flag_3
	flag_4 = event.GetFlag(632) or flag_4
	flag_5 = event.GetFlag(636) or flag_5
	if (if (if (if flag_2 ~= 0 then flag_3 else 0) ~= 0 then flag_4 else 0) ~= 0 then flag_5 else 0) ~= 0 then
		event.MesMake_2(
			3,
			"ラピスは全て手に入れたよね。\n急いでカザロフストーンへ行こう。"
		)
		return
	end
	flag = event.GetFlag(616) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"とにかく、急いでラピスを探さなきゃ、\n取り返しのつかない事になっちゃうよ。"
		)
		return
	end
	flag = event.GetFlag(600) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"この宮殿から全てが始まったんだね。\nとりあえず、中に入ってみようよ。"
		)
		return
	end
	flag = event.GetFlag(540) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"そろそろ、ルナ研に戻ってみない？\nイクシオンが完成してるかもしれないよ。"
		)
		return
	end
	flag = event.GetFlag(536) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"いよいよグリフォンへの反撃開始だ。\nパズノス要塞へ行ってみようよ。"
		)
		return
	end
	flag = event.GetFlag(526) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.GetFlag(524) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ドナ・ホーンさんが\n言っていたよね。<page>ファイアーホーンを奏でれば\n道は開けるって。"
		)
		return
	end
	flag = event.GetFlag(520) or flag
	if flag ~= 0 then
		event.MesMake_2(3, "なにぼやぼやしてるの！\n早くモニカを助けなきゃ！")
		return
	end
	flag = event.GetFlag(508) or flag
	if flag ~= 0 then
		event.MesMake_2(
			3,
			"ファイアースコール装置を\n壊さなきゃ。<page>ガンドール火山の頂上に\nあるって言っていたよね。"
		)
		return
	end
	event.MesMake_2(
		3,
		"待っているだけでは\n何も起きないよ。<page>まだ行った事のない場所が\nあるんじゃないの。"
	)
end

--- Helper function.
local function helper_20f2c()
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local var10: f32 = 0
	local var11: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local now_map_no: s32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: f32 = 0
	local var25: f32 = 0
	local var26: f32 = 0
	local var27: f32 = 0
	local var28: f32 = 0
	local var29: any = 0
	local var30: s32 = 0
	local var31: s32 = 0
	local var32: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				var4 = 0
				var4 = 8
				var4 = 16
				var4 = 24
				var4 = 32
				var4 = 40
				var23 = vm.f32(vm.sin(var18) * 30.0)
				var23 = vm.f32(var23 + var5)
				var24 = vm.f32(var6 + 33.0)
				var25 = vm.f32(vm.cos(var18) * 30.0)
				var25 = vm.f32(var25 + var7)
				var26 = var5
				var27 = vm.f32(var6 + 30.0)
				var28 = var7
			end
			if at <= 2 then
				var29 = 0
				helper_4d8a1bec(3, 1)
				helper_1f748(3, var2)
				var30 = -1
				helper_4d8a1bec(1, 8)
				helper_d76d5fd4(1, 1, 1, 0, 0)
				helper_4d8a1bec(2, 2)
				var30 = 30
				var30 = 31
				var30 = 32
				var29 = helper_7408556b(2, var30, 7, 0, 0, var32, var32 - 1)
			end
			helper_20d54()
			return
		end
		if at <= 5 then
			helper_20d54()
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_4d8a1bec(3, 8)
				helper_6c76a9f4(3, var30, 9, 0, 0)
			end
			if at <= 7 then
				helper_6c76a9f4(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_20d54()
				helper_20e10(6)
			end
			if at <= 9 then
				helper_20e10(23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_20e10(33)
			end
			return
		end
		if at <= 13 then
			helper_20e10(1)
		end
		if at <= 14 then
			helper_20e10(2)
		end
		if at <= 15 then
			helper_20e10(3)
		end
		if at <= 16 then
			helper_20e10(7)
		end
		if at <= 17 then
			helper_20e10(8)
		end
		if at <= 18 then
			helper_20e10(9)
		end
		if at <= 19 then
			helper_20e10(10)
		end
		if at <= 20 then
			helper_20e10(11)
		end
		if at <= 21 then
			helper_20e10(12)
		end
		if at <= 22 then
			helper_20e10(13)
		end
		if at <= 23 then
			helper_20e10(14)
		end
		if at <= 24 then
			helper_20e10(15)
		end
		if at <= 25 then
			helper_20e10(16)
		end
		if at <= 26 then
			helper_20e10(17)
		end
		if at <= 27 then
			helper_20e10(18)
		end
		if at <= 28 then
			helper_20e10(19)
		end
		if at <= 29 then
			helper_20e10(20)
		end
		if at <= 30 then
			helper_20e10(21)
		end
		if at <= 31 then
			helper_20e10(22)
		end
		if at <= 32 then
			helper_20e10(32)
		end
		if at <= 33 then
			helper_c9f4()
			helper_6c76a9f4(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_20d54()
			helper_f3577a67(30)
		end
		helper_20d54()
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetMotion(0, "立ち")
	event.SetMotion(var1, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if var2 == 10 or var2 == 18 then
		var4 = 8
	end
	if var2 == 1 or var2 == 6 or var2 == 17 then
		var4 = 16
	end
	if var2 == 2 or var2 == 15 or var2 == 16 or var2 == 19 or var2 == 20 or var2 == 21 or var2 == 22 then
		var4 = 24
	end
	if var2 == 3 or var2 == 4 or var2 == 5 or var2 == 7 or var2 == 8 or var2 == 23 or var2 == 24 then
		var4 = 32
	end
	if var2 == 9 or var2 == 11 or var2 == 13 then
		var4 = 40
	end
	event.SetMesEtc(1, 4, 30, 60, 144, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	do
		local out1, _, out3 = event.GetCharaPos(0)
		var11 = out1 or var11
		var13 = out3 or var13
	end
	do
		local out1, _, out3 = event.GetCharaRot(0)
		var14 = out1 or var14
		var16 = out3 or var16
	end
	do
		local out1, out2, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var6 = out2 or var6
		var7 = out3 or var7
	end
	do
		local out1, _, out3 = event.GetCharaRot(var1)
		var8 = out1 or var8
		var10 = out3 or var10
	end
	var17 = event.GetRotLookPos(var5 - var11, var7 - var13) or var17
	event.SetCharaRot(0, var14, var17, var16)
	var18 = event.GetRotLookPos(var11 - var5, var13 - var7) or var18
	event.SetCharaRot(var1, var8, var18, var10)
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no ~= 1 then
		do
			local out1, out2, out3 = event.FuncPointGetPos("", "gcamp")
			var20 = out1 or var20
			var21 = out2 or var21
			var22 = out3 or var22
		end
		event.SetCameraPos(var20, var21, var22)
		event.SetCameraRef(var5, var6 + 30.0, var7)
		var18 = event.GetRotLookPos(var20 - var5, var22 - var7) or var18
		event.SetCharaRot(var1, var8, var18, var10)
	else
		var23 = vm.f32(vm.sin(var18) * 30.0)
		var23 = vm.f32(var23 + var5)
		var24 = vm.f32(var6 + 33.0)
		var25 = vm.f32(vm.cos(var18) * 30.0)
		var25 = vm.f32(var25 + var7)
		event.SetCameraPos(var23, var24, var25)
		var26 = var5
		var27 = vm.f32(var6 + 30.0)
		var28 = var7
		event.SetCameraRef(var26, var27, var28)
	end
	event.CharaActive(0, 0)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_4d8a1bec(3, 1)
		helper_1f748(3, var2)
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_4d8a1bec(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_d76d5fd4(1, 1, 1, 0, 0)
		helper_4d8a1bec(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(var2, 4)
			var30 = out1 or var30
			var32 = out2 or var32
		end
		if var32 == 3 then
			var30 = 30
		end
		if var32 == 4 then
			event.SetMesItemDirect(2, 1, var30)
			var30 = 31
		end
		if var32 == 5 then
			event.SetMesItemDirect(2, 1, var30)
			event.SetMesItemDirect(2, 2, vm.i32(var30 + 1))
			var30 = 32
		end
		var29 = helper_7408556b(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if vm.skipping() then
			return skip(3)
		end
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_20d54()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_f3577a67(30)
				if vm.skipping() then
					return skip(4)
				end
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_20d54()
				event.SetFadeIn(30)
				return
			end
			helper_4d8a1bec(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			helper_6c76a9f4(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_4d8a1bec(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_6c76a9f4(3, var30, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "よし、これで\n修理完了じゃ！")
						helper_6c76a9f4(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_20d54()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_20e10(6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_20e10(23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if var2 == 4 then
						local t0 = helper_e268()
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_20e10(33)
							if vm.skipping() then
								return skip(12)
							end
							return
						end
					end
				end
				if var29 == 4 then
					break
				end
				if var29 == -1 then
					break
				end
			else
				if var29 == 2 then
					if var2 == 15 then
						helper_20e10(0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if var2 == 12 then
						helper_20e10(1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if var2 == 6 then
						helper_20e10(2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if var2 == 7 then
						helper_20e10(3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if var2 == 2 then
						helper_20e10(7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if var2 == 3 then
						helper_20e10(8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if var2 == 5 then
						helper_20e10(9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if var2 == 8 then
						helper_20e10(10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if var2 == 10 then
						helper_20e10(11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if var2 == 11 then
						helper_20e10(12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if var2 == 13 then
						helper_20e10(13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if var2 == 16 then
						helper_20e10(14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if var2 == 18 then
						helper_20e10(15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if var2 == 19 then
						helper_20e10(16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if var2 == 20 then
						helper_20e10(17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if var2 == 21 then
						helper_20e10(18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if var2 == 22 then
						helper_20e10(19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if var2 == 23 then
						helper_20e10(20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if var2 == 24 then
						helper_20e10(21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if var2 == 25 then
						helper_20e10(22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if var2 == 17 then
						helper_20e10(32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if var2 == 9 then
						helper_c9f4()
						helper_6c76a9f4(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_20d54()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_f3577a67(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_20d54()
						event.SetFadeIn(30)
					end
					return
				end
				if var29 == 3 then
					break
				end
				if var29 == -1 then
					break
				end
			end
		else
			if var29 == 2 then
				break
			end
			if var29 == -1 then
				break
			end
		end
	end
	helper_20d54()
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_c6c63376

--- Program 100.
script[100] = function()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "お洒落")
	helper_6c76a9f4(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20f2c()
		end
	end
	helper_20a60()
	if vm.skipping() then
		return skip(1)
	end
	helper_20f2c()
	if vm.skipping() then
		return skip(2)
	end
end

return script
