--!strict
-- map/s/s21/s21_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1c68bb96 = require("@lib/event/helper_1c68bb96")
local helper_68b3b239 = require("@lib/event/helper_68b3b239")
local helper_6c89029a = require("@lib/event/helper_6c89029a")
local helper_86897fcc = require("@lib/event/helper_86897fcc")
local helper_a2420aa8 = require("@lib/event/helper_a2420aa8")
local helper_efffcfbb = require("@lib/event/helper_efffcfbb")
local helper_f319b174 = require("@lib/event/helper_f319b174")
local helper_f624c226 = require("@lib/event/helper_f624c226")

--- Program 99.
local function program_99()
	local argc: s32 = 0
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7689)
	argc = event.GetItemHaveNum(374) or argc
	flag = event.GetFlag(708) or flag
	if argc >= 1 or flag == 1 then
		event.FuncPointShow("", "item", 0)
	else
		event.EohSyncObj(0, "p06s21")
		event.EohSetShow(0, 1)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetBitCtrl(1, 1)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
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
		helper_f319b174(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		helper_f319b174(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
	end
	program_99()
	flag = event.GetFlag(704) or flag
	if flag == 0 then
		helper_1c68bb96()
		if vm.skipping() then
			return skip(1)
		end
		helper_f319b174(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.8, -200.0)
		event.SetCameraPos(0.0, 40.8, -80.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_f319b174(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 38.4, 685.0)
		event.SetCameraPos(0.0, 48.4, 565.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	local t0 = helper_f624c226()
	if vm.skipping() then
		return skip(1)
	end
	if t0 ~= 0 then
		event.SetCharaShow(1, 1)
		event.SetCharaShow(2, 1)
		event.DngPause(8192, 0)
		event.ActchrSetDefMotion(0)
		event.SetCharaChangeMask(2, 1)
		event.SetCharaChangeMask(3, 1)
		event.SetBitCtrl(1, 0)
		event.LoadScript("d06/d06.stb", 1000)
	end
end

--- Program 500.
script[500] = function()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_68b3b239(0, 23, 5, 256, 208)
			end
			return
		end
		if at <= 3 then
			helper_efffcfbb(16)
		end
		if at <= 4 then
			helper_86897fcc(374, 1)
		end
		if at <= 5 then
			helper_6c89029a(1)
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_68b3b239(0, 22, 5, 256, 208)
			if vm.skipping() then
				return skip(1)
			end
		else
			helper_68b3b239(0, 23, 5, 256, 208)
			if vm.skipping() then
				return skip(2)
			end
		end
		event.Finish()
		return
	end
	stage_id = event.DngGetStageId() or stage_id
	var2 = event.DngGetFloorId() or var2
	argc = event.GetNextFloor(var2, 0) or argc
	event.DngSetFloorId(argc)
	event.SetFloorInfo(stage_id, var2, 5, 2)
	event.SetFloorInfo(stage_id, argc, 5, 1)
	helper_efffcfbb(6)
	if vm.skipping() then
		return skip(3)
	end
	do
		local out1, out2, out3 = event.GetEventData_4(10)
		var4 = out1 or var4
		var5 = out2 or var5
		var6 = out3 or var6
	end
	event.EohSyncChara(0, 0)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.ObjsSetMotion(0, "歩き")
	event.ObjsMotionDelay(0, 10)
	event.ObjsSetMotion(0, "立ち")
	event.ObjsReference(0, var4, var5, var6, 10)
	helper_efffcfbb(16)
	if vm.skipping() then
		return skip(4)
	end
	event.EohSyncObj(1, "p06s21")
	event.EohSetShow(1, 0)
	event.AddItem(374)
	helper_86897fcc(374, 1)
	if vm.skipping() then
		return skip(5)
	end
	event.SetFloorInfo(6, 11, 5, 2)
	event.FuncPointShow("", "item", 0)
	helper_6c89029a(1)
	if vm.skipping() then
		return skip(6)
	end
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_a2420aa8(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 17040.
script[17040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1c68bb96()
	if vm.skipping() then
		return skip(1)
	end
end

return script
