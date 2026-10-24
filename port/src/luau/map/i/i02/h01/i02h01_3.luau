--!strict
-- map/i/i02/h01/i02h01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

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
	event.MesMake_2(0, "Hineingehen\nVerlassen")
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
local function helper_229d4()
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
		event.MesMake_2(0, "Hey! Ab hier\nist abgesperrt.")
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
					"Sieh dir das an. Kaum zu\nglauben, dass das Ding\nfr[UNI00fc]her richtig gerast ist, was?<page>Ist es aber ... vor langer Zeit.<page>Ich tr[UNI00e4]ume davon, mit dem\nDing noch mal loszufahren. Darum\nhalte ich es auch in Schuss.<page>Wenn es je dazu kommt, kann\nich ihn sofort wieder\nauf die Gleise bringen."
				)
			else
				event.MesMake_2(
					0,
					"Du wei[UNI00df]t doch, dass man immer ver-\nsteift, wenn man zu selten trainiert.\nDas gilt f[UNI00fc]r Maschinen auch."
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
					"Hallo Max!\nDie Bahn f[UNI00e4]hrt schon seit\neiner Ewigkeit nicht mehr.<page>Aber ich k[UNI00fc]mmere mich\ntrotzdem immer um den Bahnhof."
				)
			else
				event.MesMake_2(
					0,
					"Der B[UNI00fc]rgermeister l[UNI00e4]sst die Bahn\nendlich wieder fahren. Aber\nnicht f[UNI00fc]r alle.<page>Oh Mann, ich w[UNI00fc]rde die\nLeute so gern einsteigen lassen ..."
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
					"Hi, Max. Wusstest du, dass der\nBahnhofsvorsteher mein Vater ist?\nWir k[UNI00fc]mmern uns um den Bahnhof.<page>Bis die Bahn eines Tages\nwieder fahren darf ..."
				)
			else
				event.MesMake_2(
					0,
					"Die Bahn f[UNI00e4]hrt!\nAber es wird etwas dauern, bis\nder Bahnhof wieder normal ist ..."
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
					"Ich verehre Monica seit langem\nheimlich, aber in letzter\nZeit war sie nicht hier.<page>Darum kann ich mich so schlecht\nauf die Arbeit konzentrieren."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "He, Max!\nMonica ist zur[UNI00fc]ck, ja?\nDa werden sich alle freuen!")
				else
					event.MesMake_2(0, "Monica! Wie geht's dir?\nIch hab dich echt vermisst.")
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
					"Ich konnte gerade normal mit\nMonica reden, da ist sie\nverschwunden.<page>Komm schon,  Max,\nsag mir doch, wo sie ist!"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica ist zur[UNI00fc]ck.\nWie kann das sein?")
				else
					event.MesMake_2(0, "Monica, du bist zur[UNI00fc]ck!\nWie kann das sein?")
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
	event.MesMake_2(0, "Tagchen.\nSch[UNI00f6]nes Wetter, nicht wahr?")
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
			"Cedric nannte dieses Ding einen\nZug, nicht wahr ...?<page>Jetzt benutzen Borneo und Erik\nes als Wohnung.<page>Cedric sagt, es ist fr[UNI00fc]her\ngefahren - lang bevor ich\nauf die Welt kam.<page>Ist das wahr?"
		)
		helper_36526538(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(
			0,
			"Kann etwas so Gro[UNI00df]es\nwirklich fahren?<page>Wenn es sich bewegt,\nw[UNI00fc]rde ich das echt gerne sehen!"
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
	helper_229d4()
	if vm.skipping() then
		return skip(1)
	end
end

return script
