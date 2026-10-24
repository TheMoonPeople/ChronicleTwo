--!strict
-- map/i/i04/h01/i04h01_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1a76905c = require("@lib/event/helper_1a76905c")
local helper_1d176c96 = require("@lib/event/helper_1d176c96")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_581cb30c = require("@lib/event/helper_581cb30c")
local helper_6c0ef236 = require("@lib/event/helper_6c0ef236")
local helper_a3cc6850 = require("@lib/event/helper_a3cc6850")
local helper_a8747d6e = require("@lib/event/helper_a8747d6e")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_acffd9e4 = require("@lib/event/helper_acffd9e4")
local helper_b36057b4 = require("@lib/event/helper_b36057b4")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	helper_acffd9e4()
	event.ResetCamera(1, 0.0)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_1d176c96

--- Event 400, which map data, a script or the engine runs by number.
function script.event_400()
	local flag: s32 = 0
	event.SetMotion(0, "立ち")
	flag = event.GetFlag(38) or flag
	if flag == 0 then
		event.SetFlag(38, 1)
		event.AddItem(357)
		helper_e8257c69(357, 1)
		helper_6c0ef236(0)
		helper_a87eb945(1)
	end
end

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_1a76905c()
	event.CancelNowLoading()
	event.GotoDng(0, 3, 500)
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	helper_a8747d6e()
	event.MapJump_3(-1, "g01i07", 502)
	vm.wait(2)
end

--- Event 530, which map data, a script or the engine runs by number.
function script.event_530()
	local block: s32 = 0
	helper_1d176c96()
	event.PauseEnableFlag(0)
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetBgColor(0, 0, 0)
	event.SetFadeIn(0)
	event.LoadMovie(5, "movie/end1.mp4")
	event.SetFadeOut(0)
	event.SoundAllStop()
	event.SndInReverb(0)
	helper_25abe6d2(2)
	block = event.LoadImg_4(5, "textures/event/e700/e736/e73601_1.json", 0) or block
	event.SpriteInit(0)
	event.SpriteSetType(0, 0)
	event.SpriteSetColor(0, 0, 0, 0, 128)
	event.SpriteSetPutsize(0, 512, 448)
	event.SpriteSetPos(0, 256, 224)
	event.SpriteSetDraw(0, 1)
	event.SpriteInit(1)
	event.SpriteSetType(1, 0)
	event.SpriteSetTexture(1, "e73601", block)
	event.SpriteSetColor(1, 128, 128, 128, 128)
	event.SpriteSetUvsize(1, 0, 0, 512, 448)
	event.SpriteSetPutsize(1, 512, 448)
	event.SpriteSetPos(1, 256, 224)
	event.SpriteSetDraw(1, 1)
	event.SetFadeIn(60)
	helper_25abe6d2(90)
	while true do
		if helper_581cb30c(0) ~= 0 then
			break
		else
			vm.wait(4)
		end
	end
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SpriteSetDraw(1, 0)
	event.SetFadeIn(0)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "Guardar - Cap[UNI00ed]tulo 8 Archivo de inicio")
	helper_a3cc6850(0, -1, 8, 0, 0)
	event.SetFadeOut(0)
	helper_25abe6d2(2)
	event.SpriteSetDraw(0, 0)
	event.SetFlag(799, 1)
	event.SetSavedataEtc(0, 10)
	event.SetFlag(736, 1)
	event.SetFlag(800, 0)
	event.SetBitCtrl(1, 0)
	event.SetBitCtrl(8, 0)
	event.SetActiveChrNo(0)
	event.LeaveMonicaItemCheck()
	event.JoinPartyMember(3) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
	event.SetCharaChangeFlag(3, 0)
	event.SetCharaChangeMask(3, 0)
	event.JoinPartyMember(1) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
	event.SetCharaChangeFlag(1, 0)
	event.SetCharaChangeMask(1, 0)
	event.SetSavedataEtc(3, 1)
	event.SetTime(6.0)
	event.GotoMenu(7)
	vm.wait(8)
	event.SndInReverb(1)
	event.SetExitFlag(1)
end

--- Event 600, which map data, a script or the engine runs by number.
script.event_600 = helper_a8747d6e

--- Event 610, which map data, a script or the engine runs by number.
script.event_610 = helper_1a76905c

--- Event 1000, which map data, a script or the engine runs by number.
script.event_1000 = helper_b36057b4

--- Event 11020, which map data, a script or the engine runs by number.
function script.event_11020()
	event.StopBgm(0)
	helper_1a76905c()
	event.CancelNowLoading()
	event.GotoDng(0, -1, 500)
	event.SetFadeOut(0, 255.0, 255.0, 255.0)
	vm.wait(2)
end

return script
