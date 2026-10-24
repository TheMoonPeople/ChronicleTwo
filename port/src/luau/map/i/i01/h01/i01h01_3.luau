--!strict
-- map/i/i01/h01/i01h01_3.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_24bece14 = require("@lib/event/helper_24bece14")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_7428e09f = require("@lib/event/helper_7428e09f")
local helper_788a73ff = require("@lib/event/helper_788a73ff")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b5a98ffa = require("@lib/event/helper_b5a98ffa")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_d25c550f = require("@lib/event/helper_d25c550f")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

--- Helper function.
local function helper_e920(arg0: s32, arg1: any)
	local flag: s32 = 0
	local var3: s32 = 0
	local player_chara: s32 = 0
	local var5: any = 0
	local argc: s32 = 0
	local argc_2: s32 = 0
	local argc_3: s32 = 0
	event.SetMotion(0, "立ち", 0)
	helper_25abe6d2(9)
	flag = event.GetFlag(7) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		helper_125385ee(0, 1)
		helper_d25c550f(arg0, 0, 0)
		player_chara = event.GetControlChrid() or player_chara
		event.MesMake_2(0, "Und, wie geht's Steve?")
		helper_b5a98ffa(0, -1, arg0, player_chara, 0)
		event.SetMotion(arg0, "立ち")
		event.SetMesShippo(0, 0)
		event.SetMesQuestionGyou(0, 0)
		event.SetMesEtc(0, 0, 1)
		event.MesMake_2(0, "Aufladen\nKern verbessern")
		var5 = helper_c190f878(0, -1, 5, 256, 208, 2, 0)
		event.SetMesEtc(0, 0, 0)
		event.SetMesShippo(0, 1)
		if var5 == 0 then
			event.SetSavedataEtc(2)
			event.MesMake_2(0, "So! Alles fertig!")
			helper_b5a98ffa(0, -1, arg0, player_chara, 0)
		end
		if var5 == 1 then
			event.SetFadeOut(25)
			helper_25abe6d2(30)
			event.GotoMenu(6, 23)
			vm.wait(7)
			event.SetFadeIn(25)
		end
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(107) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(0, "Du gibst bei so etwas\nschon auf? Nie aufgeben, sag ich!")
		helper_907fd9a8(arg0, -1, 0, 0)
		event.SetAi(1, 24)
		return
	end
	flag = event.GetFlag(20) or flag
	if flag == 1 then
		vm.wait(9)
		event.LoadScript("i01h01/i01h01c_1.stb", 500)
		return
	end
	var3 = event.GetItemNum(165) or var3
	if var3 > 0 then
		event.SetFlag(20, 1)
		vm.wait(10)
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	argc = event.GetItemNum(224) or argc
	argc_2 = event.GetItemNum(245) or argc_2
	argc_3 = event.GetItemNum(227) or argc_3
	var3 = event.GetInventionId(165) or var3
	if argc >= 20 and argc_2 >= 1 and argc_3 >= 2 and var3 ~= -1 then
		vm.wait(11)
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(19) or flag
	if flag == 1 then
		event.SetAi(0, 24)
		event.MesMake_2(
			0,
			"Geh nach drau[UNI00df]en. Der Laden direkt\ngegen[UNI00fc]ber mit dem K[UNI00fc]rbis-Schild ist\nder Gegenst[UNI00e4]ndeladen.<page>Du brauchst 20 St[UNI00fc]ck Metall,\n2 Kupferklumpen und 1 Tierhaut.\nGeh r[UNI00fc]ber und kauf das!"
		)
		helper_907fd9a8(arg0, -1, 0, 0)
		event.SetAi(1, 24)
		return
	end
	var3 = event.GetInventionId(165) or var3
	if var3 ~= -1 then
		vm.wait(13)
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	var3 = event.CheckInventItem(165) or var3
	if var3 == 1 then
		vm.wait(14)
		event.LoadScript("i01h01/i01h01b_1.stb", 520)
		return
	end
	flag = event.GetFlag(17) or flag
	if flag == 1 then
		vm.wait(15)
		event.LoadScript("i01h01/i01h01b_1.stb", 510)
		return
	end
	flag = event.GetFlag(105) or flag
	if flag == 0 then
		event.MesMake_2(0, "Max, du kannst nicht einfach\nblaumachen, verstanden?")
		helper_907fd9a8(arg0, -1, 0, 0)
		return
	end
	event.SetAi(0, 24)
	event.MesMake_2(0, "Du musst es erst alleine\nversuchen, Junge.")
	helper_907fd9a8(arg0, -1, 0, 0)
	event.MesMake_2(0, "Wenn du nicht weiterkommst,\ngeb ich dir einen Tipp, ja?")
	helper_907fd9a8(arg0, -1, 0, 0)
	event.MesMake_2(0, "Jetzt mach dich ran!")
	helper_907fd9a8(arg0, -1, 0, 0)
	event.SetAi(1, 24)
