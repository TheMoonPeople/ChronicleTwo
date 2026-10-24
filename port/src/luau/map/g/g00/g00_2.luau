--!strict
-- map/g/g00/g00_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_40864615 = require("@lib/event/helper_40864615")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_9a932dc0 = require("@lib/event/helper_9a932dc0")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_c6c63376 = require("@lib/event/helper_c6c63376")
local helper_ea5b1c9f = require("@lib/event/helper_ea5b1c9f")
local helper_f3578ab6 = require("@lib/event/helper_f3578ab6")
local helper_ff1e56f8 = require("@lib/event/helper_ff1e56f8")

--- Helper function.
local function helper_208a8(arg0: s32, arg1: s32)
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
					"J'habite ici maintenant,\nmais je m'inqui[UNI00e8]te\ndavantage pour Noirpierre I.<page>C'est moi qui vais\nfaire fonctionner le\ntrain, comme avant."
				)
				var4 = event.GetEventData_2(13) or var4
				helper_907fd9a8(var4, -1, 0, 0)
				event.MesMake_2(
					arg0,
					"Born[UNI00e9]o est un peu maladroit,\net [UNI00c9]rik encore bien jeune.<page>Pour les types comme moi,\nla vie se r[UNI00e9]sume [UNI00e0] maison-\nboulot-dodo jour apr[UNI00e8]s jour.<page>Mais que veux-tu, c'est la vie..."
				)
			else
				event.MesMake_2(arg0, "Et Steve, que devient-il ?")
			end
		end
		if arg1 == 2 then
			event.MesMake_2(arg0, "Je n'en peux plus de rester dans ma\nchambre [UNI00e0] me tourner les pouces.")
		end
		if arg1 == 3 then
			event.MesMake_2(
				arg0,
				"Plantes et fleurs ne s'[UNI00e9]panouissent\nque lorsqu'on s'en occupe. Jamais\nje ne pourrais les n[UNI00e9]gliger."
			)
		end
		if arg1 == 4 then
			event.MesMake_2(
				arg0,
				"Je me demande ce que devient la\nbase secr[UNI00e8]te. Je ne peux pas faire\nv[UNI00e9]rifier, [UNI00e7]a reste un secret !"
			)
		end
		if arg1 == 5 then
			event.MesMake_2(
				arg0,
				"Le violet est une couleur superbe.\nSa fra[UNI00ee]cheur est... chaleureuse et\nson c[UNI00f4]t[UNI00e9] sombre... lumineux."
			)
		end
		if arg1 == 6 then
			event.MesMake_2(arg0, "Je pourrais aller au bout du monde\npour aider un malade.")
		end
		if arg1 == 7 then
			event.MesMake_2(
				arg0,
				"Seul un grand chef peut concocter \ndes plats d[UNI00e9]licieux quel que \nsoit l'endroit o[UNI00f9] il se trouve."
			)
		end
		if arg1 == 8 then
			event.MesMake_2(arg0, "Les maisons, plus elles sont\nsolides, mieux c'est, non ?")
		end
		if arg1 == 9 then
			event.MesMake_2(
				arg0,
				"Les noix, c'est bon, mais ces trucs\nrouges sont vraiment d[UNI00e9]licieux. Tu\npourrais m'en ramener d'autres ?"
			)
		end
		if arg1 == 10 then
			event.MesMake_2(
				arg0,
				"Le pire ennemi du livre, c'est\nl'humidit[UNI00e9]. Je ne supporterais\npas d'habiter pr[UNI00e8]s de l'eau."
			)
		end
		if arg1 == 11 then
			event.MesMake_2(
				arg0,
				"Mes v[UNI00ea]tements ne sont ni jolis, ni\ndans le vent, mais je peux faire\ndes habits comme personne."
			)
		end
		if arg1 == 12 then
			event.MesMake_2(arg0, "Ce lieu m'a rajeunie. Comme si\nje redevenais une jeune boulang[UNI00e8]re.")
		end
		if arg1 == 13 then
			event.MesMake_2(arg0, "Peu importe quoi,\nj'ai juste envie de\npulv[UNI00e9]riser quelque chose !")
		end
		if arg1 == 14 then
			event.MesMake_2(arg0, "Si tu d[UNI00e9]couvres un nouveau monstre,\nsignale-le imm[UNI00e9]diatement.")
		end
		if arg1 == 15 then
			event.MesMake_2(
				arg0,
				"Certains disent que c'est pas pour\nles femmes, mais l'[UNI00e9]p[UNI00e9]e s'en moque\nbien, elle. Le meilleur l'emporte."
			)
		end
		if arg1 == 16 then
			event.MesMake_2(arg0, "Cette petite maison pourrait faire\nl'affaire pour [UNI00e9]lever des enfants.")
		end
		if arg1 == 17 then
			event.MesMake_2(
				arg0,
				"Je me demande si Morton arrive [UNI00e0] se\nd[UNI00e9]brouiller. Il m'inqui[UNI00e8]te un peu."
			)
		end
		if arg1 == 18 then
			event.MesMake_2(
				arg0,
				"Si tu connais une ville ayant\nbesoin d'[UNI00e9]glise, je suis le pr[UNI00ea]tre\nqu'il te faut ! Fais-moi signe."
			)
		end
		if arg1 == 19 then
			event.MesMake_2(
				arg0,
				"Je n'ai pas beaucoup pens[UNI00e9] [UNI00e0] la\nlune derni[UNI00e8]rement. [UNI00c7]a doit [UNI00ea]tre [UNI00e0]\ncause de tous mes nouveaux amis."
			)
		end
		if arg1 == 20 then
			event.MesMake_2(
				arg0,
				"Autres lieux, autres poissons.\nIl faut savoir s'adapter en\nfonction de l'environnement."
			)
		end
		if arg1 == 21 then
			event.MesMake_2(arg0, "Une eau parfaite pour les poissons.")
		end
		if arg1 == 22 then
			event.MesMake_2(
				arg0,
				"Parn a commenc[UNI00e9] un nouveau portrait\nde femme. Elle sera soi-disant\nencore plus jolie que moi."
			)
		end
		if arg1 == 23 then
			event.MesMake_2(arg0, "Je me demande pourquoi les\ninsectes sont si r[UNI00e9]pugnants...")
		end
		if arg1 == 24 then
			event.MesMake_2(arg0, "Tu pourrais embellir ma maison ?\nUne maison n'est jamais trop\nbelle, tu sais !")
		end
		if arg1 == 25 then
			event.MesMake_2(
				arg0,
				"Je n'aurais jamais imagin[UNI00e9]\nd[UNI00e9]m[UNI00e9]nager [UNI00e0] mon [UNI00e2]ge."
			)
		end
	else
		helper_40864615(arg0, arg1)
	end
end

--- Helper function.
local function helper_22004()
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
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	helper_208a8(0, var2)
	helper_907fd9a8(var1, -1, 0, 0)
	event.SetAi(1, var1)
end

--- Helper function.
local function helper_225c0()
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
		helper_208a8(3, var2)
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
			event.MesMake_2(
				3,
				"[(!)]Tu ne peux pas faire [UNI00e7]a maintenant. Tu\ndois d'abord emmener Lin au phare !"
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
						event.MesMake_2(3, "Tr[UNI00e8]s bien, on a termin[UNI00e9]\nles r[UNI00e9]parations !")
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
						if helper_ff1e56f8(3) ~= 0 then
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
						helper_f3578ab6()
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
	helper_22004()
	helper_225c0()
end

return script
