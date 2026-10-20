--!strict
-- map/s/s03/s03_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_482d9cfc = require("@lib/event/helper_482d9cfc")
local helper_7bf04a2b = require("@lib/event/helper_7bf04a2b")
local helper_83f868da = require("@lib/event/helper_83f868da")
local helper_88f239cd = require("@lib/event/helper_88f239cd")
local helper_c1c32f84 = require("@lib/event/helper_c1c32f84")
local helper_d57cd169 = require("@lib/event/helper_d57cd169")
local helper_d7185d95 = require("@lib/event/helper_d7185d95")
local helper_dacb6511 = require("@lib/event/helper_dacb6511")

--- Helper function.
local function helper_1644c()
	local var0: s32 = 0
	local var1: any = 0
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c1c32f84(45)
		end
		if at <= 2 then
			helper_c1c32f84(30)
		end
		if at <= 3 then
			helper_7bf04a2b()
			helper_c1c32f84(4)
		end
		if at <= 4 then
			var1 = helper_83f868da(0, -1, 8, 0, 0, 2, 0)
		end
		return var1
	end
	event.SetFlag(205, 1)
	event.Initialize()
	event.LoadSound(2206)
	var0 = event.SndLoadSound(2206) or var0
	helper_482d9cfc()
	event.StopBgm(0)
	if vm.wait() then
		return skip(1)
	end
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
	event.EohSyncObj(10, "p01_s03t")
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
	helper_c1c32f84(45)
	if vm.skipping() then
		return skip(2)
	end
	event.ObjsSetColor(11, 0, 0, 0, 255, 30)
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "停止")
	event.EsmClear()
	helper_7bf04a2b()
	event.ObjsSetPos(10, pos_x, pos_y, pos_z)
	event.ObjsSetRot(10, 0.0, 0.0, 0.0)
	event.SoundAllStop()
	helper_c1c32f84(4)
	if vm.skipping() then
		return skip(4)
	end
	event.LoadBgm(60)
	event.PlayBgm(1)
	event.SetMesWindowMode(0, 8)
	event.MesMake_2(0, "Riprova.\nTorna alla Schermata Titolo.")
	var1 = helper_83f868da(0, -1, 8, 0, 0, 2, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.CharaActive(1, 0)
	event.SetFadeOut(0)
	event.SpriteSetDraw(0, 0)
	return var1
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_1ef0d4b2

--- Program 100.
script[100] = function()
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetCameraPos(0.0, 200.0, -260.0)
	event.SetCameraRef(0.0, 170.0, -420.0)
	event.ResetCamera(0)
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d57cd169()
		end
	end
	helper_c1c32f84(30)
	if vm.skipping() then
		return skip(1)
	end
	helper_d57cd169()
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_dacb6511()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Program 502.
script[502] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.BgmLoadCancel()
	event.MapJump(-1, "s08", 502)
	if vm.wait() then
		return skip(1)
	end
end

--- Program 503.
script[503] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMpcharaMotion("p01_s03t", "kikan-m", "機関")
	helper_88f239cd()
	if vm.skipping() then
		return skip(1)
	end
	event.BgmPlayCancel()
	event.MapJump(-1, "s02")
	if vm.wait() then
		return skip(2)
	end
end

--- Program 512.
script[512] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d7185d95(var0)
	end
	var0 = helper_1644c()
	if vm.skipping() then
		return skip(1)
	end
	helper_d7185d95(var0)
end

--- Program 12040.
script[12040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_dacb6511()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(15)
	event.GotoSubgame(3)
end

--- Program 12050.
script[12050] = function()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_d7185d95(var0)
	end
	var0 = helper_1644c()
	if vm.skipping() then
		return skip(1)
	end
	helper_d7185d95(var0)
end

--- Program 12060.
script[12060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_88f239cd()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 22010.
script[22010] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.SetCharaPos(0, 0.0, 140.0, -420.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.GotoSubgame(3)
end

return script
