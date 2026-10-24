--!strict
-- map/i/i02/h01/i02h01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0f514d67 = require("@lib/event/helper_0f514d67")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_48172752 = require("@lib/event/helper_48172752")
local helper_4919d694 = require("@lib/event/helper_4919d694")
local helper_826a3ea7 = require("@lib/event/helper_826a3ea7")
local helper_83f038b5 = require("@lib/event/helper_83f038b5")
local helper_852874a9 = require("@lib/event/helper_852874a9")
local helper_874b82cd = require("@lib/event/helper_874b82cd")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_a4226c93 = require("@lib/event/helper_a4226c93")
local helper_b1f88208 = require("@lib/event/helper_b1f88208")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e6450f0b = require("@lib/event/helper_e6450f0b")
local helper_ee1c51d0 = require("@lib/event/helper_ee1c51d0")
local helper_ef5629cb = require("@lib/event/helper_ef5629cb")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fbd9683d = require("@lib/event/helper_fbd9683d")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")

--- Helper function.
local function helper_1f628()
	local var0: any = 0
	local at: number = 0
	return vm.guard(function()
		event.SetMotion(0, "立ち")
		event.Initialize()
		helper_125385ee(0, 4)
		event.MesMake_2(0, "Entrer\nPartir")
		at = 1
		var0 = helper_b1f88208(0, -1, 5, 256, 208, 2, 0)
		if var0 == -1 then
			helper_125385ee(0, 1)
			return 0
		end
		if var0 == 1 then
			event.SetFadeOut(15)
			at = 2
			helper_25abe6d2(15)
			event.GotoMenu(19, 0)
			at = 3
			vm.wait(3)
			event.SetFadeIn(15)
			at = 4
			helper_25abe6d2(15)
			return 0
		end
		return 1
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			helper_fbd9683d(0, 1)
			return 0
		end
		if at <= 4 then
			if at <= 3 then
				helper_d3f20302(15)
			end
			return 0
		end
		return nil
	end)
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
		helper_852874a9()
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "H[UNI00e9] ! Il est interdit d'avancer\nau-del[UNI00e0] de la limite.")
		helper_907fd9a8(var1, -1, 0, 0)
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
					"Regarde-moi [UNI00e7]a. Difficile de croire\nqu'autrefois cet engin avan[UNI00e7]ait [UNI00e0]\ntoute vitesse, hein ?<page>Ah mais si, si... Il y a longtemps.<page>Je r[UNI00ea]ve de faire un autre\nvoyage dans ce truc. C'est pour\n[UNI00e7]a que je le bichonne. Comme [UNI00e7]a,<page>si un jour on me "
				)
			else
				event.MesMake_2(
					0,
					"Il faut faire de l'exercice souvent\npour [UNI00e9]viter les courbatures. Pour\nles machines c'est pareil..."
				)
			end
			helper_907fd9a8(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"H[UNI00e9], salut Max !\nIl y a une [UNI00e9]ternit[UNI00e9] que la\nvoie ferr[UNI00e9]e ne fonctionne plus.<page>Mais je continue [UNI00e0] surveiller\nla gare jour apr[UNI00e8]s jour."
				)
			else
				event.MesMake_2(
					0,
					"Le Maire s'est enfin boug[UNI00e9] un peu\net les trains ont repris du service\nmais pas encore pour le public.<page>Ah [UNI00e7]a, je meurs d'envie d'y faire\nmonter les gens de la ville..."
				)
			end
			helper_907fd9a8(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Salut, Max. Tu savais que mon p[UNI00e8]re\nest le chef de gare ? On surveille\nla gare tous les deux.<page>Jusqu'au jour o[UNI00f9] les trains\nseront remis en service..."
				)
			else
				event.MesMake_2(
					0,
					"Le train marche ! Mais il va\nfalloir un moment avant que la\ngare ne fonctionne [UNI00e0] nouveau normalement..."
				)
			end
			helper_907fd9a8(var1, -1, 0, 0)
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
					"J'admire secr[UNI00e8]tement Monica depuis\ntoujours, mais je ne l'ai pas vue\ndans le coin derni[UNI00e8]rement.<page>C'est pour [UNI00e7]a que je n'arrive pas\n[UNI00e0] me concentrer sur mon travail."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(
						0,
						"H[UNI00e9], Max !\nMonica est de retour, on dirait.\nTout le monde va [UNI00ea]tre enchant[UNI00e9] !"
					)
				else
					event.MesMake_2(0, "Monica ! Comment [UNI00e7]a va ?\nTu m'as vraiment manqu[UNI00e9].")
				end
			end
			helper_907fd9a8(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"Je commen[UNI00e7]ais tout juste [UNI00e0] pouvoir\ndiscuter normalement avec\nMonica quand elle a disparu.<page>Allez Max,\ndis-moi o[UNI00f9] elle est, s'te pla[UNI00ee]t ?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica est revenue.\nComment elle a fait ?")
				else
					event.MesMake_2(0, "Monica, tu es revenue !\nComment t'as fait ?")
				end
			end
			helper_907fd9a8(var1, -1, 0, 0)
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_907fd9a8(var1, -1, 0, 0)
	event.SetAi(1, var1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_4919d694

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	event.Initialize()
	helper_4919d694()
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
						helper_48172752()
					else
						helper_0f514d67()
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_0f514d67

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_ef5629cb

--- Event 160, which map data, a script or the engine runs by number.
function script.event_160()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		at = 1
		vm.wait(1)
		event.EohSyncObj_2(0, "p01_train01")
		event.EohSetRot(0, 0.0, 0.0, 0.0)
		do
			local out1, out2, out3 = event.EohGetPos(0)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		print("pos[0]=", pos_x, "-----------\n")
		print("pos[1]=", pos_y, "-----------\n")
		print("pos[2]=", pos_z, "-----------\n")
		event.EohSetPos(0, pos_x, pos_y, 0.0)
		event.CharaActive(0, 122)
		event.CharaActive(0, 123)
		event.CharaActive(0, 0)
		event.SetCameraPos(-345.21, 89.08, 234.02)
		event.SetCameraRef(-238.57, 83.73, 148.63)
		at = 2
		vm.wait(2)
		at = 3
		helper_c956b4a2(64)
		event.CharaActive(1, 122)
		event.CharaActive(1, 123)
		event.CharaActive(1, 0)
		event.EohSetPos(0, pos_x, pos_y, -1800.0)
		event.EohSetRot(0, 0.0, 3.1415927, 0.0)
		event.ResetCamera(0)
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				print("pos[0]=", pos_x, "-----------\n")
				print("pos[1]=", pos_y, "-----------\n")
				print("pos[2]=", pos_z, "-----------\n")
			end
			if at <= 2 then
				helper_874b82cd(64)
			end
			return 0
		end
		return nil
	end)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	vm.wait(1)
	event.MapJump_2(-1, "m02")
	vm.wait(2)
	event.Ext(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.Ext(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		flag = event.GetFlag(202) or flag
		if flag == 0 then
			at = 1
			helper_a4226c93(0, vm.f32(1.57))
			helper_125385ee(0, 1)
			event.MesMake_2(
				0,
				"C[UNI00e9]dric a appel[UNI00e9] cet engin un train,\nnon ?...<page>Maintenant, [UNI00c9]rik et Born[UNI00e9]o s'en\nservent comme logement.<page>C[UNI00e9]dric a dit qu'autrefois, bien\navant ma naissance, il roulait.<page>C'est vrai ?"
			)
			at = 2
			helper_9e7d1511(0, -1, 5, 256, 208)
			event.MesMake_2(0, "Un truc aussi grand peut bouger ?<page>Si c'est vrai,\nj'adorerais voir [UNI00e7]a !")
			at = 3
			helper_9e7d1511(0, -1, 5, 256, 208)
			return
		end
		at = 4
		var1 = helper_1f628()
		if var1 ~= 1 then
			return
		end
		event.SetCnt(1, 1)
		var2 = event.GetChapter() or var2
		var3 = event.GetEventData_2(3) or var3
		if var3 <= 1 then
			if var2 ~= 6 and var2 ~= 7 then
				at = 5
				helper_f4ec8310()
				event.StopBgm(0)
				at = 6
				vm.wait(6)
				event.MapJump_2(-1, "s08")
			else
				at = 7
				helper_f4ec8310()
				event.StopBgm(0)
				at = 8
				vm.wait(8)
				event.MapJump_2(-1, "s37")
			end
			at = 9
			vm.wait(9)
		elseif var2 ~= 6 and var2 ~= 7 then
			at = 10
			helper_826a3ea7(0)
			event.StopBgm(0)
			event.MapJump_2(100, "s07")
		else
			at = 11
			helper_fdad3d3b()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_fbd9683d(0, 1)
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_ee1c51d0(0, -1, 5, 256, 208)
			end
			return 0
		end
		if at <= 4 then
			if at == 4 then
				var1 = received[1] :: number
			end
			return 0
		end
		if at <= 11 then
			if at == 11 then
			end
			if at <= 6 then
				helper_83f038b5()
			end
			if at <= 9 then
				helper_e6450f0b(0)
			end
			if at <= 10 then
				helper_c99744f1()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local var0: s32 = 0
	var0 = event.SearchCharaNo(2) or var0
	event.CharaActive(0, var0)
	event.SetAi(0, var0)
	helper_ef5629cb()
	event.GotoDng(0, -1, 1000)
end

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_229d4

return script
