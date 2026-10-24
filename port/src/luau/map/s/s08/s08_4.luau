--!strict
-- map/s/s08/s08_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_5be5f988 = require("@lib/event/helper_5be5f988")
local helper_701ece99 = require("@lib/event/helper_701ece99")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_907fd9a8 = require("@lib/event/helper_907fd9a8")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_bb8b1e1d = require("@lib/event/helper_bb8b1e1d")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_df4094fb = require("@lib/event/helper_df4094fb")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")

local global0: s32 = 0

--- Helper function.
local function helper_23d98()
	event.SndSePlay(global0, 2)
	event.SndSePlay(global0, 8)
end

--- Helper function.
local function helper_23e54()
	event.Initialize()
	global0 = 0
	event.LoadSound(2200)
	global0 = event.SndLoadSound_2(2200) or global0
	event.AssignStack(4)
	event.ClearStack(4)
	event.LoadChara(4, "event/e200/e203/e203_starbre.gltf", "info", 9)
	event.EohSyncChara(1, 9)
	event.ObjsInit(1)
	event.ObjsSyncObj(1, 1)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, 5.62, 36.1, 39.9)
	event.SetCharaRot(9, 0.0, 3.04, 0.0)
	event.SetMotion(9, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_vorneo.gltf", "info", 10)
	event.EohSyncChara(2, 10)
	event.ObjsInit(2)
	event.ObjsSyncObj(2, 2)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, -38.37, 36.08, 32.88)
	event.SetCharaRot(10, 0.0, 1.48, 0.0)
	event.SetMotion(10, "立ち", 4)
	event.LoadChara(4, "event/e200/e203/e203_tom.gltf", "info", 11)
	event.EohSyncChara(3, 11)
	event.ObjsInit(3)
	event.ObjsSyncObj(3, 3)
	event.CharaActive(1, 11)
	event.SetCharaPos(11, -1.81, 36.1, 72.51)
	event.SetCharaRot(11, 0.0, -0.48, 0.0)
	event.SetMotion(11, "立ち", 4)
	event.EohSetSoundId(3, global0)
	event.RegisterVillager(9, 1)
	event.RegisterVillager(10, 2)
	event.RegisterVillager(11, 13, 65)
	event.SetCharaNo(9, 1)
	event.SetCharaNo(10, 2)
	event.SetCharaNo(11, 13)
	helper_23d98()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local mc_load: s32 = 0
	helper_19b130fb()
	helper_8b00b423()
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag == 1 and flag_2 == 0 then
		helper_7f754b8f(1)
		event.SetBitCtrl(1, 1)
	else
		helper_7f754b8f(0)
	end
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, 38.0, 36.1, -100.0)
		event.SetCharaRot(0, 0.0, 0.0, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
	end
	if flag == 1 and flag_2 == 0 then
		helper_23e54()
	end
	event.SetFadeIn(30)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
	helper_a3cc6850(0, 1002, 8, 450, 100)
	event.Test(0)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	local var0: s32 = 0
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_5be5f988()
	end
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	local var0: s32 = 0
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_5be5f988()
	end
end

--- Event 203, which map data, a script or the engine runs by number.
function script.event_203()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetBitCtrl(1, 0)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetCnt(0, 1)
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.MapJump_2(-1, "s07")
	end
end

--- Event 204, which map data, a script or the engine runs by number.
function script.event_204()
	local flag: s32 = 0
	local flag_2: s32 = 0
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(30)
		event.SndSeStop(global0, 2)
		event.SndSeStop(global0, 8)
		event.MapJump_3(-1, "s03", 501)
		vm.wait(1)
	end
end

--- Event 205, which map data, a script or the engine runs by number.
function script.event_205()
	local var0: s32 = 0
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 206, which map data, a script or the engine runs by number.
function script.event_206()
	local var0: s32 = 0
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 208, which map data, a script or the engine runs by number.
function script.event_208()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event208-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 209, which map data, a script or the engine runs by number.
function script.event_209()
	local flag: s32 = 0
	local flag_2: s32 = 0
	print("--------------------------event209-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetFuncEtc(0)
		vm.wait(1)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	event.SetSavedataEtc(3, 1)
	helper_f57795f8()
	event.SetSavedataEtc(3, 0)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23e54()
	helper_bb8b1e1d()
	event.SetBitCtrl(1, 1)
	helper_23d98()
	event.SetFadeIn(30)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	helper_701ece99()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s03", 512)
	vm.wait(2)
end

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	helper_125385ee(0, 1)
	if var0 == 9 then
		event.MesMake_2(0, "Non stare l[UNI00ec] impalato.\nSbrigati a salire su quella scala!")
	end
	if var0 == 10 then
		event.MesMake_2(
			0,
			"Non [UNI00e8] il momento di perdersi in\nchiacchiere! Max, muoviti e vai\na vedere com'[UNI00e8] l[UNI00e0] fuori!"
		)
	end
	if var0 == 11 then
		event.MesMake_2(
			0,
			"A giudicare dai colpi, direi\nche erano delle bombe piccole.<page>Spero solo che non abbiano\ncolpito niente di importante."
		)
	end
	helper_907fd9a8(var0, -1, 0, 0)
end

--- Event 12030, which map data, a script or the engine runs by number.
function script.event_12030()
	helper_23e54()
	helper_bb8b1e1d()
	helper_23d98()
	event.SetFadeIn(30)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	helper_701ece99()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s03", 512)
	vm.wait(2)
end

return script
