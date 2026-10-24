--!strict
-- map/i/i02/h01/i02h01_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1565f910 = require("@lib/event/helper_1565f910")
local helper_15d7e8e6 = require("@lib/event/helper_15d7e8e6")
local helper_36526538 = require("@lib/event/helper_36526538")
local helper_4adb8cbe = require("@lib/event/helper_4adb8cbe")
local helper_4b68ef15 = require("@lib/event/helper_4b68ef15")
local helper_6432ba85 = require("@lib/event/helper_6432ba85")
local helper_89004d78 = require("@lib/event/helper_89004d78")
local helper_8f562e83 = require("@lib/event/helper_8f562e83")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_98430d9a = require("@lib/event/helper_98430d9a")
local helper_9d3aacf6 = require("@lib/event/helper_9d3aacf6")
local helper_9f53b697 = require("@lib/event/helper_9f53b697")
local helper_9fa62045 = require("@lib/event/helper_9fa62045")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b436078b = require("@lib/event/helper_b436078b")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")
local helper_ed7a22dd = require("@lib/event/helper_ed7a22dd")

--- Helper function.
local function helper_1f628()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(0, 1)
			return 0
		end
		if at <= 3 then
			helper_aafd6a80(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_c9057fa5(0, 4)
	event.MesMake_2(0, "Entra\nParti")
	var0 = helper_9d3aacf6(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_c9057fa5(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_21acc()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9fa62045(15)
		end
		if at <= 2 then
			helper_9fa62045(1)
		end
		if at <= 3 then
			helper_9fa62045(6)
		end
		if at <= 4 then
			helper_9fa62045(0)
		end
		if at <= 5 then
			helper_9fa62045(4)
		end
		if at <= 6 then
			helper_9fa62045(31)
		end
		if at <= 7 then
			helper_9fa62045(35)
		end
		if at <= 8 then
			helper_9fa62045(36)
		end
		if at <= 9 then
			helper_9fa62045(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Benvenuti.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Si lavora sodo, vedo!\nTi serve qualcosa?<page>Per[UNI00f2], niente omaggi.\nNeanche per te, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"Vi servono altri elementi\nDiorama?<page>Se non avete tempo di cercarli\nda soli, i soldi potrebbero\nrisolvere i vostri problemi."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Salve. Sono apprendista fornaia.\nSostituisco Polly al forno\nquando non c'[UNI00e8].<page>Sono un po' nervosa, ma fa parte\nanche questo dell'apprendistato.\nFar[UNI00f2] del mio meglio!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"Forse non ci somigliamo molto...\nMa sono la sorellina di Milane.<page>Mi ha lasciata qui a badare al\nnegozio, ma non mi intendo d'armi!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Sorpreso, vero? Immagino chiunque\nrimarrebbe meravigliato nel vedere\nqualcuno vestito cos[UNI00ec].<page>Sostituisco il mio amico Don Bruno\nche [UNI00e8] in viaggio. Allora, posso\nesserti d'aiuto in qualche modo?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Vorresti usufruire del potere\ndegli d[UNI00e8]i? Allora, ti prego di\nfare una donazione alla chiesa."
			)
		end
	end
	if var1 ~= -1 then
		helper_ed7a22dd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_9fa62045(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_9fa62045(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_9fa62045(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_9fa62045(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_9fa62045(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_9fa62045(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_9fa62045(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_9fa62045(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_9fa62045(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_228f4()
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
		if at <= 1 then
			return
		end
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
		helper_21acc()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Ehi! Non [UNI00e8] permesso\noltrepassare questo punto.")
		helper_ed7a22dd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
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
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(3)
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
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
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
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
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
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
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
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Salve.\nTempo stupendo, vero?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_ed7a22dd(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_6432ba85

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4adb8cbe()
		end
	end
	event.Initialize()
	helper_6432ba85()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -240.0, 35.8, 140.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 10 or old_map_no == 22 or old_map_no == 121 then
				event.SetCharaPos(0, 0.0, 198.8, 1450.0)
				event.SetCharaRot(0, 0.0, 3.14, 0.0)
				event.ResetCamera(1, 3.14)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 1 then
					helper_946c0402()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var4 = event.GetChapter() or var4
					if var4 ~= 6 and var4 ~= 7 then
						helper_b436078b()
						if vm.skipping() then
							return skip(1)
						end
					else
						helper_4adb8cbe()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4adb8cbe()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15d7e8e6()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("pos[0]=", string.format("%f", pos_x), "-----------\n")
			print("pos[1]=", string.format("%f", pos_y), "-----------\n")
			print("pos[2]=", string.format("%f", pos_z), "-----------\n")
		end
		if at <= 2 then
			helper_4b68ef15(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01")
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	print("pos[0]=", string.format("%f", pos_x), "-----------\n")
	print("pos[1]=", string.format("%f", pos_y), "-----------\n")
	print("pos[2]=", string.format("%f", pos_z), "-----------\n")
	event.EohSetPos(0, pos_x, pos_y, 0.0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.CharaActive(0, 0)
	event.SetCameraPos(-345.21, 89.08, 234.02)
	event.SetCameraRef(-238.57, 83.73, 148.63)
	if vm.wait() then
		return skip(2)
	end
	helper_4b68ef15(64)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 122)
	event.CharaActive(1, 123)
	event.CharaActive(1, 0)
	event.EohSetPos(0, pos_x, pos_y, -1800.0)
	event.EohSetRot(0, 0.0, 3.1415927, 0.0)
	event.ResetCamera(0)
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.MapJump(-1, "m02")
	if vm.wait() then
		return skip(2)
	end
	event.Ext(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.Ext(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Program 250.
script[250] = function()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_c9057fa5(0, 1)
				helper_36526538(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_36526538(0, -1, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 6 then
			helper_8f562e83()
		end
		if at <= 9 then
			helper_98430d9a(0)
		end
		if at <= 10 then
			helper_89004d78()
		end
	end
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		helper_9f53b697(0, vm.f32(1.57))
		if vm.skipping() then
			return skip(1)
		end
		helper_c9057fa5(0, 1)
		event.MesMake_2(
			0,
			"Cedric chiama questo\nmarchingegno 'treno'...<page>Erik e Borneo lo usano\ncome casa.<page>Cedric dice che prima, molto prima\nche io nascessi, si muoveva.<page>[UNI00c8] vero?"
		)
		helper_36526538(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Cos[UNI00ec] grande e pu[UNI00f2] muoversi?<page>Se si muovesse,\nmi piacerebbe proprio vederlo!"
		)
		helper_36526538(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var1 = helper_1f628()
	if vm.skipping() then
		return skip(4)
	end
	if var1 ~= 1 then
		return
	end
	event.SetCnt(1, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(3) or var3
	if var3 <= 1 then
		if var2 ~= 6 and var2 ~= 7 then
			helper_8f562e83()
			if vm.skipping() then
				return skip(5)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(6)
			end
			event.MapJump(-1, "s08")
		else
			helper_8f562e83()
			if vm.skipping() then
				return skip(7)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(8)
			end
			event.MapJump(-1, "s37")
		end
		if vm.wait() then
			return skip(9)
		end
	elseif var2 ~= 6 and var2 ~= 7 then
		helper_98430d9a(0)
		if vm.skipping() then
			return skip(10)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_89004d78()
		if vm.skipping() then
			return skip(11)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1565f910()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.SearchCharaNo(2) or var0
	event.CharaActive(0, var0)
	event.SetAi(0, var0)
	helper_15d7e8e6()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_228f4()
	if vm.skipping() then
		return skip(1)
	end
end

return script
