--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b3fc698 = require("@lib/event/helper_2b3fc698")
local helper_92866686 = require("@lib/event/helper_92866686")
local helper_afa3edbd = require("@lib/event/helper_afa3edbd")
local helper_b8950300 = require("@lib/event/helper_b8950300")
local helper_f30d69fc = require("@lib/event/helper_f30d69fc")

--- Helper function.
local function helper_2ee44518()
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
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			var3 = 1
			helper_afa3edbd(var1, -1, 0, 0)
		end
		if at <= 3 then
			helper_b8950300(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_92866686(player_chara_2, var20)
		end
		if at <= 5 then
			helper_b8950300(0, -1, var1, player_chara_2, 0)
		end
		if at <= 6 then
			helper_f30d69fc(30)
		end
		if at <= 7 then
			helper_f30d69fc(28)
		end
		if at <= 8 then
			helper_f30d69fc(29)
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
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
							"Gaspard ist ein m[UNI00e4]chtiger Gegner.\nDu musst immer wachsam\nbleiben, jeden Moment.<page>Du kannst ihn besiegen.\nDer Atlamillia hat dich\nnicht ohne Grund erw[UNI00e4]hlt ..."
						)
					else
						event.MesMake_2(
							0,
							"Tja, Gaspard war auch unzufrieden.<page>Was will Griffon nur -\nda legt er sich mit Leuten\naus zwei Zeitaltern an ..."
						)
					end
				else
					event.MesMake_2(
						0,
						"Wenn jemand Griffon besiegen\nkann, dann seid ihr das.<page>Wir z[UNI00e4]hlen auf euch."
					)
				end
			else
				event.MesMake_2(
					0,
					"Die Chrono-Verbindung ...\nDie Welt wird also durch das\nWissen der Alten gerettet ..."
				)
			end
		else
			event.MesMake_2(
				0,
				"So - das ist es also. Das Blut\nvieler Freunde wurde im Kampf\ngegen Griffon vergossen ...<page>Ihr seid unsere letzte Hoffnung!\nIch z[UNI00e4]hle auf euch, Max und Monica.\nIhr m[UNI00fc]sst Griffon besiegen!"
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
								"Na gut. Zuerst m[UNI00fc]sst ihr die\nFeuer-B[UNI00f6]e vernichten.<page>Wenn wir nichts gegen diesen\nFeuerregen unternehmen, ist\nHeim Rada erledigt."
							)
						else
							event.MesMake_2(
								0,
								"Na gut, das ist also passiert.\nWir sollten wohl froh sein,\ndass die Feuer-B[UNI00f6]e weg ist."
							)
							helper_2b3fc698(player_chara, var1, 0)
							if vm.skipping() then
								return skip(1)
							end
							helper_b8950300(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(2)
							end
							var3 = 1
							event.MesMake_2(
								0,
								"Aber ich mache mir Sorgen um\ndeine Freundin, die in den Krater\ngefallen ist.<page>Aber das einzige, was wir tun\nk[UNI00f6]nnen, ist wohl Heim Rada wieder\naufzubauen und die<page>Werkstatt noch besser zu\nmachen als vorher."
							)
						end
					else
						event.MesMake_2(
							0,
							"Ihr habt Gaspard besiegt!\nIhr seid echt unglaublich!<page>Jetzt geht's um seinen Chef,\nKaiser Griffon. Erledigt die\nSache ein f[UNI00fc]r alle Mal!"
						)
					end
				else
					event.MesMake_2(
						0,
						"Ich war so froh, Paznos in\nAktion zu sehen, dass ich\nweinen musste.<page>All unsere Arbeit\nhat sich endlich bezahlt\ngemacht."
					)
				end
			else
				event.MesMake_2(0, "Edelstein? Tut mir Leid,\nvon solchem Zeug hab\nich gar keine Ahnung.")
			end
		else
			event.MesMake_2(0, "Endlich stellt ihr Griffon, ja?\nViel Gl[UNI00fc]ck. Erledigt ihn!")
		end
	end
	if var2 == 402 then
		event.MesMake_2(0, "Hallo! Wir haben lauter\ntolle Sachen hier! Was\ndarf's denn sein?")
	end
	if var2 == 403 then
		event.MesMake_2(0, "Was immer du brauchst, ich\nhab's da. Ich bin dein\nMann!")
	end
	if var2 == 404 then
		event.MesMake_2(
			0,
			"K[UNI00e4]mpfe k[UNI00f6]nnen sehr schwierig\nsein. Man kann nicht immer\neinfach drauflosst[UNI00fc]rmen.<page>Wer cool ist, benutzt auch\nGegenst[UNI00e4]nde. Finde den\nSchwachpunkt deines Gegners<page>und nutze ihn aus."
		)
	end
	if var2 == 405 then
		event.MesMake_2(
			0,
			"Es gibt nichts, was wir hier in\nder Gundorada-Werkstatt nicht\nbauen k[UNI00f6]nnten.<page>Ob gro[UNI00df], ob klein -\nwir bauen's dir."
		)
	end
	if var2 == 406 then
		event.MesMake_2(
			0,
			"He, wie seid ihr hier rein-\ngekommen? Passt lieber\nauf hier.<page>Es kann hier recht\ngef[UNI00e4]hrlich werden."
		)
	end
	if var2 == 407 then
		event.MesMake_2(0, "Was war denn die ganze Zeit\nlos? Ich kann mich einfach\nan nichts erinnern.")
	end
	if var2 == 408 then
		event.MesMake_2(
			0,
			"Wir wurden also alle von\nGriffon ausgel[UNI00f6]scht, ja? Er\nmuss ein schreckliches Monster sein."
		)
	end
	if var2 == 409 then
		event.MesMake_2(0, "Ich bin gerade sehr besch[UNI00e4]ftigt.\nBitte geh aus dem Weg.")
	end
	if var2 == 410 then
		event.MesMake_2(0, "Wir stehen alle hinter euch.\nUnd zwar zu 100 Prozent.")
	end
	if var2 == 411 then
		event.MesMake_2(
			0,
			"Die Waffen in dieser Kiste\nsind wohl nicht zu verkaufen.<page>Aber es gibt schon komische,\nsonderbare Waffen,\nnicht wahr ...?"
		)
	end
	if var2 == 412 then
		event.MesMake_2(
			0,
			"Dieser Gaspard kann also die\nFeuer-B[UNI00f6]e entfesseln?<page>Er ist nicht nur hinterlistig,\ner ist wahrhaft b[UNI00f6]se."
		)
	end
	if var2 == 413 then
		event.MesMake_2(
			0,
			"Was soll das Herz auf diesem\nSchild ...?<page>Das ist ziemlich widerlich,\nwenn du mich fragst ..."
		)
	end
	if var3 == 0 then
		helper_afa3edbd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var3 == 1 then
		helper_b8950300(0, -1, var1, player_chara, 0)
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
		helper_92866686(player_chara_2, var20)
		if vm.skipping() then
			return skip(5)
		end
		event.SetCharaRot(player_chara_2, 0.0, var20, 0.0)
		event.SetMotion(player_chara_2, "立ち")
		helper_b8950300(0, -1, var1, player_chara_2, 0)
		if vm.skipping() then
			return skip(6)
		end
		event.ResetCamera(1, 3.1415927)
	end
	event.SetAi(1, var1)
	if var2 == 402 then
		helper_f30d69fc(30)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var2 == 403 then
		helper_f30d69fc(28)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var2 == 404 then
		helper_f30d69fc(29)
		if vm.skipping() then
			return skip(9)
		end
	end
end

return helper_2ee44518
