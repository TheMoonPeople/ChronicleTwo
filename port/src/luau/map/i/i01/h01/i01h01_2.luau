--!strict
-- map/i/i01/h01/i01h01_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06423b6b = require("@lib/event/helper_06423b6b")
local helper_307bd8a4 = require("@lib/event/helper_307bd8a4")
local helper_70c0ef81 = require("@lib/event/helper_70c0ef81")
local helper_758669fc = require("@lib/event/helper_758669fc")
local helper_7cb4bf47 = require("@lib/event/helper_7cb4bf47")
local helper_9d160cf5 = require("@lib/event/helper_9d160cf5")
local helper_bc77b237 = require("@lib/event/helper_bc77b237")
local helper_e8e58678 = require("@lib/event/helper_e8e58678")

--- Helper function.
local function helper_10204()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.Initialize()
	argc = event.GetItemNum(386) or argc
	if 0 < argc then
		event.FuncPointShow("", "item2", 0)
		event.EohSyncObj(0, "memo")
		event.EohSetShow(0, 0)
	end
end

--- Helper function.
local function helper_107c8()
	local var0: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	event.Initialize()
	event.SetMesWindowMode(0, 1)
	helper_10204()
	event.CharaActive(1, 24)
	event.FuncPointShow("", "fc_event_e108c", 0)
	var0 = event.GetSavedataEtc(0) or var0
	flag = event.GetFlag(7) or flag
	if var0 == 3 and flag == 0 then
		print("LOAD_STEAVE------------------\n")
		event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.CharaActive(1, 25)
		event.LoadChara(4, "event/e100/e105/back01.gltf", "info", 26)
		event.CharaActive(0, 26)
		flag_2 = event.GetFlag(107) or flag_2
		if flag == 0 and flag_2 == 1 then
			print("e107 ikou--------------------\n")
			event.CharaActive(0, 24)
			event.CharaActive(1, 25)
			event.SetCharaPos(25, -116.62, -12.11, -221.76)
			event.SetCharaRot(25, 0.0, 0.16, 0.0)
			event.FuncPointShow("", "fc_event_e108c", 1)
		else
			event.SetCharaPos(25, 62.85, 11.43, -176.07)
			event.SetCharaRot(25, 0.0, -0.72, 0.0)
		end
		flag_3 = event.GetFlag(20) or flag_3
		if flag_3 ~= 0 then
			event.CharaActive(1, 26)
			event.SetReference(25, "back", 26)
		end
	end
end

