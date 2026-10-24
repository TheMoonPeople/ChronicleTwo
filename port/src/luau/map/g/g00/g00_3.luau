--!strict
-- map/g/g00/g00_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_53ffa82b = require("@lib/event/helper_53ffa82b")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_86338593 = require("@lib/event/helper_86338593")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_9a932dc0 = require("@lib/event/helper_9a932dc0")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_d433b297 = require("@lib/event/helper_d433b297")
local helper_ea5b1c9f = require("@lib/event/helper_ea5b1c9f")

--- Helper function.
local function helper_20788(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local var4: s32 = 0
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		if arg1 == 1 then
			flag = event.GetFlag(57) or flag
			if flag == 0 then
				event.SetFlag(57, 1)
				event.MesMake_2(
					arg0,
					"Ich wohne jetzt hier,\naber ich mache mir mehr Sorgen\num Blackstone Eins.<page>Ich werde mich darum k[UNI00fc]mmern,\ndass der Zug f[UNI00e4]hrt - wie\nin den alten Zeiten."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_907fd9a8(var4, -1, 0, 0)
				event.MesMake_2(
					arg0,
					"Borneo ist etwas ungeschickt,\nund Erik ist blo[UNI00df] ein Kind.<page>Nichts als Schlafen, Arbeiten,\nSchlafen und wieder Arbeiten\nf[UNI00fc]r Leute wie mich.<page>Aber so ist das Leben, was ...?"
				)
			else
				event.MesMake_2(arg0, "Wie geht's Steve?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "Ich schaff's nicht, blo[UNI00df]\nD[UNI00e4]umchen zu drehen.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Pflanzen und Blumen wachsen\nnur, wenn man sie pflegt. Ich\nk[UNI00f6]nnte meine Kleinen nie verlassen."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Ob der geheime St[UNI00fc]tzpunkt wohl in\nOrdnung ist? Ich kann niemand hin-\nschicken, er ist ja geheim, nicht?"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Lila ist eine tolle Farbe.\nEs hat so eine warme K[UNI00e4]lte,\nund eine helle Dunkelheit."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Wenn jemand krank ist, komme\nich [UNI00fc]berall hin, um zu helfen.")
		end
		if arg1 == 7 then
			event.MesMake_2(arg0, "Nur ein Spitzenkoch kann\njederzeit und [UNI00fc]berall\ntolles Essen machen.")
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Bei H[UNI00e4]usern gilt: Je\nrobuster, desto besser, stimmt's?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"N[UNI00fc]sse sind nicht schlecht, aber\ndiese roten Dinger waren super.\nK[UNI00f6]nntest du noch welche holen?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Feuchte Luft ist Gift f[UNI00fc]r\nB[UNI00fc]cher. Ich k[UNI00f6]nnte es nie\nertragen, am Wasser zu wohnen."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"Sie sind weder s[UNI00fc][UNI00df] noch\nmodern, aber meine Kleider\nkann sonst niemand machen."
			)
		end
		if arg1 == 12 then
			event.MesMake_2(
				arg0,
				"Ein neues Haus, ein neues Ich.\nIch f[UNI00fc]hl mich wieder wie\nein junger B[UNI00e4]cker."
			)
		end
		if arg1 == 13 then
			event.MesMake_2(
				arg0,
				"Mir ist egal, was es ist,\naber ich will irgendetwas in\neine Million Teile zerschlagen!"
			)
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Wenn du ein neues Monster findest,\nberichte sofort davon.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Manche sagen, das ist nichts f[UNI00fc]r\nFrauen, aber dem Schwert ist das\negal. M[UNI00f6]ge der Bessere gewinnen."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "In diesem H[UNI00e4]uschen k[UNI00f6]nnte man\ngut eine Familie gr[UNI00fc]nden.")
		end
		if arg1 == 17 then
			event.MesMake_2(arg0, "Ob Morton wohl am Ball bleibt?\nIch mach mir Sorgen um ihn ...")
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Falls du eine Stadt wei[UNI00df]t, die\neine Kirche braucht, bin ich\ndein Priester. Sag nur Bescheid."
			)
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"Ich denke in letzter Zeit nicht\nmehr oft an den Mond. Das muss\nan meinen neuen Freunden liegen."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(arg0, "Anderer Ort, andere Fische.\nMan muss sein Denken immer\nan den Ort anpassen.")
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Hier muss ein toller\nFischgrund sein.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn hat ein neues Frauen-\nportr[UNI00e4]t angefangen. Er sagt,\nsie wird noch h[UNI00fc]bscher als ich."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "Warum sieht Ungeziefer\nblo[UNI00df] so widerlich aus?")
		end
		if arg1 == 24 then
			event.MesMake_2(
				arg0,
				"Kannst du mein Haus noch\ns[UNI00fc][UNI00df]er machen? Ein Haus kann\nnie s[UNI00fc][UNI00df] genug sein!"
			)
		end
		if arg1 == 25 then
			event.MesMake_2(arg0, "H[UNI00e4]tte nie gedacht, dass ich in\ndem Alter umziehen w[UNI00fc]rde.")
		end
	else
		helper_53ffa82b(arg0, arg1)
	end
end

--- Helper function.
local function helper_21e14()
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
	helper_20788(0, var2)
	helper_907fd9a8(var1, -1, 0, 0)
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_223e0()
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
	if var2 == 18 then
		var4 = 20
	end
	if var2 == 25 then
		var4 = 24
	end
	if var2 == 12 or var2 == 17 then
		var4 = 28
	end
	if var2 == 7 then
		var4 = 32
	end
	if var2 == 10 or var2 == 6 or var2 == 24 then
		var4 = 40
	end
	if var2 == 8 or var2 == 1 or var2 == 2 or var2 == 3 or var2 == 15 or var2 == 16 or var2 == 21 then
		var4 = 44
	end
	if var2 == 4 or var2 == 19 or var2 == 20 or var2 == 22 then
		var4 = 48
	end
	if var2 == 5 or var2 == 11 or var2 == 23 or var2 == 13 then
		var4 = 52
	end
	if var2 == 9 then
		var4 = 56
	end
	event.SetMesEtc(1, 4, 30, 60, 168, -1)
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
		helper_20788(3, var2)
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
				helper_9a932dc0()
				event.SetCrossfade(10)
				return
			end
			if now_party_chara_id ~= 26 then
				event.SetFadeOut(25)
				helper_25abe6d2(30)
				event.SetNpcStatus(var2, 1)
				event.GotoSelectParty()
				vm.wait(5)
				helper_9a932dc0()
				event.SetFadeIn(30)
				return
			end
			helper_125385ee(3, 8)
			event.SetMesDrawspeed(3, 0, 0)
			event.MesMake_2(3, "[(!)]Das geht jetzt nicht. Du musst\nerst Lin zum Leuchtturm bringen!")
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
						event.MesMake_2(3, "Na gut, die Reparaturen\nsind abgeschlossen!")
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_9a932dc0()
						event.SetCrossfade(10)
					end
					if not (var2 == 4) then
						break
					end
					helper_ea5b1c9f(6)
					break
				end
				if var29 == 3 then
					if var2 == 1 then
						helper_ea5b1c9f(23)
						return
					end
					if var2 == 4 then
						if helper_86338593(3) ~= 0 then
							helper_ea5b1c9f(33)
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
						helper_ea5b1c9f(0)
					end
					if var2 == 12 then
						helper_ea5b1c9f(1)
					end
					if var2 == 6 then
						helper_ea5b1c9f(2)
					end
					if var2 == 7 then
						helper_ea5b1c9f(3)
					end
					if var2 == 2 then
						helper_ea5b1c9f(7)
					end
					if var2 == 3 then
						helper_ea5b1c9f(8)
					end
					if var2 == 5 then
						helper_ea5b1c9f(9)
					end
					if var2 == 8 then
						helper_ea5b1c9f(10)
					end
					if var2 == 10 then
						helper_ea5b1c9f(11)
					end
					if var2 == 11 then
						helper_ea5b1c9f(12)
					end
					if var2 == 13 then
						helper_ea5b1c9f(13)
					end
					if var2 == 16 then
						helper_ea5b1c9f(14)
					end
					if var2 == 18 then
						helper_ea5b1c9f(15)
					end
					if var2 == 19 then
						helper_ea5b1c9f(16)
					end
					if var2 == 20 then
						helper_ea5b1c9f(17)
					end
					if var2 == 21 then
						helper_ea5b1c9f(18)
					end
					if var2 == 22 then
						helper_ea5b1c9f(19)
					end
					if var2 == 23 then
						helper_ea5b1c9f(20)
					end
					if var2 == 24 then
						helper_ea5b1c9f(21)
					end
					if var2 == 25 then
						helper_ea5b1c9f(22)
					end
					if var2 == 17 then
						helper_ea5b1c9f(32)
					end
					if var2 == 9 then
						helper_d433b297()
						helper_a3cc6850(3, -1, 3, 256, 208)
						helper_9a932dc0()
						event.SetCrossfade(10)
					end
					if var2 == 14 then
						event.SetFadeOut(25)
						helper_25abe6d2(30)
						event.GotoMenu(25)
						vm.wait(36)
						helper_9a932dc0()
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
	helper_9a932dc0()
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
	helper_21e14()
	helper_223e0()
end

return script
