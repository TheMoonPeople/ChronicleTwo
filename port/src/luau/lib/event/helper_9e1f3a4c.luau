--!strict
-- Shared event helper used by 9 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3a204093 = require("@lib/event/helper_3a204093")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_9e1f3a4c()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("IN go_shop_up()\n")
			print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
			helper_47171f2d(var1, -1, 0, 0)
		end
		if at <= 2 then
			helper_3a204093(15)
		end
		if at <= 3 then
			helper_3a204093(1)
		end
		if at <= 4 then
			helper_3a204093(6)
		end
		if at <= 5 then
			helper_3a204093(0)
		end
		if at <= 6 then
			helper_3a204093(4)
		end
		if at <= 7 then
			helper_3a204093(31)
		end
		if at <= 8 then
			helper_3a204093(35)
		end
		if at <= 9 then
			helper_3a204093(36)
		end
		if at <= 10 then
			helper_3a204093(37)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Willkommen.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Schwer besch[UNI00e4]ftigt, was?\nBrauchst du was?<page>Aber gratis gibt's nichts.\nNicht mal f[UNI00fc]r dich, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Du brauchst noch mehr Georama-\nTeile?<page>Falls du keine Zeit hast, sie\nselbst zu sammeln, kannst du vielleicht\nmit etwas Geld nachhelfen."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hallo, ich bin B[UNI00e4]cker-Lehrling.\nIch k[UNI00fc]mmere mich um die B[UNI00e4]ckerei,\nsolange Polly fort ist.<page>Ich bin etwas nerv[UNI00f6]s, aber es\ngeh[UNI00f6]rt wohl auch zur Ausbildung.\nIch tue mein Bestes!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Wir sehen uns kaum [UNI00e4]hnlich ...\naber ich bin Milanes kleine\nSchwester.<page>Sie hat gesagt, ich soll auf den\nLaden aufpassen, w[UNI00e4]hrend sie\nweg ist.<page>Dabei hab ich gar\nkeine Ahnung von Waffen!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Hab ich dich [UNI00fc]berrascht, ja?\nEs ist ja auch [UNI00fc]berraschend, wenn hier\njemand in diesen Klamotten steht.<page>Ich bin mit Priester Bruno befreundet\nund vertrete ihn, solange er weg ist.\nKann ich dir denn helfen?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"M[UNI00f6]chtest du die Macht der\nG[UNI00f6]tter zeitweise verliehen bekommen?<page>Dann bitte ich um eine\nSpende f[UNI00fc]r die Kirche."
			)
		end
	end
	if var1 ~= -1 then
		helper_47171f2d(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 18 then
		helper_3a204093(15)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 12 then
		helper_3a204093(1)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 4 then
		helper_3a204093(6)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 15 then
		helper_3a204093(0)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 33 then
		helper_3a204093(4)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 34 then
		helper_3a204093(31)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1012 then
		helper_3a204093(35)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1015 then
		helper_3a204093(36)
		if vm.skipping() then
			return skip(10)
		end
	end
	if var0 == 1018 then
		helper_3a204093(37)
		if vm.skipping() then
			return skip(11)
		end
	end
end

return helper_9e1f3a4c