--- Helper function.
local function helper_e930(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 8 then
			if at <= 1 then
				helper_bc77b237(9)
			end
			if at <= 2 then
				helper_06423b6b(0, 1)
				helper_e8e58678(arg0, 0, 0)
			end
			if at <= 3 then
				helper_9d160cf5(0, -1, arg0, player_chara, 0)
			end
			if at <= 4 then
				var5 = helper_758669fc(0, -1, 5, 256, 208, 2, 0)
			end
			if at <= 5 then
				helper_9d160cf5(0, -1, arg0, player_chara, 0)
			end
			if at <= 6 then
				helper_bc77b237(30)
			end
			return
		end
		if at <= 9 then
			return
		end
		if at <= 10 then
			return
		end
		if at <= 11 then
			return
		end
		if at <= 12 then
			return
		end
		if at <= 13 then
			return
		end
		if at <= 14 then
			return
		end
		if at <= 15 then
			return
		end
		if at <= 16 then
			return
		end
		if at <= 17 then
			return
		end
		if at <= 18 then
			helper_70c0ef81(arg0, -1, 0, 0)
		end
		if at <= 19 then
			helper_70c0ef81(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMotion(0, "立ち", 0)
	helper_bc77b237(9)
	if vm.skipping() then
		return skip(2)
	end
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_06423b6b(0, 1)
		helper_e8e58678(arg0, 0, 0)
		if vm.skipping() then
			return skip(3)
		end
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "Alors, comment va Steve ?")
		helper_9d160cf5(0, -1, arg0, player_chara, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Faire le plein.\nAm[UNI00e9]liorer le Noyau.")
		var5 = helper_758669fc(0, -1, 5, 256, 208, 2, 0)
		if vm.skipping() then
			return skip(5)
		end
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "[UNI00c7]a y est ! C'est fait !")
			helper_9d160cf5(0, -1, arg0, player_chara, 0)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_bc77b237(30)
			if vm.skipping() then
				return skip(7)
			end
			event.GotoMenu(6, 23)
			if vm.wait() then
				return skip(8)
			end
			event.SetFadeIn(25)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(107) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(0, "Tu abandonnes pour [UNI00e7]a ? Non, il\nne faut jamais baisser les bras !")
		helper_70c0ef81(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(9)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(20) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(10)
		end
		event.LoadScript("i01h01/i01h01c_1.stb", 500)
		return
	end
	var3 = event.GetItemNum(165) or var3
	if var3 > 0 then
		event.SetFlag(20, 1)
		if vm.wait() then
			return skip(11)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	argc = event.GetItemNum(224) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	var3 = event.GetInventionId(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		if vm.wait() then
			return skip(12)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(19) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"Le Magasin, c'est la boutique juste\nen face avec l'enseigne citrouille,\nquand tu sors d'ici.<page>Il te faut 20 morceaux de m[UNI00e9]tal,\n2 morceaux de cuivre et 1 cuir\n[UNI00e9]pais. Allez, va les acheter !"
		)
		helper_70c0ef81(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(13)
		end
		event.SetAi(1, 24)
		return
	end
	var3 = event.GetInventionId(165) or var3
	if var3 ~= -1 then
		if vm.wait() then
			return skip(14)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	var3 = event.CheckInventItem(165) or var3
	if var3 == 1 then
		if vm.wait() then
			return skip(15)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(17) or flag
	if flag == 1 then
		if vm.wait() then
			return skip(16)
		end
		event.LoadScript("i01h01/i01h01b_1.stb", 510)
		return
	end
	flag = event.GetFlag(105) or flag
	if flag == 0 then
		event.MesMake_2(0, "Max, tu dois travailler,\ntu m'entends ?")
		helper_70c0ef81(arg0, -1, 0, 0)
		if vm.skipping() then
			return skip(17)
		end
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "Tu dois d'abord essayer tout seul\nmon gar[UNI00e7]on.")
	helper_70c0ef81(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(18)
	end
	event.MesMake_2(0, "Je te donnerai un indice si tu n'y\narrives pas, d'accord ?")
	helper_70c0ef81(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(19)
	end
	event.MesMake_2(0, "Allez, d[UNI00e9]p[UNI00ea]che-toi !")
	helper_70c0ef81(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(20)
	end
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_feb0()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("[talk_chara]", var1, "\n")
			print("[talk_chara_id]", var1, "\n")
			helper_e930(var0, var1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesWindowMode(0, 1)
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetEventData_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_e930(var0, var1)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var1 == -1 then
		flag = event.GetFlag(6) or flag
		flag_2 = event.GetFlag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			if vm.wait() then
				return skip(3)
			end
			event.LoadScript("i01h01/i01h01c_1.stb", 520)
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	print("i01h01--------start event----------\n")
	helper_107c8()
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c_1.stb", 151)
end

--- Program 200.
script[200] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(18) or flag
	if flag == 1 then
		flag = event.GetFlag(17) or flag
		if flag == 0 then
			event.PlayBgm(0)
			event.SetFlag(17, 1)
		end
	end
	flag_2 = event.GetFlag(105) or flag_2
	flag_3 = event.GetFlag(109) or flag_3
	flag = event.GetFlag(56) or flag
	if flag_2 ~= 0 and flag_3 == 0 and flag == 0 then
		event.BgmLoadCancel()
	end
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeIn(30)
	if vm.wait() then
		return skip(2)
	end
	event.GotoOutside(-1, "m01")
	if vm.wait() then
		return skip(3)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10204()
	event.FuncPointShow("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.LoadScript("i01h01/i01h01b_1.stb", 500)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("スティーブ読み込んだ-------------\n")
			print("いべんとe108b--------------\n")
		end
	end
	helper_10204()
	event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
	event.CharaActive(1, 25)
	event.CharaActive(0, 24)
	event.SetCharaPos(25, -120.88, -13.05, -215.36)
	event.SetCharaRot(25, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	print("スティーブ読み込んだ-------------\n")
	event.LoadScript("i01h01/i01h01c_1.stb", 510)
	print("いべんとe108b--------------\n")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 520.
script[520] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_10204()
	event.LoadScript("i01h01/i01h01c_1.stb", 520)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 590.
script[590] = function()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_7cb4bf47(386, 1)
		end
		if at <= 2 then
			helper_307bd8a4(1)
		end
		helper_10204()
	end
	event.Initialize()
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var0 = out1 or var0
		var1 = out2 or var1
		var2 = out3 or var2
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var0, var1, var2, 10)
	helper_bc77b237(10)
	if vm.skipping() then
		return skip(1)
	end
	helper_7cb4bf47(386, 1)
	if vm.skipping() then
		return skip(2)
	end
	event.AddItem(386)
	helper_307bd8a4(1)
	if vm.skipping() then
		return skip(3)
	end
	helper_10204()
end

--- Program 610.
script[610] = function()
	print("event_610-------\n")
	helper_10204()
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_feb0()
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	helper_feb0()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 11051.
script[11051] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b_1.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11052.
script[11052] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_107c8()
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b_1.stb", 510)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11053.
script[11053] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_107c8()
	event.SetFlag(20, 0)
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01b_1.stb", 11053)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11060.
script[11060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_107c8()
	event.CharaActive(1, 25)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c_1.stb", 500)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 11083.
script[11083] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.ExtTyped(1078, "ii", 2, 1)
	event.SetFlag(25, 1)
	event.SetFlag(108, 0)
	event.SetFlag(103, 1)
	event.SetFlag(107, 1)
	event.SetFlag(7, 0)
	event.SetFlag(6, 1)
	if vm.wait() then
		return skip(1)
	end
	event.LoadScript("i01h01/i01h01c_1.stb", 520)
	if vm.wait() then
		return skip(2)
	end
end

return script
