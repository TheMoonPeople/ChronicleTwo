--!strict
-- map/s/s06/s06b.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02085c32 = require("@lib/event/helper_02085c32")
local helper_2867bf21 = require("@lib/event/helper_2867bf21")
local helper_59f899fe = require("@lib/event/helper_59f899fe")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local helper_9e7d1511 = require("@lib/event/helper_9e7d1511")
local helper_a5315cba = require("@lib/event/helper_a5315cba")
local helper_a7507a24 = require("@lib/event/helper_a7507a24")
local helper_c190f878 = require("@lib/event/helper_c190f878")

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
local function edit_analyze_changed()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ActchrSetDefMotion(0)
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		event.Initialize()
		event.DngPause(1, 1)
		var2 = event.JoinPartyMember(2) or var2
		if var2 ~= 0 then
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "今はそれどころじゃない！！")
			helper_9e7d1511(0, -1, 5, 0, 0)
			event.SetMesWindowMode(0, var1)
			vm.wait(2)
			event.DngPause(1, 0)
			event.Finish()
			return
		else
			event.SetMotion(0, "立ち")
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(104) or flag
			if flag == 1 then
				event.MesMake_2(0, "扉は開きそうにない。\nいったん上に戻ろう！")
			else
				event.MesMake_2(0, "今はそれどころじゃない！！")
			end
			helper_9e7d1511(0, -1, 5, 0, 0)
			event.SetMesWindowMode(0, var1)
			vm.wait(4)
			event.DngPause(1, 0)
			event.Finish()
			return
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "ライドポッドから降りないと先へ進めそうにない。")
		helper_9e7d1511(0, -1, 8, 256, 208)
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		helper_9e7d1511(0, 21, 8, 256, 208)
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "次のフロアへ進みますか？")
	var5 = helper_c190f878(0, -1, 8, 256, 208, 2, 1)
	if var5 == 0 then
		event.SetBitCtrl(1, 0)
		stage_id = event.DngGetStageId() or stage_id
		var7 = event.DngGetFloorId() or var7
		argc = event.GetNextFloor(var7, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var7, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetFadeOut(30)
		helper_888ab2a3(30)
		flag = event.GetFlag(8) or flag
		if flag == 0 then
			event.StopBgm(0)
			event.SetFlag(8, 1)
			event.BgmLoadCancel()
			event.GotoEdit(12, 540)
			vm.wait(9)
			return
		end
		event.BgmLoadCancel()
		event.GotoDng(0, 5, 1000)
		vm.wait(10)
	end
	event.Finish()
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
-- Defined empty, so the engine runs this instead of its default.
function script.key_open() end

--- Event 300, which map data, a script or the engine runs by number.
script.event_300 = edit_analyze_changed

script.edit_analyze_changed = edit_analyze_changed

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	event.LoadMonsterFile(614, 1)
	helper_a7507a24()
	event.SndLoadSound_3(4, "snd2/event/ev_200_000.sound.json")
	event.LoadScript("s06/s06.stb", -1)
end

--- Event 501, which map data, a script or the engine runs by number.
function script.event_501()
	event.Initialize()
	event.LoadScript("s06/s06c.stb", 500)
	vm.wait(1)
end

--- Event 510, which map data, a script or the engine runs by number.
function script.event_510()
	event.LoadMonsterFile(601, 1)
	helper_02085c32()
	event.LoadScript("s06/s06.stb", -1)
end

--- Event 520, which map data, a script or the engine runs by number.
function script.event_520()
	event.LoadMonsterFile(601, 1)
	helper_a5315cba()
	event.LoadScript("s06/s06.stb", -1)
end

--- Event 1200, which map data, a script or the engine runs by number.
function script.event_1200()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local at: number = 0
	return vm.guard(function()
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 2 then
			flag = event.GetFlag(7) or flag
			if flag == 0 then
				event.SetFlag(6, 1)
				at = 1
				vm.wait(1)
				event.LoadScript("s06/s06.stb", 503)
			else
				at = 2
				helper_59f899fe(0)
			end
		else
			at = 3
			helper_59f899fe(0)
		end
		return
	end, function(received: { any })
		if at <= 3 then
			if at <= 1 then
				helper_2867bf21(0)
			end
			if at <= 2 then
				helper_2867bf21(0)
			end
			return 0
		end
		return nil
	end)
end

return script