end

--- Helper function.
local function helper_fe70()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	event.SetMesWindowMode(0, 1)
	var0 = event.GetEventData_2(13) or var0
	var1 = event.GetEventData_2(14) or var1
	print("[talk_chara]", var1, "\n")
	print("[talk_chara_id]", var1, "\n")
	if var1 == 1 then
		helper_e920(var0, var1)
	end
	if var1 == -1 then
		flag = event.GetFlag(6) or flag
		flag_2 = event.GetFlag(7) or flag_2
		if flag == 1 and flag_2 == 0 then
			vm.wait(2)
			event.LoadScript("i01h01/i01h01c_1.stb", 520)
		end
	end
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	print("i01h01--------start event----------\n")
	helper_7428e09f()
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	event.LoadScript("i01h01/i01h01c_1.stb", 151)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
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
	vm.wait(1)
	event.SetFadeIn(30)
	vm.wait(2)
	event.GotoOutside(-1, "m01")
	vm.wait(3)
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_24bece14()
	event.FuncPointShow("", "fc_event_e108c", 0)
	print("e105a i01h01.stb-------------------\n")
	event.LoadScript("i01h01/i01h01b_1.stb", 500)
	vm.wait(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	local at: number = 0
	return vm.guard(function()
		helper_24bece14()
		event.LoadChara(4, "event/e100/e105/e105_steve.gltf", "info", 25)
		event.CharaActive(1, 25)
		event.CharaActive(0, 24)
		event.SetCharaPos(25, -120.88, -13.05, -215.36)
		event.SetCharaRot(25, 0.0, 0.0, 0.0)
		at = 1
		vm.wait(1)
		print("スティーブ読み込んだ-------------\n")
		event.LoadScript("i01h01/i01h01c_1.stb", 510)
		print("いべんとe108b--------------\n")
		at = 2
		vm.wait(2)
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				print("スティーブ読み込んだ-------------\n")
				print("いべんとe108b--------------\n")
			end
			return 0
		end
		return nil
	end)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	helper_24bece14()
	event.LoadScript("i01h01/i01h01c_1.stb", 520)
	vm.wait(1)
end

--- Event 590, which map data, a script or the engine runs by number.
function script.event_590()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
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
	helper_25abe6d2(10)
	helper_e8257c69(386, 1)
	event.AddItem(386)
	helper_a87eb945(1)
	helper_24bece14()
end

--- Event 610, which map data, a script or the engine runs by number.
function script.event_610()
	print("event_610-------\n")
	helper_24bece14()
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		at = 1
		vm.wait(1)
		at = 2
		helper_fe70()
		return
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				helper_788a73ff()
			end
			return 0
		end
		return nil
	end)
end

--- Event 11051, which map data, a script or the engine runs by number.
function script.event_11051()
	vm.wait(1)
	event.LoadScript("i01h01/i01h01b_1.stb", 500)
	vm.wait(2)
end

--- Event 11052, which map data, a script or the engine runs by number.
function script.event_11052()
	helper_7428e09f()
	event.CharaActive(1, 25)
	vm.wait(1)
	event.LoadScript("i01h01/i01h01b_1.stb", 510)
	vm.wait(2)
end

--- Event 11053, which map data, a script or the engine runs by number.
function script.event_11053()
	helper_7428e09f()
	event.SetFlag(20, 0)
	event.CharaActive(1, 25)
	vm.wait(1)
	event.LoadScript("i01h01/i01h01b_1.stb", 11053)
	vm.wait(2)
end

--- Event 11060, which map data, a script or the engine runs by number.
function script.event_11060()
	helper_7428e09f()
	event.CharaActive(1, 25)
	vm.wait(1)
	event.LoadScript("i01h01/i01h01c_1.stb", 500)
	vm.wait(2)
end

--- Event 11083, which map data, a script or the engine runs by number.
function script.event_11083()
	event.JoinPartyMember(2) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
	event.SetFlag(25, 1)
	event.SetFlag(108, 0)
	event.SetFlag(103, 1)
	event.SetFlag(107, 1)
	event.SetFlag(7, 0)
	event.SetFlag(6, 1)
	vm.wait(1)
	event.LoadScript("i01h01/i01h01c_1.stb", 520)
	vm.wait(2)
end

return script
