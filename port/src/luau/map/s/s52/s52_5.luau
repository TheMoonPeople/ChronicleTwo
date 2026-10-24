--!strict
-- map/s/s52/s52_5.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_38eb2549 = require("@lib/event/helper_38eb2549")
local helper_664bc985 = require("@lib/event/helper_664bc985")
local helper_7d7eee8f = require("@lib/event/helper_7d7eee8f")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_c190f878 = require("@lib/event/helper_c190f878")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	event.StopBgm(0)
	event.LoadSound(8800)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local flag: s32 = 0
	event_99()
	helper_7d7eee8f(0.0, 0.0, 0.0, 0.0)
	event.SetCameraRef(0.0, 30.0, 0.0)
	event.SetCameraPos(0.0, 40.0, -120.0)
	event.ResetCamera(0)
	flag = event.GetFlag(804) or flag
	if flag == 0 then
		event.JoinPartyMember(1) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
		event.SetCharaChangeFlag(1, 1)
		event.SetCharaChangeMask(1, 1)
		event.JoinPartyMember(3) -- retail: argument 2 is a value where the handler writes an output; the output is discarded
		event.SetCharaChangeFlag(3, 1)
		event.SetCharaChangeMask(3, 1)
		helper_38eb2549()
		helper_9dafbc83(0.0, 0.0, 800.0, 0.0)
		event.SetCameraRef(0.0, 30.0, 800.0)
		event.SetCameraPos(0.0, 40.0, 680.0)
		event.ResetCamera(0)
	end
	event.SetFadeIn(30)
	event.Finish()
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	event.Initialize()
	vm.wait(1)
	event.Finish()
end

--- Event 300, which map data, a script or the engine runs by number.
function script.event_300()
	local active_chr_no: s32 = 0
	local var1: any = 0
	local stage_id: s32 = 0
	local var3: s32 = 0
	local argc: s32 = 0
	event.Initialize()
	event.ActchrSetDefMotion(0)
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 or active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesDrawspeed(0, 1)
		if active_chr_no == 2 then
			helper_9e7d1511(0, 20, 5, 256, 208)
		else
			helper_9e7d1511(0, 21, 5, 256, 208)
		end
		event.Finish()
		return
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var1 = helper_c190f878(0, 10, 8, 256, 208, 2, 1)
	if var1 == 0 then
		event.SetFadeOut(30)
		helper_25abe6d2(30)
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

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	helper_664bc985(0)
end

--- Event 18040, which map data, a script or the engine runs by number.
script.event_18040 = helper_38eb2549

return script
