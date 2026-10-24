--!strict
-- map/g/g05/g05_4.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_2b32f1e8 = require("@lib/event/helper_2b32f1e8")
local helper_38a7fa45 = require("@lib/event/helper_38a7fa45")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_a87eb945 = require("@lib/event/helper_a87eb945")
local helper_c956b4a2 = require("@lib/event/helper_c956b4a2")
local helper_cbb3ef78 = require("@lib/event/helper_cbb3ef78")
local helper_cbfc194e = require("@lib/event/helper_cbfc194e")
local helper_e8257c69 = require("@lib/event/helper_e8257c69")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99() end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	event_99()
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		helper_9dafbc83(40.0, 0.0, 1400.0, vm.f32(3.14))
		event.ResetCamera(1, 3.14, 10.0)
		event.SetFadeIn(30)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 and old_map_no ~= 4 then
			if old_map_no == 109 then
				helper_9dafbc83(0.0, vm.f32(140.7), -1750.0, 0.0)
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			else
				helper_9dafbc83(0.0, 0.0, 1400.0, vm.f32(3.14))
				event.ResetCamera(1, 3.14, 10.0)
				event.SetFadeIn(30)
			end
		end
	end
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
function script.key_open()
	vm.wait(1)
	helper_c956b4a2(64)
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_cbb3ef78(155) ~= 0 then
		event.MapJump_2(-1, "s34")
	end
end

--- Event 210, which map data, a script or the engine runs by number.
function script.event_210()
	local flag: s32 = 0
	if helper_cbb3ef78(109) ~= 0 then
		flag = event.GetFlag(702) or flag
		if flag == 0 then
			event.BgmLoadCancel()
		end
		event.MapJump_2(-1, "d06e01")
	end
end

--- The event run when the edit analysis found changes after a house door step or a Georama mode change.
function script.edit_analyze_changed()
	if (if helper_38a7fa45() ~= 0 then helper_2b32f1e8() else 0) ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetFlag(744, 1)
		event.SetFlag(748, 1)
		event.MapJump_3(-1, "s44", 570)
		vm.wait(2)
	end
	if helper_38a7fa45() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetFlag(744, 1)
		event.MapJump_3(-1, "s44", 550)
		vm.wait(4)
	end
	if helper_2b32f1e8() ~= 0 then
		event.SetMotion(0, "立ち")
		event.SetFadeOut(30)
		helper_25abe6d2(30)
		event.SetFlag(748, 1)
		event.MapJump_3(-1, "s44", 560)
		vm.wait(6)
	end
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 500, which map data, a script or the engine runs by number.
function script.event_500()
	helper_cbfc194e()
	event.SetSavedataEtc(0, 9)
	event.LoadSound(7000)
	helper_9dafbc83(0.0, 0.0, -1000.0, vm.f32(3.14))
	event.SetCameraRef(0.0, 30.0, -1000.0)
	event.SetCameraPos(0.0, 50.0, -880.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Event 550, which map data, a script or the engine runs by number.
function script.event_550()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
end

--- Event 560, which map data, a script or the engine runs by number.
function script.event_560()
	helper_9dafbc83(0.0, 0.0, -1100.0, 0.0)
	event.SetCameraRef(0.0, 30.0, -1100.0)
	event.SetCameraPos(0.0, 50.0, -1220.0)
	event.ResetCamera(0)
	event.SetFadeIn(30)
	helper_25abe6d2(30)
	event.AddItem(198, 1)
	event.AddItem(199, 1)
	helper_e8257c69(198, 1)
	helper_e8257c69(199, 1)
	helper_a87eb945(1)
end

return script
