--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_0ffc2526 = require("@lib/event/helper_0ffc2526")
local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_31bbf01d = require("@lib/event/helper_31bbf01d")
local helper_76f23193 = require("@lib/event/helper_76f23193")

--- Helper function.
local function helper_d3e304cd()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local argc: s32 = 0
	local var9: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local flag_7: s32 = 0
	local flag_8: s32 = 0
	local active_chr_no: s32 = 0
	local player_chara_2: s32 = 0
	local var16: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	player_chara = event.get_player_character_slot() or player_chara
	var1 = event.get_triggered_event_data_2(13) or var1
	var2 = event.get_triggered_event_data_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	event.stop_camera_control_movement()
	event.set_villager_ai_enabled(0, var1)
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "こんにちは。\nいい天気だね。")
	var3 = 0
	if var2 == 300 then
		flag = event.get_save_flag(640) or flag
		if flag == 0 then
			flag_2 = event.get_save_flag(456) or flag_2
			if flag_2 == 0 then
				event.open_message_window_2(
					0,
					"ん？キミは・・・？ここには、世界最高の研究機関\nルナティックウィズダム研究所が、できるはず\nだったんだ。<page>今では、こんなになってしまってるけどね。"
				)
			else
				event.open_message_window_2(
					0,
					"ルナ研のすばらしさは、ひとことでは\n言い尽くせないよ。キミが自分の目で\n確かめることだね。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"グリフォンを倒さないと本当の歴史を\n取り戻すことはできないんだ。<page>グリフォンの存在自体が、この歴史を\nゆがめてしまってるんだからね。"
			)
		end
	end
	if var2 == 301 then
		flag_3 = event.get_save_flag(420) or flag_3
		if flag_3 == 0 then
			flag_4 = event.get_save_flag(408) or flag_4
			if flag_4 == 0 then
				event.open_message_window_2(0, "グガー、グガー")
				var3 = 2
			else
				argc = event.is_invention_created(309) or argc
				if argc < 0 then
					event.open_message_window_2(
						0,
						"アクアリウムを発明するヒントは\n木箱、窓、噴水だ。<page>おまえの町にも\nそれくらいはあるだろ。"
					)
				else
					var9 = event.get_save_data_value(2) or var9
					if var9 == 0 then
						event.open_message_window_2(
							0,
							"アクアリウムの中の魚に「電気ミミズ」を\n食わせて、電気を帯びた魚をつくるんだ。\nそいつを例のシーグラに食わせる。<page>忘れるなよ。"
						)
					else
						event.open_message_window_2(
							0,
							"おっ、電気を帯びた魚はできたようだな。\nじゃ、あとはそいつをシーグラに食わせて\nみるんだ。ま、せいぜい、がんばってな。"
						)
					end
				end
			end
		else
			event.open_message_window_2(
				0,
				"お！成功したみたいだな。\nやはり、私の発明品は役に立つ。\nうむうむ。"
			)
		end
	end
	if var2 == 302 then
		event.open_message_window_2(
			0,
			"オズモンドといい、所長といい、\nこのルナ研は、変わり者が多いんだよな～。"
		)
	end
	if var2 == 303 then
		flag_5 = event.get_save_flag(640) or flag_5
		if flag_5 == 0 then
			flag_6 = event.get_save_flag(616) or flag_6
			if flag_6 == 0 then
				flag_7 = event.get_save_flag(600) or flag_7
				if flag_7 == 0 then
					flag_8 = event.get_save_flag(448) or flag_8
					if flag_8 == 0 then
						event.open_message_window_2(
							0,
							"シェルトーキーは、大切にしてくれよ。\nあれはルナ研の大事な発明品のひとつなんだ。"
						)
					else
						event.open_message_window_2(
							0,
							"時間がない。急いでくれ、ユリス、モニカ。\nグリフォンの軍勢がエイナたちに迫っている。\n恐らく、長くは持ちこたえられない・・・"
						)
					end
				else
					event.open_message_window_2(0, "グリフォンとはいったいどんな奴\nなんだろう・・・")
				end
			else
				event.open_message_window_2(
					0,
					"ラピス探しか・・・ラピスは古代の民によって\nつくられた英知の結晶だ。ルナ研の\nコンピュータ分析によって<page>七色蝶の森、ステラ渓谷、潮騒の洞窟、\nガンドール火山の４箇所に隠されている\nことがわかった。"
				)
				helper_31bbf01d(player_chara, var1, 0)
				helper_0ffc2526(0, -1, var1, player_chara, 0)
				var3 = 1
				event.open_message_window_2(
					0,
					"隠された場所の入り口には必ず、\n星がかたどられた紋章がついているはずだ。\n探してみてくれ。"
				)
			end
		else
			event.open_message_window_2(
				0,
				"いよいよ、グリフォンを倒すときが来た。\n世界の運命はキミたちの双肩にかかっている。\n頼んだぞ！"
			)
		end
	end
	if var2 == 304 then
		event.open_message_window_2(
			0,
			"この研究所では、すべてが実力主義。\n能力があれば、たとえ子供であろうと\nトップに君臨することもできるのだ。"
		)
	end
	if var2 == 305 then
		event.open_message_window_2(
			0,
			"シーグラたちが運んでくるルナストーンは\n私たちの頭をスッキリさせて、研究に集中\nさせてくれる効果があるんだ。<page>ルナストーンの正体が何なのかは\n私たちもわからないんだけどね。"
		)
	end
	if var2 == 306 then
		event.open_message_window_2(
			0,
			"海の上にある研究施設なんてイカすだろ？\nこの研究所に入るためにどれだけ勉強した\nことか・・・"
		)
	end
	if var2 == 307 then
		event.open_message_window_2(
			0,
			"ところでキミ、このルナ研のデザイン、\nどう思う？<page>これじゃ、まるで遊園地じゃないかぁ？\nいったいダレの趣味なんだか・・・"
		)
	end
	if var2 == 308 then
		event.open_message_window_2(
			0,
			"いつか、私も所長を越えて、トップに\n立って見せるぞ。なにしろ、この研究所は\n実力の世界なんだから。"
		)
	end
	if var2 == 309 then
		event.open_message_window_2(
			0,
			"私は所長を尊敬しています。なんてったって、\nあの歳で、ベストセラー技術書「超科学者バイブル」\n全４０巻を書き上げた人だからな。"
		)
	end
	if var2 == 310 then
		event.open_message_window_2(
			0,
			"ボクまだ新人なんです。この研究所で\nいろんなことを学んで、立派な研究員に\nなりたいと思っています。<page>どうぞ、よろしくお願いします！"
		)
	end
	if var2 == 311 then
		event.open_message_window_2(
			0,
			"この研究所から見る海は\n最高だよ。<page>海の闇と空の闇が\n地平線のかなたで\n一体化しているんだ。"
		)
	end
	if var2 == 312 then
		event.open_message_window_2(
			0,
			"ここは、第２ラボ。<page>ルナ研は、\n研究室によって、\n研究内容が違うんだ。"
		)
	end
	if var2 == 313 then
		event.open_message_window_2(
			0,
			"ここルナ研は、夜の空間を\n作り出し、更にルナストーンの\n力を高めているんだ。"
		)
	end
	if var2 == 314 then
		event.open_message_window_2(
			0,
			"研究員なりたての頃は、どこがどの研究所なのか\nよく迷ったものだ。君もそうだろ。\nでは、覚え方を教えてあげよう。<page>まず、第一ラボは赤、第二ラボは青、\n第三ラボは紫、第四ラボは緑だ。\n各々の研究所で色が違うって訳だ。"
		)
	end
	if var2 == 315 then
		event.open_message_window_2(
			0,
			"センターラボの上に輝くエンブレムは\n月をイメージして作られたらしい。"
		)
	end
	if var2 == 316 then
		event.open_message_window_2(
			0,
			"昔、シグーと言う海竜が、たくさん\nルナストーンを運んでくれたおかげで\nこの研究所が完成したと聞いたよ。<page>かしこい海竜がいるものだな。"
		)
	end
	if var2 == 317 then
		event.open_message_window_2(
			0,
			"内緒だぞ。<page>オズモンドさんの\n寒いギャグには、僕らも\n飽き飽きしてるんだ。"
		)
	end
	if var2 == 318 then
		event.open_message_window_2(
			0,
			"何を隠そう、この僕も\n電気ミミズの研究に携わったのだ。\n今は別の研究にとりかかっている。<page>何かって？秘密だよ。\n外部の者にそう簡単に\n言えるものではないのだ。"
		)
	end
	if var2 == 319 then
		event.open_message_window_2(
			0,
			"何だ？君たちも\n研究員になりたいのか？<page>この研究所に入るのは、\n並大抵のことじゃないんだ。\nものすごく倍率が高いしね。"
		)
	end
	if var2 == 320 then
		event.open_message_window_2(
			0,
			"このルナ研のデザインに\nケチをつける研究員もいるらしいが\n僕はイカしていると思うな・・・<page>ま、少数意見というのも\n事実だがな。"
		)
	end
	if var2 == 321 then
		event.open_message_window_2(
			0,
			"今、極秘の研究内容について\n話しているところなんだ。<page>ちょっと\n席を外してくれないか。"
		)
	end
	if var2 == 322 then
		event.open_message_window_2(
			0,
			"申し訳ない。今、\n極秘の研究内容について\n話し合っているんだ。<page>少しばかり厄介なことに\nなっていてね・・・"
		)
	end
	if var2 == 323 then
		event.open_message_window_2(
			0,
			"Ｄｒ．チャップは、\nもちろん才能もあるが\n努力の人でもある。<page>僕なんて\nまだまだ・・・"
		)
	end
	if var2 == 324 then
		event.open_message_window_2(
			0,
			"君か？オズモンドさんに\n反論したって話、聞いたけど。<page>別に非難してるわけじゃないぜ。\n感心してるんだ。疑うことから\n何かが生まれるってこともあるからね。"
		)
	end
	if var2 == 325 then
		event.open_message_window_2(
			0,
			"この派手な照明に\n目が慣れないって？<page>君たち、過去から来た人間には\n慣れるのに\n少し時間がかかるだろうな。"
		)
	end
	if var2 == 326 then
		event.open_message_window_2(
			0,
			"いやー、少しばかり\n頭を冷やしているところだよ。<page>あんまり根詰めてやっていると\n効率も悪くなるからね。"
		)
	end
	if var2 == 327 then
		active_chr_no = event.get_playable_character() or active_chr_no
		if active_chr_no ~= 1 then
			event.open_message_window_2(
				0,
				"君もなかなかの発明家と聞いたよ。\nどうだ？大きくなったら、\nルナ研の研究員にならないか。<page>そうか、君が大人になる頃は、この\nルナ研もまだできたてほやほやだから\n君程度のレベルでも入れるかもね。"
			)
		else
			event.open_message_window_2(
				0,
				"いろんな物を発明しちゃう男って、\nかっこいいと思わないかい？<page>おっと、でも僕に惚れてもムダだよ。\n僕は研究一筋なんだからね。"
			)
		end
	end
	if var2 == 328 then
		event.open_message_window_2(
			0,
			"画期的な発明を思いついたんだ。\nモンスターと人間が\n共存するためのシステムなんだ。<page>モンスターが、人間の言葉を\n理解する機械を作るのだ。"
		)
	end
	if var2 == 329 then
		event.open_message_window_2(
			0,
			"ルナ研の中枢は\nルナストーンによって\nできている。<page>ルナストーンが無ければ、たちまち\nこのルナ研の全てのシステムが\nストップしてしまうだろう。"
		)
	end
	if var3 == 0 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var3 == 1 then
		helper_0ffc2526(0, -1, var1, player_chara, 0)
		event.set_character_motion(var1, "立ち")
		event.finish_event()
	end
	if var3 == 2 then
		event.set_camera_position(1.39, 51.09, 278.55)
		event.set_camera_look_at(-54.8, 23.29, 223.57)
		player_chara_2 = event.get_player_character_slot() or player_chara_2
		do
			local out1, _, out3 = event.get_character_position(player_chara_2)
			var16 = out1 or var16
			var18 = out3 or var18
		end
		do
			local out1, _, out3 = event.get_character_position(var1)
			var19 = out1 or var19
			var21 = out3 or var21
		end
		var22 = event.get_look_angle(var19 - var16, var21 - var18) or var22
		helper_76f23193(player_chara_2, var22)
		event.set_character_rotation(player_chara_2, 0.0, var22, 0.0)
		event.set_character_motion(player_chara_2, "立ち")
		helper_0ffc2526(0, -1, var1, player_chara_2, 0)
		event.reset_follow_camera(1, 3.1415927)
	end
	event.set_villager_ai_enabled(1, var1)
end

return helper_d3e304cd
