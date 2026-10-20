--!strict
-- map/s/s08/s08_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_19b130fb = require("@lib/event/helper_19b130fb")
local helper_1d36919a = require("@lib/event/helper_1d36919a")
local helper_32403b8e = require("@lib/event/helper_32403b8e")
local helper_41e80f11 = require("@lib/event/helper_41e80f11")
local helper_64e8febf = require("@lib/event/helper_64e8febf")
local helper_6d4ef5d4 = require("@lib/event/helper_6d4ef5d4")
local helper_7f754b8f = require("@lib/event/helper_7f754b8f")
local helper_7f75e08e = require("@lib/event/helper_7f75e08e")
local helper_8711132c = require("@lib/event/helper_8711132c")
local helper_8b00b423 = require("@lib/event/helper_8b00b423")
local helper_941747e9 = require("@lib/event/helper_941747e9")
local helper_bbdf53e9 = require("@lib/event/helper_bbdf53e9")
local helper_df4094fb = require("@lib/event/helper_df4094fb")

local global0: s32 = 0

--- Helper function.
local function helper_23da8()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.SndSePlay(global0, 2)
	event.SndSePlay(global0, 8)
end

--- Helper function.
local function helper_23e64()
	event.Initialize()
	global0 = 0
	event.LoadSound(2200)
	global0 = event.SndLoadSound(2200) or global0
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
	helper_23da8()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
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
		helper_23e64()
	end
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bbdf53e9(64)
		end
		if at <= 2 then
			helper_41e80f11(0, 1002, 8, 450, 100)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_bbdf53e9(64)
	if vm.skipping() then
		return skip(2)
	end
	helper_41e80f11(0, 1002, 8, 450, 100)
	if vm.skipping() then
		return skip(3)
	end
	event.Test(0)
end

--- Program 200.
script[200] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("-------event_200----------------------\n")
	var0 = helper_df4094fb(1)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 1)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_941747e9()
		if vm.skipping() then
			return skip(1)
		end
	end
end

--- Program 201.
script[201] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("-------event_201----------------------\n")
	var0 = helper_df4094fb(0)
	if var0 ~= 0 then
		event.SetBitCtrl(1, 0)
		event.SetCnt(15, 0)
		event.SetFadeOut(0)
		event.StopBgm(0)
		helper_941747e9()
		if vm.skipping() then
			return skip(1)
		end
	end
end

--- Program 203.
script[203] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetBitCtrl(1, 0)
		event.Initialize()
		event.SetMesWindowMode(0, 7)
		event.SetCnt(0, 1)
		event.SetFadeOut(30)
		helper_7f75e08e(30)
		if vm.skipping() then
			return skip(1)
		end
		event.SetCharaPos(0, 0.0, 36.0, 235.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.MapJump(-1, "s07")
	end
end

--- Program 204.
script[204] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetBitCtrl(1, 0)
		event.SetFadeIn(30)
		event.SndSeStop(global0, 2)
		event.SndSeStop(global0, 8)
		event.MapJump(-1, "s03", 501)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 205.
script[205] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event205-------------------------\n")
	var0 = helper_df4094fb(1)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 206.
script[206] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event206-------------------------\n")
	var0 = helper_df4094fb(0)
	if var0 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 208.
script[208] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event208-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 209.
script[209] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	print("--------------------------event209-------------------------\n")
	flag = event.GetFlag(203) or flag
	flag_2 = event.GetFlag(204) or flag_2
	if flag ~= 0 and flag_2 == 0 then
	else
		event.SetFuncEtc(0)
		if vm.wait() then
			return skip(1)
		end
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetSavedataEtc(3, 1)
	helper_64e8febf()
	if vm.skipping() then
		return skip(1)
	end
	event.SetSavedataEtc(3, 0)
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_23da8()
	end
	helper_8b00b423()
	helper_7f754b8f(1)
	helper_23e64()
	helper_6d4ef5d4()
	if vm.skipping() then
		return skip(1)
	end
	event.SetBitCtrl(1, 1)
	helper_23da8()
	event.SetFadeIn(30)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1d36919a()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s03", 512)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.GetEventData_2(13) or var0
	helper_8711132c(0, 1)
	if var0 == 9 then
		event.MesMake_2(0, "Allez. D[UNI00e9]p[UNI00ea]che-toi de\nmonter [UNI00e0] cette [UNI00e9]chelle !")
	end
	if var0 == 10 then
		event.MesMake_2(
			0,
			"On n'a pas le temps de bavarder.\nMax, d[UNI00e9]p[UNI00ea]che-toi d'aller\nvoir comment c'est dehors !"
		)
	end
	if var0 == 11 then
		event.MesMake_2(
			0,
			"D'apr[UNI00e8]s les secousses, je dirais\nque c'[UNI00e9]tait de petites bombes.<page>J'esp[UNI00e8]re juste qu'elles\nn'endommageront rien d'important."
		)
	end
	helper_32403b8e(var0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 12030.
script[12030] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		helper_23da8()
	end
	helper_23e64()
	helper_6d4ef5d4()
	if vm.skipping() then
		return skip(1)
	end
	helper_23da8()
	event.SetFadeIn(30)
end

--- Program 12050.
script[12050] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1d36919a()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmLoadCancel()
	event.MapJump(-1, "s03", 512)
	if vm.wait() then
		return skip(2)
	end
end

return script
