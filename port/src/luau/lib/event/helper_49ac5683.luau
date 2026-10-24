--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_92866686 = require("@lib/event/helper_92866686")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_dcc4fb72 = require("@lib/event/helper_dcc4fb72")
local helper_f30d69fc = require("@lib/event/helper_f30d69fc")

--- Helper function.
local function helper_49ac5683()
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
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_92866686(player_chara_2, var16)
		end
		if at <= 3 then
			helper_b8950300(0, -1, var1, player_chara_2, 0)
		end
		if at <= 4 then
			helper_f30d69fc(5)
		end
		if at <= 5 then
			helper_f30d69fc(27)
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
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
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
						"Per il piatto miracoloso mi serve\nun Fiore Biancovento. Ma non ne ho\npi[UNI00f9]. Ops... non posso aiutarvi!"
					)
				else
					event.MesMake_2(
						0,
						"Avete gi[UNI00e0] provato gli Gnocchi\nmiracolosi? Se si freddano perdono\nd'efficacia: vanno mangiati subito!"
					)
				end
			else
				event.MesMake_2(
					0,
					"Gli Gnocchi miracolosi sono stati\nutili, eh? Mi fa piacere. Ehi,\nMangiate qualcosa prima di andare?"
				)
			end
		else
			event.MesMake_2(0, "Oh cielo, [UNI00e8] quasi ora, eh?\nVediamo che succede.")
		end
	end
	if var2 == 201 then
		event.MesMake_2(
			0,
			"I vari oggetti hanno effetti\ndiversi. Alcuni sono utili. Altri\npermettono di creare delle armi...<page>Sperimentando, sarai in grado di\nsconfiggere anche il peggiore\ndei nemici. Prova di tutto!"
		)
	end
	if var2 == 202 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Non posso credere che questo\ntempio sia stato distrutto\ndal diabolico Imperatore Grifone.<page>Se solo il Grande Saggio Crest\nfosse qui..."
			)
		else
			event.MesMake_2(
				0,
				"Con il Grande Crest di nuovo tra\nnoi, non avremo niente da temere.\nOra andate ad affrontare Grifone."
			)
		end
	end
	if var2 == 203 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Questo tempio [UNI00e8] immerso in una\nnotte perpetua: il Cristallunare\n[UNI00e8] pi[UNI00f9] potente di notte.<page>Sfrutta la forza del tempio\nper creare un'area di oscurit[UNI00e0]."
			)
		else
			event.MesMake_2(
				0,
				"Che Crest il Grande possa usare il\npotere del Cristallunare per\nvedere ogni cosa a questo mondo!<page>Nulla sfugge alla vista\nonnipotente di Crest!"
			)
		end
	end
	if var2 == 204 then
		event.MesMake_2(
			0,
			"Salve! Abbiamo un vasto\nassortimento. Le nostre armi sono\nnote per essere forti e resistenti."
		)
	end
	if var2 == 205 then
		if flag_5 == 0 then
			if flag_4 == 0 then
				event.MesMake_2(
					0,
					"Ehi! Basta perder tempo! [UNI00c8] ora di\nmostrare a quel Grifone chi [UNI00e8] il\npi[UNI00f9] forte! Presto!"
				)
			else
				event.MesMake_2(
					0,
					"Bene, questo [UNI00e8] tutto per quanto mi\nriguarda. Il resto dipende da voi.\nSu, andate ad occuparvi di Grifone!<page>Mi avete salvato la vita:\nso che potete farcela, ragazzi!"
				)
			end
		else
			event.MesMake_2(
				0,
				"Pare che il vostro viaggio sia\nquasi terminato. Battete Grifone,\nper il Maestro e per tutti noi.<page>Dovete assolutamente sconfiggerlo.\nSolo allora, io e Crest\ndiventeremo davvero Grandi Saggi!"
			)
		end
	end
	if var2 == 206 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Anche se tornasse come'era prima,\nil Tempio stellare, senza Crest,\n[UNI00e8] inservibile.<page>Solo Crest detiene l'immenso\npotere astrologico di esaminare\nil mondo intero."
			)
		else
			event.MesMake_2(
				0,
				"Persino il Grande Crest, un tempo,\nera l'apprendista di un saggio.\nChiss[UNI00e0] che grande maestro era!"
			)
		end
	end
	if var2 == 207 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Il cibo qui [UNI00e8] di prima qualit[UNI00e0].\nMi viene l'acquolina in bocca\nsolo a pensarci..."
			)
		else
			event.MesMake_2(0, "Ha preparato il piatto miracoloso!\nLao Chao [UNI00e8] proprio un grande chef!")
		end
	end
	if var2 == 208 then
		if flag == 0 then
			event.MesMake_2(
				0,
				"Una volta mangiato qui,\nniente sar[UNI00e0] pi[UNI00f9] cos[UNI00ec]\ngustoso. [UNI00c8] talmente buono!"
			)
		else
			event.MesMake_2(0, "Wow! Certo che piacerebbe\nanche a me assaggiare un\npo' di Gnocchi miracolosi!")
		end
	end
	if var2 == 209 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Pensi che la Clessidra stellare\nsia bizzarra?<page>A chi lo dici! Ne ho una anch'io,\nma non mi sembra un granch[UNI00e9]...\nNon riporta indietro il tempo."
			)
		else
			event.MesMake_2(
				0,
				"[UNI00c8] stupendo che voi ragazzi siate\namici del Grande Saggio Crest.<page>Ma non immaginavo\nfoste cos[UNI00ec] intimi..."
			)
		end
	end
	if var2 == 210 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Il Grande Saggio Crest non [UNI00e8] qui.\nMi chiedo dove sia andato...<page>Ci sentiamo a disagio\nquando non c'[UNI00e8]."
			)
		else
			event.MesMake_2(
				0,
				"Il Grande Crest mi disse che in\npassato un certo Gaspard volle\ndistruggere il Cristallunare.<page>E fu il maestro del Sommo Crest a\nrischiare la vita per difenderlo..."
			)
		end
	end
	if var2 == 211 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Il Grande Crest [UNI00e8] scomparso\ncon il Cristallunare,\nper proteggerlo...?<page>Non capisco..."
			)
		else
			event.MesMake_2(
				0,
				"Avete visto l'incredibile potere\ndel Cristallunare, giusto? Ma\n solo LUI [UNI00e8] in grado di usarlo...<page>il Grande Saggio Crest...<page>Noi comuni mortali non\npotremmo mai riuscirci."
			)
		end
	end
	if var2 == 212 then
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Che siate voi...? Il Grande Crest\nmi disse che un giorno un ragazzo\ne una ragazza sarebbero venuti...<page>Sapevo che questa profezia\nsi sarebbe avverata!<page>Sfortunatamente anche il Grande\nSaggio [UNI00e8] scomparso."
			)
		else
			event.MesMake_2(
				0,
				"10.000 anni fa?<page>Volete dire che il Lab-Lunatica\npu[UNI00f2] portare a termine un'impresa\nimpossibile anche al Grande Crest?"
			)
		end
	end
	if var2 == 213 then
		event.MesMake_2(
			0,
			"La luna detiene uno strano potere,\nche influisce su ogni\nspecie di essere vivente.<page>E il Cristallunare\nincarna questo potere."
		)
	end
	if var2 == 214 then
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Se cerchi il cibo pi[UNI00f9] buono\ndel mondo, dovresti andare\nal Bistrot di Lao Chao!<page>Ne hai gi[UNI00e0] sentito parlare, vero?"
			)
		else
			event.MesMake_2(
				0,
				"Cos[UNI00ec] sareste voi. Il Grande Crest\nmi ha parlato di voi e di come\nle salvaste la vita.<page>Ma non avrei mai immaginato\nche foste solo dei ragazzi..."
			)
		end
	end
	if var3 == 0 then
		helper_dcc4fb72(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var3 == 1 then
		helper_b8950300(0, -1, var1, player_chara, 0)
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
		helper_92866686(player_chara_2, var16)
		if vm.skipping() then
			return skip(3)
		end
		event.SetCharaRot(player_chara_2, 0.0, var16, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b8950300(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 201 then
		helper_f30d69fc(5)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var2 == 204 then
		helper_f30d69fc(27)
		if vm.skipping() then
			return skip(6)
		end
	end
end

return helper_49ac5683
