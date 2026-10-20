--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_03b3279b = require("@lib/event/helper_03b3279b")
local helper_2d005f6e = require("@lib/event/helper_2d005f6e")
local helper_48507665 = require("@lib/event/helper_48507665")
local helper_6cf97d1a = require("@lib/event/helper_6cf97d1a")
local helper_f0b5b912 = require("@lib/event/helper_f0b5b912")

--- Helper function.
local function helper_ff8b049e()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local flag_9: s32 = 0
	local player_chara_2: s32 = 0
	local var14: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_f0b5b912(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_6cf97d1a(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_f0b5b912(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_03b3279b(player_chara_2, var20)
		end
		if at <= 5 then
			helper_f0b5b912(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_2d005f6e(30)
		end
		if at <= 7 then
			helper_2d005f6e(28)
		end
		if at <= 8 then
			helper_2d005f6e(29)
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
	if var2 == 400 then
		flag = event.GetFlag(640) or flag
		if flag == 0 then
			flag_2 = event.GetFlag(616) or flag_2
			if flag_2 == 0 then
				flag_3 = event.GetFlag(540) or flag_3
				if flag_3 == 0 then
					flag_4 = event.GetFlag(536) or flag_4
					if flag_4 == 0 then
						event.MesMake_2(
							0,
							"ギルトーニは手強い、決して\n油断してはならぬぞ。<page>キミならきっと勝てるはずだ。\nアトラミリアに選ばれた\nキミなら・・・"
						)
					else
						event.MesMake_2(
							0,
							"そうか、ギルトーニも\n悲しい男だったのだな。<page>グリフォンは二つの時代の\n人々を巻き込んで、いったい\n何をするつもりなのだ・・・"
						)
					end
				else
					event.MesMake_2(
						0,
						"君たちならきっと、\nグリフォンを倒すことが\nできるだろう。<page>期待しているぞ。"
					)
				end
			else
				event.MesMake_2(
					0,
					"クロノユニオン・・・<page>古代人たちの英知によって\n世界が救われると\n言うのか・・・"
				)
			end
		else
			event.MesMake_2(
				0,
				"いよいよ最後の決戦か。\nグリフォン大帝との闘いには、\n多くの仲間の血が流された・・・<page>絶対に負けるわけにはいかん！\nユリス、モニカ、頼んだぞ。\n必ず、奴を倒すのだ。"
			)
		end
	end
	if var2 == 401 then
		flag_5 = event.GetFlag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.GetFlag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.GetFlag(540) or flag_7
				if flag_7 == 0 then
					flag_8 = event.GetFlag(536) or flag_8
					if flag_8 == 0 then
						flag_9 = event.GetFlag(520) or flag_9
						if flag_9 == 0 then
							event.MesMake_2(
								0,
								"よう、まずはファイアースコールを破壊して、\n火炎雨をどうにかしねぇと、ヘイム・ラダを\n元に戻すことなんてできないぜ。"
							)
						else
							event.MesMake_2(
								0,
								"そうか、そんなことになってしまったか。\nファイアースコールを破壊しただけでも、\nまずはよかったというべきか。"
							)
							helper_48507665(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_f0b5b912(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"しかし、火口に落ちてしまった\nおまえさんの連れも心配だな。<page>こうなったら、ヘイム・ラダを復興して、\nこのガンドラダをさらにパワーアップする\nしかないな。"
							)
						end
					else
						event.MesMake_2(
							0,
							"ギルトーニを倒しちまうとは、\nおまえたち、スゲェんだな。<page>後は親玉のグリフォン大帝だ。\n気合を入れてかかれよ。"
						)
					end
				else
					event.MesMake_2(
						0,
						"パズノスの活躍、見せてもらった。\nうれしくてつい涙が出ちまったぜ。<page>なんてったって、移動要塞パズノスは\nオレたちの血と汗の結晶だからな。"
					)
				end
			else
				event.MesMake_2(
					0,
					"ラピス？\nう～ん、オレにはなんのことだか\nわかんねぇなぁ。"
				)
			end
		else
			event.MesMake_2(
				0,
				"いよいよ、グリフォンってやつと\n対決するわけだな。<page>がんばれよ、兄弟！"
			)
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "ヘーイ、いいのがそろってるよ！\n買ってって！！")
	end
	if var2 == 403 then
		event.MesMake_2(
			0,
			"パーツの品揃えならまかしときな。\nウチでさがせば、バッチリだぜ。"
		)
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"バトルは奥が深い。武器だけでゴリ押し\nしているようでは、まだまだだぜ。<page>バトルってやつは、アイテムを使って、\n切り抜けるのが、かっこいいんだ。"
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"ガンドラダ大工房でつくれないもの\nなどない。どんな巨大なものでも\nこの工房でならつくれてしまうんだぜ。"
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"オイ、おまえたちどこから入ってきたんだ。\nここは、危ないから気をつけるんだぞ。"
		)
	end
	if var2 == 407 then
		event.MesMake_2(
			0,
			"ボクら今までどうしてたんだろう？\nなんか思い出せないんだよね。"
		)
	end
	if var2 == 408 then
		event.MesMake_2(
			0,
			"オレたちがグリフォンに消されていた\nなんて・・・なんて恐ろしいやつなんだ。\nグリフォン大帝ってやつは。"
		)
	end
	if var2 == 409 then
		event.MesMake_2(0, "今、いそがしいんです。\n邪魔しないでください。")
	end
	if var2 == 410 then
		event.MesMake_2(
			0,
			"私たちもカゲながら健闘を祈っています。\nがんばってください！！"
		)
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"おっとー、ここの\nケースの中の武器は\n非売品らしいぜ。<page>しっかし、世の中には\nいろんな形をした武器が\nあるもんだなぁ・・・"
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"ファイアースコールを\n降らせるなんて、\nギルトーニって奴は・・・<page>ずるがしこいって言うか・・・\n本当にひどい奴だ。"
		)
	end
	if var2 == 413 then
		event.MesMake_2(0, "何だ？この看板の\nハートは・・・<page>趣味悪いぜ・・・")
	end
	if var3 == 0 then
		helper_6cf97d1a(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_f0b5b912(0, -1, var1, player_chara, 0)
		if vm.skipping() then
			return skip(4)
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
			var14 = out1 or var14
			var16 = out3 or var16
		end
		do
			local out1, _, out3 = event.GetCharaPos(var1)
			var17 = out1 or var17
			var19 = out3 or var19
		end
		var20 = event.GetRotLookPos(var17 - var14, var19 - var16) or var20
		helper_03b3279b(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_f0b5b912(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_2d005f6e(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_2d005f6e(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_2d005f6e(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

return helper_ff8b049e
