--!strict
-- map/i/i03/h05/i03h05_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")

--- Event 500, which map data, a script or the engine runs by number.
local function event_500()
	local block: s32 = 0
	local omake_flag: s32 = 0
	local var2: s32 = 0
	event.Initialize()
	event.StopBgm(0)
	event.LoadBgm(165)
	event.AssignStack(5)
	event.ClearStack(5)
	omake_flag = event.GetOmakeFlag() or omake_flag
	if omake_flag ~= 0 then
		block = event.LoadImg_4(5, "textures/event/e00/e70/matchrace_1.json", 0) or block
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		event.SpriteSetTexture(0, "matchrace", block)
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetUvsize(0, 0, 0, 384, 128)
		event.SpriteSetPutsize(0, 384, 128)
		event.SpriteSetPos(0, 256, 192)
		event.SpriteSetDraw(0, 0)
		event.EohSyncSprite(2, 0)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	else
		var2 = event.GetGyoraceEtc(3) or var2
		if var2 == 0 then
			block = event.LoadImg_4(5, "textures/event/e00/e70/yosen_1.json", 0) or block
		end
		if var2 == 1 then
			block = event.LoadImg_4(5, "textures/event/e00/e70/honsen_1.json", 0) or block
		end
		if var2 == 2 then
			block = event.LoadImg_4(5, "textures/event/e00/e70/kesshou_1.json", 0) or block
		end
		event.SpriteInit(0)
		event.SpriteSetType(0, 0)
		if var2 == 0 then
			event.SpriteSetTexture(0, "yosen", block)
		end
		if var2 == 1 then
			event.SpriteSetTexture(0, "honsen", block)
		end
		if var2 == 2 then
			event.SpriteSetTexture(0, "kesshou", block)
		end
		event.SpriteSetColor(0, 128, 128, 128, 0)
		event.SpriteSetUvsize(0, 0, 0, 384, 128)
		event.SpriteSetPutsize(0, 384, 128)
		event.SpriteSetPos(0, 256, 192)
		event.SpriteSetDraw(0, 0)
		event.EohSyncSprite(2, 0)
		event.ObjsInit(2)
		event.ObjsSyncObj(2, 2)
	end
	event.PlayBgm(0)
	event.SetCameraPos(426.45, 204.62, 518.58)
	event.SetCameraRef(-91.31, -38.79, 540.16)
	event.CmrsMove(426.45, 204.62, 518.58, 204.29, -38.79, 47.09, 160)
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(2, 128, 128, 128, 128, 30)
	helper_25abe6d2(100)
	event.SetFadeOut(30)
	helper_25abe6d2(30)
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
	vm.wait(4)
	event.GotoSubgame(2)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
-- Defined empty, so the engine runs this instead of its default.
function script.default_event() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = event_500

--- The event run when the Gyorace ends without the bonus flag.
function script.gyorace_end()
	event.Initialize()
	vm.wait(1)
	vm.wait(2)
	event.FadeOutBgm(30)
	helper_25abe6d2(30)
	event.StopBgm(0)
	event.BgmLoadCancel()
	vm.wait(4)
	event.MapJump_3(-1, "i03h04", 502)
	vm.wait(5)
end

--- The event run when the Gyorace ends with the bonus flag.
function script.gyorace_omake_end()
	event.Initialize()
	vm.wait(1)
	vm.wait(2)
	event.FadeOutBgm(30)
	helper_25abe6d2(30)
	event.StopBgm(0)
	event.BgmLoadCancel()
	vm.wait(4)
	event.MapJump_3(-1, "i03h04", 503)
	vm.wait(5)
end

script.event_500 = event_500

--- Event 1000, which map data, a script or the engine runs by number.
-- Defined empty, so the engine runs this instead of its default.
function script.event_1000() end

return script
