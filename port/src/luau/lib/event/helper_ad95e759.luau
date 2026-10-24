--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c94e0e8 = require("@lib/event/helper_1c94e0e8")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_ad95e759()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
				var5 = 2
				var5 = 1
				helper_1c94e0e8()
			end
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
	end
	if vm.skipping() then
		return skip(1)
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_1c94e0e8()
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
		helper_30c30f62(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Dai un'occhiata qui! Difficile\ncredere che un tempo filava\nche era una bellezza, vero?<page>Proprio cos[UNI00ec]... molto tempo fa.<page>Il mio sogno [UNI00e8] di rifarci un bel\nviaggetto! Ecco perch[UNI00e9] cerco\ndi tenerlo in perfetta forma.<page>Cos[UNI00ec], appena possibile,\n"
				)
			else
				event.MesMake_2(
					0,
					"Sai che devi fare esercizio tutti\ni giorni per restare in forma, no?\nLo stesso vale con le macchine."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Ehi salve, Max!\nLa ferrovia non funziona\nda parecchio tempo.<page>Ma io continuo a vigilare\nsulla stazione, tutti i giorni."
				)
			else
				event.MesMake_2(
					0,
					"Il Sindaco si [UNI00e8] finalmente mosso:\nha fatto ripartire i treni.\nMa non sono aperti al pubblico!<page>Cavoli, non vedo l'ora di farci\nsalire gli abitanti della citt[UNI00e0]..."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Ciao, Max. Sapevi che il\ncapostazione [UNI00e8] il mio pap[UNI00e0]?\nSorvegliamo la stazione insieme.<page>Aspettiamo che questa ferrovia\nriprenda a funzionare..."
				)
			else
				event.MesMake_2(
					0,
					"Il treno funziona!\nMa ci vorr[UNI00e0] del tempo prima\nche la stazione torni com'era..."
				)
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Sono un ammiratore segreto\ndi Monica da tempo, ma\nnon la vedo da un po'.<page>Per questo non riesco a\nconcentrarmi sul lavoro!"
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "Ehi, Max!\nSembra che Monica sia tornata.\nNe saranno tutti felici!")
				else
					event.MesMake_2(0, "Monica! Dove sei stata?\nMi sei mancata tanto!")
				end
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Avevo appena trovato il coraggio\ndi parlare a Monica normalmente,\nquando [UNI00e8] scomparsa.<page>Dai, Max...\ndimmi dov'[UNI00e8]... ti prego!"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica [UNI00e8] tornata.\nCom'[UNI00e8] possibile?!?")
				else
					event.MesMake_2(0, "Monica, sei tornata!\nCom'[UNI00e8] possibile?!?")
				end
			end
			helper_30c30f62(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(8)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_30c30f62(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(9)
	end
	event.SetAi(1, var1)
end

return helper_ad95e759
