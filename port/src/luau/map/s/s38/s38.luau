--!strict
-- map/s/s38/s38.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0924108c = require("@lib/event/helper_0924108c")
local helper_13e53048 = require("@lib/event/helper_13e53048")
local helper_19a74323 = require("@lib/event/helper_19a74323")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_6fdd737a = require("@lib/event/helper_6fdd737a")
local helper_93fd01b9 = require("@lib/event/helper_93fd01b9")
local helper_db7d11d7 = require("@lib/event/helper_db7d11d7")
local helper_df67154e = require("@lib/event/helper_df67154e")
local helper_f4e03b9a = require("@lib/event/helper_f4e03b9a")

--- Helper function.
local function helper_1ed3c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var3 = vm.f32(var7 * -1.0)
		var3 = var7
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetNpcTrainEtc(1, arg1) or var2
	do
		local out1, out2, out3, _ = event.GetTrainNpcPos(var2)
		var3 = out1 or var3
		var4 = out2 or var4
		var5 = out3 or var5
	end
	var7 = event.GetNpcTrainEtc(2, arg1) or var7
	if var3 < 0 then
		var3 = vm.f32(var7 * -1.0)
	else
		var3 = var7
	end
	event.SetCharaPos(arg0, var3, var4, var5)
	event.SetCharaRot(arg0, 0.0, 3.1415927, 0.0)
	event.SetMotion(arg0, "待機", 4)
end

--- Helper function.
local function helper_2782c()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		var1 = 8
		var2 = 1
		var2 = var2 + 1
		var2 = var2 + 1
		var2 = var2 + 1
		helper_1ed3c(var1, var2)
		var1 = var1 + 1
		var2 = var2 + 1
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(0) or var0
	event.AssignStack(4)
	event.ClearStack(4)
	event.AssignStack(5)
	event.ClearStack(5)
	var1 = 8
	event.InitLocalCnt()
	var2 = 1
	while var2 <= 25 do
		var3 = event.GetNpcStatus(var2) or var3
		if var3 == 0 then
			var2 = var2 + 1
			continue
		end
		if bit32.band(var3, 4) ~= 0 then
			var2 = var2 + 1
			continue
		end
		var4 = event.GetNpcTrainEtc(0, var2) or var4
		if var0 ~= var4 then
			var2 = var2 + 1
			continue
		end
		event.LoadCharaNpc(1, 5, var2, var1)
		helper_1ed3c(var1, var2)
		event.SetLocalCnt(var1, var2)
		event.SetCharaNo(var1, var2)
		if bit32.band(var3, 1) ~= 0 then
			event.CharaActive(0, var1)
		else
			event.CharaActive(var1)
		end
		var1 = vm.i32(var1 + 1)
		var2 = var2 + 1
	end
	flag = event.GetFlag(254) or flag
	if flag ~= 0 and var0 == 3 then
		event.LoadChara(5, "event/train/tp02_01a.gltf", "info", var1)
		event.SetCharaPos(var1, 0.0, 0.0, -200.0)
		event.SetCharaRot(var1, 0.0, 0.0, 0.0)
		event.SetMotion(var1, "立ち", 4)
		event.SetLocalCnt(var1, 34)
		event.SetCharaNo(var1, 34)
		event.CharaActive(var1)
	end
end

--- Helper function.
local function helper_28238(arg0: f32)
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	do
		local _, out2, _ = event.GetCharaRot(0)
		var2 = out2 or var2
	end
	var4 = vm.f32(arg0 + vm.f32(6.2831855))
	var5 = vm.f32(var2 + vm.f32(6.2831855))
	var6 = vm.f32(var4 - var5)
	if var6 < 0 then
		var6 = vm.f32(var6 * -1.0)
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	if vm.f32(3.1415927) < var6 then
		var6 = vm.f32(var6 - vm.f32(3.1415927))
	end
	event.Initialize()
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsRotation(0, 0.0, arg0, 0.0, vm.ftoi(vm.f32(var6 * 10.0)))
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(1)
	end
	event.ObjsSetMotion(0, "立ち")
	event.Finish()
