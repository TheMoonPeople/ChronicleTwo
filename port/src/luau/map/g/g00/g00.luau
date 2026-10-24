--!strict
-- map/g/g00/g00.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_1505ebf3 = require("@lib/event/helper_1505ebf3")
local helper_21ffefb1 = require("@lib/event/helper_21ffefb1")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_c0869c7f = require("@lib/event/helper_c0869c7f")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")

--- Helper function.
local function helper_1f748(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
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
		helper_1505ebf3(arg0, arg1)
	end
end

--- Helper function.
local function helper_20a60()
	local var1: s32 = 0
	local var2: s32 = 0
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
	helper_907fd9a8(var1, -1, 0, 0)
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_20d54()
	event.CharaActive(0)
	helper_6992f518(1)
	event.Finish()
end

--- Helper function.
local function helper_20e10(arg0: s32)
	event.SetFadeOut(25)
	helper_888ab2a3(30)
	event.GotoMenu(6, arg0)
	vm.wait(2)
	helper_20d54()
	event.SetFadeIn(30)
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
	vm.wait(1)
	event.SetCrossfade(10)
	var29 = 0
	while true do
		helper_125385ee(3, 1)
		helper_1f748(3, var2)
		var30 = -1
		event.SetMesDrawspeed(3, 0, 0)
		helper_125385ee(1, 8)
		event.SetMesDrawspeed(1, 0, 0)
		var31 = event.GetPartyCharaMesNo_3(var2, 0) or var31
		event.SetMesItemDirect(1, 1, var31)
		helper_82705ce2(1, 1, 1, 0, 0)
		helper_125385ee(2, 2)
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
		var29 = helper_c190f878(2, var30, 7, 0, 0, var32, vm.i32(var32 - 1))
		if var29 == 0 then
			if var2 == now_party_chara_id then
				helper_20d54()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_888ab2a3(30)
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				vm.wait(4)
				helper_20d54()
				event.SetFadeIn(30)
				return
			end
			helper_125385ee(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(
				3,
				"[(!)]今は連れて行けない。リンを\n   岬灯台に連れて行くのが先だ！"
			)
			helper_a3cc6850(3, -1, 9, 0, 0)
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if var29 == 1 then
			helper_125385ee(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			var30 = event.GetPartyCharaMesNo_3(var2, 3) or var30
			helper_a3cc6850(3, var30, 9, 0, 0)
			event.SetMesDrawspeed(3, 0, 0.6)
		end
		if 3 < var32 then
			if var32 == 5 then
				if var29 == 2 then
					if var2 == 1 then
						event.SetSavedataEtc(2)
						event.MesMake_2(3, "よし、これで\n修理完了じゃ！")
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_20d54()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_20e10(6)
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_20e10(23)
						return
					end
					if var2 == 4 then
						if helper_21ffefb1() ~= 0 then
							helper_20e10(33)
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
					end
					if var2 == 12 then
						helper_20e10(1)
					end
					if var2 == 6 then
						helper_20e10(2)
					end
					if var2 == 7 then
						helper_20e10(3)
					end
					if var2 == 2 then
						helper_20e10(7)
					end
					if var2 == 3 then
						helper_20e10(8)
					end
					if var2 == 5 then
						helper_20e10(9)
					end
					if var2 == 8 then
						helper_20e10(10)
					end
					if var2 == 10 then
						helper_20e10(11)
					end
					if var2 == 11 then
						helper_20e10(12)
					end
					if var2 == 13 then
						helper_20e10(13)
					end
					if var2 == 16 then
						helper_20e10(14)
					end
					if var2 == 18 then
						helper_20e10(15)
					end
					if var2 == 19 then
						helper_20e10(16)
					end
					if var2 == 20 then
						helper_20e10(17)
					end
					if var2 == 21 then
						helper_20e10(18)
					end
					if var2 == 22 then
						helper_20e10(19)
					end
					if var2 == 23 then
						helper_20e10(20)
					end
					if var2 == 24 then
						helper_20e10(21)
					end
					if var2 == 25 then
						helper_20e10(22)
					end
					if var2 == 17 then
						helper_20e10(32)
					end
					if var2 == 9 then
						helper_c0869c7f()
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_20d54()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_888ab2a3(30)
						event.GotoMenu(25)
						vm.wait(35)
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

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_c6c63376

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_c6c63376()
	event.ResetCamera(1, 0.0)
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.MesMake_2(0, "お洒落")
	helper_a3cc6850(0, -1, 8, 0, 0)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	helper_20a60()
	helper_20f2c()
end

return script
