--!strict
-- map/s/s21/s21_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_664bc985 = require("@lib/event/helper_664bc985")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_b2900e73 = require("@lib/event/helper_b2900e73")
local helper_b4e76171 = require("@lib/event/helper_b4e76171")
local helper_cb4736df = require("@lib/event/helper_cb4736df")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	local argc: s32 = 0
	local flag: s32 = 0
	event.StopBgm(0)
	event.LoadSound(7689)
	argc = event.GetItemHaveNum(374) or argc
	flag = event.GetFlag(708) or flag
	if argc >= 1 or flag == 1 then
		event.FuncPointShow("", "item", 0)
	else
		event.EohSyncObj_2(0, "p06s21")
		event.EohSetShow(0, 1)
	end
	event.DngPause(8192, 1)
	event.SetCharaChangeMask(2, 0)
	event.SetCharaChangeMask(3, 0)
	event.SetBitCtrl(1, 1)
	event.SetCharaShow(1, 0)
	event.SetCharaShow(2, 0)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	flag = event.GetFlag(704) or flag
	if flag == 0 then
		helper_cb4736df()
		helper_9dafbc83(0.0, vm.f32(0.8), -200.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 30.8, -200.0)
		event.SetCameraPos(0.0, 40.8, -80.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	else
		helper_9dafbc83(0.0, vm.f32(8.4), 685.0, vm.f32(3.14))
		event.SetCameraRef(0.0, 38.4, 685.0)
		event.SetCameraPos(0.0, 48.4, 565.0)
		event.ResetCamera(0)
		event.SetFadeIn(30)
		event.Finish()
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_b4e76171() ~= 0 then
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

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	local active_chr_no: s32 = 0
	local stage_id: s32 = 0
	local var2: s32 = 0
	local argc: s32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_9e7d1511(0, 22, 5, 256, 208)
		else
			helper_9e7d1511(0, 23, 5, 256, 208)
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
	helper_25abe6d2(6)
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
	helper_25abe6d2(16)
	event.EohSyncObj_2(1, "p06s21")
	event.EohSetShow(1, 0)
	event.AddItem(374)
	helper_b2900e73(374, 1)
	event.SetFloorInfo(6, 11, 5, 2)
	event.FuncPointShow("", "item", 0)
	helper_a87eb945(1)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_664bc985(0)
end

--- Event 17040, which map data, a script or the engine runs by number.
script.event_17040 = helper_cb4736df

return script
