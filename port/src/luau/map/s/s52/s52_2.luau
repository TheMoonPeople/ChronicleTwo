--!strict
-- map/s/s52/s52_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18063f80 = require("@lib/event/helper_18063f80")
local helper_1f7590b4 = require("@lib/event/helper_1f7590b4")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_b4722ae5 = require("@lib/event/helper_b4722ae5")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")
local helper_bf4fc68b = require("@lib/event/helper_bf4fc68b")
local helper_dabc0c0a = require("@lib/event/helper_dabc0c0a")

--- Program 99.
local function program_99()
	event.StopBgm(0)
	event.LoadSound(8800)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_dabc0c0a(0.0, 0.0, 800.0, 0.0)
	end
	program_99()
	helper_7d7eee8f(0.0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 0.0)
	event.SetCameraPos(0.0, 40.0, -120.0)
	event.ResetCamera(0)
	flag = event.GetFlag(804) or flag
	if flag == 0 then
		event.ExtTyped(1078, "ii", 1, 1)
		event.SetCharaChangeFlag(1, 1)
		event.SetCharaChangeMask(1, 1)
		event.ExtTyped(1078, "ii", 3, 1)
		event.SetCharaChangeFlag(3, 1)
		event.SetCharaChangeMask(3, 1)
		helper_b4722ae5()
		if vm.skipping() then
			return skip(1)
		end
		helper_dabc0c0a(0.0, 0.0, 800.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 800.0)
		event.SetCameraPos(0.0, 40.0, 680.0)
		event.ResetCamera(0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.Finish()
end

--- Program 300.
script[300] = function()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_18063f80(0, 21, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_bdbefa67(30)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_18063f80(0, 20, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_18063f80(0, 21, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var1 = helper_1f7590b4(0, 10, 8, 256, 208, 2, 1)
	if vm.skipping() then
		return skip(3)
	end
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_bdbefa67(30)
		if vm.skipping() then
			return skip(4)
		end
		stage_id = event.DngGetStageId() or stage_id
		var3 = event.DngGetFloorId() or var3
		argc = event.GetNextFloor(var3, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var3, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.LoadScript("d07/d07.stb", 1000)
	else
		event.Finish()
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_bf4fc68b(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 18040.
script[18040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_b4722ae5()
	if vm.skipping() then
		return skip(1)
	end
end

return script