end

--- Helper function.
local function helper_1c1c0(arg0: s32)
	local flag: s32 = 0
	local flag_2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		return 0
	end
	var3 = event.GetCnt(1) or var3
	print("CheckTrainDoor,station_id=", var3, ",lr=", arg0, "-----------------------------\n")
	if var3 == 2 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 3 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 4 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 5 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 6 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 7 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if var3 == 8 then
		if arg0 ~= 0 then
			return 0
		else
			return 1
		end
	end
	if var3 == 9 then
		if arg0 ~= 0 then
			return 1
		else
			return 0
		end
	end
	if arg0 ~= 0 then
		return 0
	else
		return 1
	end
end

--- Helper function.
local function helper_280a4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 8
			var0 = var0 + 1
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = 8
	while var0 < 20 do
		event.DeleteChara(var0)
		event.DeleteVillager(var0)
		var0 = var0 + 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_1a264()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 7 then
			return
		end
		if at <= 8 then
			return
		end
		if at <= 9 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetCnt(1) or var0
	if var0 == 2 then
		event.MapJump(-1, "s02")
		if vm.wait() then
			return skip(2)
		end
		return
	end
	if var0 == 3 then
		event.MapJump(-1, "s04")
		if vm.wait() then
			return skip(3)
		end
		return
	end
	if var0 == 4 then
		event.MapJump(-1, "s09")
		if vm.wait() then
			return skip(4)
		end
		return
	end
	if var0 == 5 then
		event.MapJump(-1, "s10")
		if vm.wait() then
			return skip(5)
		end
		return
	end
	if var0 == 6 then
		event.MapJump(-1, "s11")
		if vm.wait() then
			return skip(6)
		end
		return
	end
	if var0 == 7 then
		event.MapJump(-1, "s12")
		if vm.wait() then
			return skip(7)
		end
		return
	end
	if var0 == 8 then
		event.MapJump(-1, "s31")
		if vm.wait() then
			return skip(8)
		end
		return
	end
	if var0 == 9 then
		event.MapJump(-1, "s34")
		if vm.wait() then
			return skip(9)
		end
		return
	end
	event.MapJump(-1, "i02h01")
	if vm.wait() then
		return skip(10)
	end
end

--- Helper function.
local function helper_2873c()
	local active_chr_no: s32 = 0
	local var1: s32 = 0
	local rot_x: f32 = 0
	local rot_y: f32 = 0
	local rot_z: f32 = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = 86
			var1 = 64
			helper_db7d11d7(0)
		end
		if at <= 2 then
			helper_db7d11d7(0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no ~= 1 then
		var1 = 86
	else
		var1 = 64
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "立ち", 4)
	do
		local out1, out2, out3 = event.EohGetRot(0)
		rot_x = out1 or rot_x
		rot_y = out2 or rot_y
		rot_z = out3 or rot_z
	end
	do
		local out1, out2, out3 = event.GetCameraPos()
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	event.ObjsReference(0, pos_x, pos_y, pos_z, 6)
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetMotion(0, "だめだめ", 6)
	event.ObjsNextMotion(0, "立ち", 4)
	event.ObjsRotDelay(0, var1)
	event.ObjsRotation(0, rot_x, rot_y, rot_z, 6)
	helper_db7d11d7(0)
	if vm.skipping() then
		return skip(3)
	end
	event.Finish()
end

