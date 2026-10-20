--!strict
-- map/i/i03/h05/i03h05_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")

--- Program 500.
local function program_500()
	local block: s32 = 0
	local omake_flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_bdbefa67(100)
		end
		if at <= 2 then
			helper_bdbefa67(30)
		end
	end
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
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(1)
	end
	event.SpriteSetDraw(0, 1)
	event.ObjsSetColor(2, 128, 128, 128, 128, 30)
	helper_bdbefa67(100)
	if vm.skipping() then
		return skip(2)
	end
	event.SetFadeOut(30)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(3)
	end
	event.SpriteSetDraw(0, 0)
	event.DelImg(0)
	if vm.wait() then
		return skip(4)
	end
	event.GotoSubgame(2)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
-- Defined empty, so the engine runs this instead of its default.
script[100] = function() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_500()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 350.
script[350] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_bdbefa67(30)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.FadeOutBgm(30)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(3)
	end
	event.StopBgm(0)
	event.BgmLoadCancel()
	if vm.wait() then
		return skip(4)
	end
	event.MapJump(-1, "i03h04", 502)
	if vm.wait() then
		return skip(5)
	end
end

--- Program 352.
script[352] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_bdbefa67(30)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	event.FadeOutBgm(30)
	helper_bdbefa67(30)
	if vm.skipping() then
		return skip(3)
	end
	event.StopBgm(0)
	event.BgmLoadCancel()
	if vm.wait() then
		return skip(4)
	end
	event.MapJump(-1, "i03h04", 503)
	if vm.wait() then
		return skip(5)
	end
end

script[500] = program_500

--- Program 1000.
-- Defined empty, so the engine runs this instead of its default.
script[1000] = function() end

return script
