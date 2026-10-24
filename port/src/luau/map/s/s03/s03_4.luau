--!strict
-- map/s/s03/s03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_05a5769c = require("@lib/event/helper_05a5769c")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_7d54f41c = require("@lib/event/helper_7d54f41c")
local helper_9209a4ef = require("@lib/event/helper_9209a4ef")
local helper_aa5b3ebe = require("@lib/event/helper_aa5b3ebe")
local helper_c190f878 = require("@lib/event/helper_c190f878")
local helper_d3f20302 = require("@lib/event/helper_d3f20302")
local helper_e4a05d14 = require("@lib/event/helper_e4a05d14")
local helper_f2b0ffcb = require("@lib/event/helper_f2b0ffcb")

--- Helper function.
local function helper_1644c()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local at: number = 0
	return vm.guard(function()
		event.SetFlag(205, 1)
		event.Initialize()
		event.LoadSound(2206)
		var0 = event.SndLoadSound_2(2206) or var0
		helper_482d9cfc()
		event.StopBgm(0)
		at = 1
		vm.wait(1)
		event.CharaActive(0, 0)
		event.CharaActive(1, 32)
		event.CharaActive(1, 33)
		event.CharaActive(1, 34)
		event.CharaActive(1, 35)
		event.CharaActive(1, 36)
		event.SndSePlay(var0, 5)
		event.SetCharaPos(36, 102.27, 0.0, -305.63)
		event.SetCharaRot(36, 0.0, 0.0, 0.0)
		event.SetCharaPos(35, 44.05, 0.0, 60.82)
		event.SetScale(35, 2.0, 2.0, 2.0)
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetPos(0, 256, 208)
		event.SpriteSetPutsize(0, 512, 416)
		event.SpriteSetColor(0, 0, 0, 0, 0)
		event.SpriteSetDraw(0, 1)
		event.EohSyncSprite(11, 0)
		event.ObjsInit(11)
		event.ObjsSyncObj(11, 11)
		event.SndSePlay(var0, 1)
		event.EohSyncObj_2(10, "p01_s03t")
		event.ObjsInit(10)
		event.ObjsSyncObj(10, 10)
		do
			local out1, out2, out3 = event.EohGetPos(10)
			pos_x = out1 or pos_x
			pos_y = out2 or pos_y
			pos_z = out3 or pos_z
		end
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.ObjsMove(10, 0.0, 51.92, 0.0, 60)
		event.ObjsRotation(10, 0.0, 0.0, -0.785, 60)
		event.CmrsSetPos(67.41, 107.89, 704.3)
		event.CmrsSetRef(59.64, 108.51, 271.98)
		event.CmrsMove2(58.28, 107.89, 196.59, 57.34, 108.51, 144.64, 50, 1, 0.4)
		at = 2
		helper_25abe6d2(45)
		event.ObjsSetColor(11, 0, 0, 0, 255, 30)
		at = 3
		helper_25abe6d2(30)
		event.SetMpcharaMotion("p01_s03t", "kikan-m", "停止")
		event.EsmClear()
		helper_f2b0ffcb()
		event.ObjsSetPos(10, pos_x, pos_y, pos_z)
		event.ObjsSetRot(10, 0.0, 0.0, 0.0)
		event.SoundAllStop()
		at = 4
		helper_25abe6d2(4)
		event.LoadBgm(60)
		event.PlayBgm(1)
		event.SetMesWindowMode(0, 8)
		event.MesMake_2(0, "Riprova.\nTorna alla Schermata Titolo.")
		at = 5
		var1 = helper_c190f878(0, -1, 8, 0, 0, 2, 0)
		event.CharaActive(1, 0)
		event.SetFadeOut(0)
		event.SpriteSetDraw(0, 0)
		return var1
	end, function(received: { any })
		if at <= 5 then
			if at == 5 then
				var1 = received[1] :: number
			end
			if at <= 1 then
				helper_d3f20302(45)
			end
			if at <= 2 then
				helper_d3f20302(30)
			end
			if at <= 3 then
				helper_1ef0d4b2()
				helper_d3f20302(4)
			end
			if at <= 4 then
				var1 = helper_7d54f41c(0, -1, 8, 0, 0, 2, 0)
			end
			return var1
		end
		return nil
	end)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 99, which map data, a script or the engine runs by number.
script.event_99 = helper_1ef0d4b2

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraPos(0.0, 200.0, -260.0)
	event.SetCameraRef(0.0, 170.0, -420.0)
	event.ResetCamera(0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	helper_25abe6d2(30)
	helper_05a5769c()
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_e4a05d14()
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Event 502, which map data, a script or the engine runs by number.
function script.event_502()
	event.BgmLoadCancel()
	event.MapJump_3(-1, "s08", 502)
	vm.wait(1)
end

--- Event 503, which map data, a script or the engine runs by number.
function script.event_503()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_9209a4ef()
	event.BgmPlayCancel()
	event.MapJump_2(-1, "s02")
	vm.wait(2)
end

--- Event 512, which map data, a script or the engine runs by number.
function script.event_512()
	local var0: any = 0
	var0 = helper_1644c()
	helper_aa5b3ebe(var0)
end

--- Event 12040, which map data, a script or the engine runs by number.
function script.event_12040()
	helper_e4a05d14()
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Event 12050, which map data, a script or the engine runs by number.
function script.event_12050()
	local var0: any = 0
	var0 = helper_1644c()
	helper_aa5b3ebe(var0)
end

--- Event 12060, which map data, a script or the engine runs by number.
script.event_12060 = helper_9209a4ef

--- Event 22010, which map data, a script or the engine runs by number.
function script.event_22010()
	vm.wait(1)
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.GotoSubgame(3)
end

return script