--- Helper function.
local function helper_2515c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_13e53048(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

--- Helper function.
local function helper_25260()
	local var0: s32 = 0
	local var1: s32 = 0
	local language_code: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_2515c(15)
		end
		if at <= 2 then
			helper_2515c(1)
		end
		if at <= 3 then
			helper_2515c(6)
		end
		if at <= 4 then
			helper_2515c(0)
		end
		if at <= 5 then
			helper_2515c(4)
		end
		if at <= 6 then
			helper_2515c(31)
		end
		if at <= 7 then
			helper_2515c(35)
		end
		if at <= 8 then
			helper_2515c(36)
		end
		if at <= 9 then
			helper_2515c(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	language_code = event.GetLanguage() or language_code
	if language_code ~= 0 then
		event.MesMake_2(0, "Welcome.")
	else
		event.MesMake_2(0, "いらっしゃい。")
		if var0 == 18 then
			event.MesMake_2(0, "神の力を借りますか？なら、\n教会への寄付をお願いします。")
		end
		if var0 == 4 then
			event.MesMake_2(
				0,
				"がんばってんな。\n何かいるか？<page>ただし、ユリスからでも\n金はもらうぜ。"
			)
		end
		if var0 == 34 then
			event.MesMake_2(
				0,
				"ジオラマの材料が足りないのかな？\n自分で集めるのが面倒なら、\nお金で解決するのもアリじゃよ。"
			)
		end
		if var0 == 1012 then
			flag = event.GetFlag(45) or flag
			if flag == 0 then
				event.MesMake_2(
					0,
					"こんにちは。私、パン職人見習いで、\nポリーおばさんの留守中、\nお店を切り盛りしてるんだ。<page>ちょっと不安だけど、\nこれも修行の１つと思って\n頑張るわ。"
				)
				event.SetFlag(45, 1)
			end
		end
		if var0 == 1015 then
			flag_2 = event.GetFlag(46) or flag_2
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"姉みたいにセクシーじゃないけど・・・\n一応、これでもミレーネの妹なんです。<page>姉がいない間、仕方なく\nここの店番をしてるの。\n武器のことなんて、全くの素人なんだけど・・・"
				)
				event.SetFlag(46, 1)
			end
		end
		if var0 == 1018 then
			flag_3 = event.GetFlag(47) or flag_3
			if flag_3 == 0 then
				event.MesMake_2(
					0,
					"びっくりしたかな？\n教会にこんな服装で突っ立っていたら、\n誰だって驚くよな。<page>オレはブルーノ神父の親友で\n旅に出ている間の留守を頼まれたんだ。\nさて、何かお困りかな？"
				)
				event.SetFlag(47, 1)
			else
				event.MesMake_2(
					0,
					"神の力を借りますか？なら、\n教会への寄付をお願いします。"
				)
			end
		end
	end
	if var1 ~= -1 then
		helper_df67154e(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_2515c(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_2515c(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_2515c(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_2515c(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_2515c(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_2515c(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_2515c(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_2515c(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_2515c(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_1ccf8(arg0: s32, arg1: s32)
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
local function helper_1fe54(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_19a74323(1)
		helper_1ed3c(arg0, argc)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.EyeViewDrawOnOff(0)
	event.SetMesEtc(1, 4, -1, -1, -1, -1)
	event.SetMesEtc(1, 9, -1, -1)
	if arg1 ~= 0 then
		helper_19a74323(1)
	else
		event.SetMesPreset(1, 3)
	end
	event.Finish()
	if arg1 == 0 then
		argc = event.GetLocalCnt(arg0) or argc
		helper_1ed3c(arg0, argc)
	end
end

--- Helper function.
local function helper_84d0(arg0: s32, arg1: any, arg2: s32, arg3: s32, arg4: s32)
	local var6: s32 = 0
	local _: any
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
			_, var6 = helper_6fdd737a(arg0, 0, var6)
		end
		helper_19a74323(arg0)
	end
	if vm.skipping() then
		return skip(1)
	end
	local _ = helper_0924108c(arg0, arg1, arg2, arg3, arg4)
	_, var6 = helper_6fdd737a(arg0, 0, var6)
	if vm.skipping() then
		return skip(2)
	end
	helper_19a74323(arg0)
end

--- Helper function.
local function helper_200fc(arg0: s32, arg1: s32, arg2: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		helper_1fe54(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(25)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg2)
	if vm.wait() then
		return skip(3)
	end
	helper_1fe54(arg0, arg1)
	event.SetFadeIn(30)
end

--- Helper function.
local function helper_1f25c()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return 1
		end
		if at <= 2 then
			helper_93fd01b9(3, 1)
			helper_84d0(3, -1, 3, 256, 208)
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
		helper_93fd01b9(3, 1)
		event.MesMake_2(3, "もっとスクープを撮って来ないと\n賞品はやれないぜ。")
		helper_84d0(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == 2 then
		helper_93fd01b9(3, 1)
		event.MesMake_2(
			3,
			"ネタかスクープの数によって、\nオマエの写真家レベルが決まる。<page>レベルが上がれば、ごほうびの\nアイテムも増えるぞ。"
		)
		helper_84d0(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
	end
	return 0
end

--- Helper function.
local function helper_1f6a4()
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
			return helper_1f25c()
		end
		if at <= 3 then
			helper_93fd01b9(3, 1)
			helper_84d0(3, -1, 3, 256, 208)
		end
		return helper_1f25c()
	end
	argc = event.GetItemHaveNum(355) or argc
	if argc <= 0 then
		helper_93fd01b9(3, 1)
		event.MesMake_2(3, "スクープメモを\n買ってくれ。")
		helper_84d0(3, -1, 3, 256, 208)
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
		helper_93fd01b9(3, 1)
		event.MesMake_2(3, "もう、スクープは\nなさそうだな。")
		helper_84d0(3, -1, 3, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		return helper_1f25c()
	end
	var3 = event.GetMenuEtc_2(3) or var3
	if 0 < var3 then
		helper_93fd01b9(3, 8)
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "スクープ条件が、[数値１]個\n明らかになった。")
		event.SetMesDrawspeed(3, 0)
		helper_84d0(3, -1, 8, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	helper_93fd01b9(3, 1)
	var3 = event.GetMenuEtc_2(4) or var3
	if var3 <= 0 then
		event.MesMake_2(3, "なんだよ、スクープなんて\n撮れてないじゃないか。")
	else
		event.SetMesValue(3, 1, var3)
		event.MesMake_2(3, "お、[数値１]枚もスクープが\n撮れてるじゃん。さすがだな。")
	end
	helper_84d0(3, -1, 3, 256, 208)
	if vm.skipping() then
		return skip(4)
	end
	return helper_1f25c()
end

--- Helper function.
local function helper_1de30()
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
local function helper_20230(arg0: s32, arg1: s32)
	local argc: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local var9: f32 = 0
	local var11: s32 = 0
	local var12: f32 = 0
	local var13: f32 = 0
	local var14: f32 = 0
	local var15: f32 = 0
	local var16: f32 = 0
	local var17: f32 = 0
	local var18: f32 = 0
	local var19: f32 = 0
	local var20: f32 = 0
	local var21: f32 = 0
	local var22: f32 = 0
	local var23: f32 = 0
	local var24: any = 0
	local var25: s32 = 0
	local var26: s32 = 0
	local var27: s32 = 0
	local var28: s32 = 0
	local argc_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			argc = 1
			argc = 2
			argc = 13
			return
		end
		if at <= 5 then
			if at <= 2 then
				var24 = 0
				helper_93fd01b9(3, 1)
				helper_1ccf8(3, argc)
				var25 = -1
				helper_0924108c(3, var25, 3, 256, 208)
				helper_93fd01b9(1, 8)
				helper_0924108c(1, 1, 1, 0, 0)
				helper_93fd01b9(2, 2)
				var25 = 30
				var25 = 31
				var25 = 32
				var24 = helper_f4e03b9a(2, var25, 7, 0, 0, var28, var28 - 1)
			end
			if at <= 3 then
				helper_19a74323(3)
				helper_13e53048(30)
			end
			helper_1fe54(arg0, arg1)
			return
		end
		if at <= 10 then
			if at <= 6 then
				helper_93fd01b9(3, 8)
				helper_84d0(3, var25, 9, 0, 0)
			end
			if at <= 7 then
				helper_84d0(3, -1, 3, 256, 208)
			end
			if at <= 8 then
				helper_1fe54(arg0, arg1)
				helper_200fc(arg0, arg1, 6)
			end
			if at <= 9 then
				helper_200fc(arg0, arg1, 23)
			end
			return
		end
		if at <= 12 then
			if at <= 11 then
				helper_200fc(arg0, arg1, 33)
			end
			return
		end
		if at <= 13 then
			helper_200fc(arg0, arg1, 1)
		end
		if at <= 14 then
			helper_200fc(arg0, arg1, 2)
		end
		if at <= 15 then
			helper_200fc(arg0, arg1, 3)
		end
		if at <= 16 then
			helper_200fc(arg0, arg1, 7)
		end
		if at <= 17 then
			helper_200fc(arg0, arg1, 8)
		end
		if at <= 18 then
			helper_200fc(arg0, arg1, 9)
		end
		if at <= 19 then
			helper_200fc(arg0, arg1, 10)
		end
		if at <= 20 then
			helper_200fc(arg0, arg1, 11)
		end
		if at <= 21 then
			helper_200fc(arg0, arg1, 12)
		end
		if at <= 22 then
			helper_200fc(arg0, arg1, 13)
		end
		if at <= 23 then
			helper_200fc(arg0, arg1, 14)
		end
		if at <= 24 then
			helper_200fc(arg0, arg1, 15)
		end
		if at <= 25 then
			helper_200fc(arg0, arg1, 16)
		end
		if at <= 26 then
			helper_200fc(arg0, arg1, 17)
		end
		if at <= 27 then
			helper_200fc(arg0, arg1, 18)
		end
		if at <= 28 then
			helper_200fc(arg0, arg1, 19)
		end
		if at <= 29 then
			helper_200fc(arg0, arg1, 20)
		end
		if at <= 30 then
			helper_200fc(arg0, arg1, 21)
		end
		if at <= 31 then
			helper_200fc(arg0, arg1, 22)
		end
		if at <= 32 then
			helper_200fc(arg0, arg1, 32)
		end
		if at <= 33 then
			helper_1de30()
			helper_84d0(3, -1, 3, 256, 208)
		end
		if at <= 34 then
			helper_1fe54(arg0, arg1)
			helper_13e53048(30)
		end
		helper_1fe54(arg0, arg1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		argc = 1
	elseif arg1 == 2 then
		argc = 2
	elseif arg1 == 3 then
		argc = 13
	else
		argc = event.GetLocalCnt(arg0) or argc
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	if argc == now_party_chara_id then
		return
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	event.SetMesPreset(1, 0)
	var4 = 0
	if argc == 10 or argc == 18 then
		var4 = 8
	end
	if argc == 1 or argc == 6 or argc == 17 then
		var4 = 16
	end
	if argc == 2 or argc == 15 or argc == 16 or argc == 19 or argc == 20 or argc == 21 or argc == 22 then
		var4 = 24
	end
	if argc == 3 or argc == 4 or argc == 5 or argc == 7 or argc == 8 or argc == 23 or argc == 24 then
		var4 = 32
	end
	if argc == 9 or argc == 11 or argc == 13 then
		var4 = 40
	end
	event.SetMesEtc(1, 4, 30, 60, 144, -1)
	event.SetMesEtc(1, 9, 20 + var4, 16)
	event.EyeViewDrawOnOff(1)
	if arg1 ~= 0 then
		event.EohSyncChara(0, arg0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
		end
		do
			local _, out2, _ = event.EohGetRot(0)
			var9 = out2 or var9
		end
	else
		var11 = event.GetNpcTrainEtc(1, argc) or var11
		do
			local out1, out2, out3, out4 = event.GetTrainNpcPos(var11)
			var5 = out1 or var5
			var6 = out2 or var6
			var7 = out3 or var7
			var9 = out4 or var9
		end
		event.EohSyncChara(0, arg0)
		event.EohSetPos(0, var5, var6, var7)
		event.EohSetRot(0, 0.0, var9, 0.0)
		event.SetMotion(arg0, "立ち", 4)
	end
	var12 = vm.f32(vm.sin(var9) * 75.0)
	var12 = vm.f32(var12 + var5)
	var13 = vm.f32(var6 + 45.0)
	var14 = vm.f32(vm.cos(var9) * 75.0)
	var14 = vm.f32(var14 + var7)
	event.SetCameraPos(var12, var13, var14)
	var15 = var5
	var16 = vm.f32(var6 + 30.0)
	var17 = var7
	event.SetCameraRef(var15, var16, var17)
	var18 = vm.f32(vm.sin(var9) * 30.0)
	var18 = vm.f32(var18 + var5)
	var19 = var6
	var20 = vm.f32(vm.cos(var9) * 30.0)
	var20 = vm.f32(var20 + var7)
	event.SetCharaPos(0, var18, var19, var20)
	var21 = 0
	var22 = vm.f32(var9 + vm.f32(3.1415927))
	if var22 > vm.f32(3.1415927) then
		var22 = vm.f32(var22 - vm.f32(6.2831855))
	end
	var23 = 0
	event.SetCharaRot(0, var21, var22, var23)
	if vm.wait() then
		return skip(2)
	end
	event.SetCrossfade(10)
	var24 = 0
	while true do
		helper_93fd01b9(3, 1)
		var26 = event.GetChapter() or var26
		if var26 ~= 8 then
			var25 = event.GetPartyCharaMesNo_3(argc, 2) or var25
		else
			helper_1ccf8(3, argc)
			var25 = -1
		end
		event.SetMesDrawspeed(3, 0, 0)
		helper_0924108c(3, var25, 3, 256, 208)
		helper_93fd01b9(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var27 = event.GetPartyCharaMesNo_3(argc, 0) or var27
		event.SetMesItemDirect(1, 1, var27)
		helper_0924108c(1, 1, 1, 0, 0)
		helper_93fd01b9(2, 2)
		do
			local out1, out2 = event.GetPartyCharaMesNo_4(argc, 4)
			var25 = out1 or var25
			var28 = out2 or var28
		end
		if var28 == 3 then
			var25 = 30
		end
		if var28 == 4 then
			event.SetMesItemDirect(2, 1, var25)
			var25 = 31
		end
		if var28 == 5 then
			event.SetMesItemDirect(2, 1, var25)
			event.SetMesItemDirect(2, 2, vm.i32(var25 + 1))
			var25 = 32
		end
		var24 = helper_f4e03b9a(2, var25, 7, 0, 0, var28, vm.i32(var28 - 1))
		if vm.skipping() then
			return skip(3)
		end
		helper_19a74323(3)
		if var24 == 0 then
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_13e53048(30)
				if vm.skipping() then
					return skip(4)
				end
				if arg1 == 0 then
					event.CharaActive(0, arg0)
					argc_2 = event.GetLocalCnt2(now_party_chara_id) or argc_2
					if 0 <= argc_2 then
						event.CharaActive(argc_2)
					end
				end
				event.SetNpcStatus(argc, 1)
				event.GotoSelectParty()
				if vm.wait() then
					return skip(5)
				end
				helper_1fe54(arg0, arg1)
				event.SetFadeIn(30)
				return
			end
			helper_93fd01b9(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			helper_84d0(3, -1, 9, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var24 == 1 then
			helper_93fd01b9(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var25 = event.GetPartyCharaMesNo_3(argc, 3) or var25
			helper_84d0(3, var25, 9, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var28 then
			if var28 == 5 then
				if var24 == 2 then
					if argc == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "よし、これで\n修理完了じゃ！")
						helper_84d0(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(8)
						end
						helper_1fe54(arg0, arg1)
						event.SetCrossfade(10)
					end
					if not (argc == 4) then
						break
					end
					helper_200fc(arg0, arg1, 6)
					if vm.skipping() then
						return skip(9)
					end
					break
				end
				if var24 == 3 then
					if argc == 1 then
						helper_200fc(arg0, arg1, 23)
						if vm.skipping() then
							return skip(10)
						end
						return
					end
					if argc == 4 then
						local t0 = helper_1f6a4()
						if vm.skipping() then
							return skip(11)
						end
						if t0 ~= 0 then
							helper_200fc(arg0, arg1, 33)
							if vm.skipping() then
								return skip(12)
							end
							return
						end
					end
				end
				if var24 == 4 then
					break
				end
				if var24 == -1 then
					break
				end
			else
				if var24 == 2 then
					if argc == 15 then
						helper_200fc(arg0, arg1, 0)
						if vm.skipping() then
							return skip(13)
						end
					end
					if argc == 12 then
						helper_200fc(arg0, arg1, 1)
						if vm.skipping() then
							return skip(14)
						end
					end
					if argc == 6 then
						helper_200fc(arg0, arg1, 2)
						if vm.skipping() then
							return skip(15)
						end
					end
					if argc == 7 then
						helper_200fc(arg0, arg1, 3)
						if vm.skipping() then
							return skip(16)
						end
					end
					if argc == 2 then
						helper_200fc(arg0, arg1, 7)
						if vm.skipping() then
							return skip(17)
						end
					end
					if argc == 3 then
						helper_200fc(arg0, arg1, 8)
						if vm.skipping() then
							return skip(18)
						end
					end
					if argc == 5 then
						helper_200fc(arg0, arg1, 9)
						if vm.skipping() then
							return skip(19)
						end
					end
					if argc == 8 then
						helper_200fc(arg0, arg1, 10)
						if vm.skipping() then
							return skip(20)
						end
					end
					if argc == 10 then
						helper_200fc(arg0, arg1, 11)
						if vm.skipping() then
							return skip(21)
						end
					end
					if argc == 11 then
						helper_200fc(arg0, arg1, 12)
						if vm.skipping() then
							return skip(22)
						end
					end
					if argc == 13 then
						helper_200fc(arg0, arg1, 13)
						if vm.skipping() then
							return skip(23)
						end
					end
					if argc == 16 then
						helper_200fc(arg0, arg1, 14)
						if vm.skipping() then
							return skip(24)
						end
					end
					if argc == 18 then
						helper_200fc(arg0, arg1, 15)
						if vm.skipping() then
							return skip(25)
						end
					end
					if argc == 19 then
						helper_200fc(arg0, arg1, 16)
						if vm.skipping() then
							return skip(26)
						end
					end
					if argc == 20 then
						helper_200fc(arg0, arg1, 17)
						if vm.skipping() then
							return skip(27)
						end
					end
					if argc == 21 then
						helper_200fc(arg0, arg1, 18)
						if vm.skipping() then
							return skip(28)
						end
					end
					if argc == 22 then
						helper_200fc(arg0, arg1, 19)
						if vm.skipping() then
							return skip(29)
						end
					end
					if argc == 23 then
						helper_200fc(arg0, arg1, 20)
						if vm.skipping() then
							return skip(30)
						end
					end
					if argc == 24 then
						helper_200fc(arg0, arg1, 21)
						if vm.skipping() then
							return skip(31)
						end
					end
					if argc == 25 then
						helper_200fc(arg0, arg1, 22)
						if vm.skipping() then
							return skip(32)
						end
					end
					if argc == 17 then
						helper_200fc(arg0, arg1, 32)
						if vm.skipping() then
							return skip(33)
						end
					end
					if argc == 9 then
						helper_1de30()
						event.SetMesDrawspeed(3, 0.6, 0.6)
						helper_84d0(3, -1, 3, 256, 208)
						if vm.skipping() then
							return skip(34)
						end
						helper_1fe54(arg0, arg1)
						event.SetCrossfade(10)
					end
					if argc == 14 then
						event.SetFadeOut(25)
						helper_13e53048(30)
						if vm.skipping() then
							return skip(35)
						end
						event.GotoMenu(25)
						if vm.wait() then
							return skip(36)
						end
						helper_1fe54(arg0, arg1)
						event.SetFadeIn(30)
					end
					return
				end
				if var24 == 3 then
					break
				end
				if var24 == -1 then
					break
				end
			end
		else
			if var24 == 2 then
				break
			end
			if var24 == -1 then
				break
			end
		end
	end
	helper_1fe54(arg0, arg1)
	event.SetCrossfade(10)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	helper_1ef0d4b2()
	event.Initialize()
	print("##IN_START_EVENT################################\n")
	helper_2782c()
	event.SetMotion(0, "立ち")
	event.SetMesPreset(1, 3)
	event.ResetCamera(1)
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_1c1c0(1)
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_280a4()
		end
		if at <= 3 then
			helper_1a264()
		end
		if at <= 4 then
			helper_2873c()
		end
	end
	print("--------------------------event200-------------------------\n")
	helper_28238(vm.f32(-1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_1c1c0(1)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_13e53048(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 1)
		helper_280a4()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_1a264()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_2873c()
		if vm.skipping() then
			return skip(5)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var1 = helper_1c1c0(0)
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_280a4()
		end
		if at <= 3 then
			helper_1a264()
		end
		if at <= 4 then
			helper_2873c()
		end
	end
	print("--------------------------event201-------------------------\n")
	helper_28238(vm.f32(1.5707964))
	if vm.skipping() then
		return skip(1)
	end
	var0 = event.GetSndId(2) or var0
	var1 = helper_1c1c0(0)
	if var1 ~= 0 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_13e53048(30)
		if vm.skipping() then
			return skip(2)
		end
		event.SetCnt(15, 0)
		helper_280a4()
		if vm.skipping() then
			return skip(3)
		end
		event.StopBgm(0)
		helper_1a264()
		if vm.skipping() then
			return skip(4)
		end
	else
		helper_2873c()
		if vm.skipping() then
			return skip(5)
		end
	end
end

--- Program 202.
script[202] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_280a4()
		end
		var1 = var1 - 1
		helper_2782c()
	end
	print("--------------------------event202-------------------------\n")
	helper_28238(0.0)
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	event.SndSePlay(var0, 94)
	event.SetFadeOut(30)
	helper_13e53048(30)
	if vm.skipping() then
		return skip(2)
	end
	helper_280a4()
	if vm.skipping() then
		return skip(3)
	end
	var1 = event.GetCnt(0) or var1
	if var1 == 1 then
		event.SetCnt(0, 0)
		event.SetCharaPos(0, 0.0, -22.4, -207.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.MapJump(-1, "s37")
	else
		var1 = vm.i32(var1 - 1)
		event.SetCnt(0, var1)
		helper_2782c()
		event.SetCharaPos(0, 0.0, -14.0, -235.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 203.
script[203] = function()
	local var0: s32 = 0
	local var1: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_13e53048(30)
		end
		if at <= 2 then
			helper_280a4()
		end
		if at <= 3 then
			var1 = vm.i32(var1 + 1)
			helper_2782c()
			helper_2873c()
		end
	end
	print("--------------------------event203-------------------------\n")
	helper_28238(vm.f32(3.1415927))
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち")
	var0 = event.GetSndId(2) or var0
	var1 = event.GetCnt(0) or var1
	if var1 ~= 3 then
		event.SetMotion(0, "立ち")
		event.SndSePlay(var0, 94)
		event.SetFadeOut(30)
		helper_13e53048(30)
		if vm.skipping() then
			return skip(2)
		end
		helper_280a4()
		if vm.skipping() then
			return skip(3)
		end
		var1 = vm.i32(var1 + 1)
		event.SetCnt(0, var1)
		helper_2782c()
		event.SetCharaPos(0, 0.0, -14.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.1415927, 0.0)
		event.Initialize()
		event.MesClose(1)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_2873c()
		if vm.skipping() then
			return skip(4)
		end
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_20230(var0, 0)
		end
	end
	var0 = event.GetEventData_2(13) or var0
	argc = event.GetLocalCnt(var0) or argc
	if argc == 34 then
		helper_25260()
		if vm.skipping() then
			return skip(1)
		end
	else
		helper_20230(var0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
end

return script
