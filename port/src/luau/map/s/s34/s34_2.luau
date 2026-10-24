--!strict
-- map/s/s34/s34_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_17957835 = require("@lib/event/helper_17957835")
local helper_1cbe46f3 = require("@lib/event/helper_1cbe46f3")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_201eec5c = require("@lib/event/helper_201eec5c")
local helper_235ae843 = require("@lib/event/helper_235ae843")
local helper_35e14f02 = require("@lib/event/helper_35e14f02")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_9b12ab0c = require("@lib/event/helper_9b12ab0c")
local helper_9dafbc83 = require("@lib/event/helper_9dafbc83")
local helper_9f88d853 = require("@lib/event/helper_9f88d853")
local helper_c99744f1 = require("@lib/event/helper_c99744f1")
local helper_d7295df9 = require("@lib/event/helper_d7295df9")
local helper_f4ec8310 = require("@lib/event/helper_f4ec8310")
local helper_f57795f8 = require("@lib/event/helper_f57795f8")
local helper_fdad3d3b = require("@lib/event/helper_fdad3d3b")

--- Event 99, which map data, a script or the engine runs by number.
local function event_99()
	print("map_init-------------------------\n")
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script.event_99 = event_99

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local at: number = 0
	return vm.guard(function()
		event.Initialize()
		event_99()
		print("start_event--------------------------------------------\n")
		mc_load = event.CheckMcLoad() or mc_load
		if mc_load == 1 then
			helper_35e14f02()
			helper_9dafbc83(vm.f32(94.2), vm.f32(140.4), vm.f32(2842.4), 0.0)
			event.ResetCamera(1, 0.0, 20.0)
			event.SetFadeIn(30)
		else
			old_map_no = event.GetOldMapNo() or old_map_no
			var2 = event.GetMapType(old_map_no) or var2
			if var2 ~= -1 then
				if old_map_no == 4 or old_map_no == 109 then
					helper_35e14f02()
					helper_9dafbc83(0.0, vm.f32(189.2), 2630.0, 0.0)
					event.ResetCamera(1, 3.14, 20.0)
					event.SetFadeIn(30)
				else
					var3 = event.GetCnt(1) or var3
					if
						(old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108)
						and var3 == 9
					then
						helper_35e14f02()
						at = 1
						helper_201eec5c()
						helper_946c0402()
						event.SetFadeIn(15)
						event.ResetCamera(1, 0.0)
					else
						at = 2
						helper_235ae843()
						helper_35e14f02()
					end
				end
			end
			event.SetMotion(0, "立ち")
		end
		return
	end, function(received: { any })
		if at <= 2 then
			if at == 1 then
			end
			if at <= 1 then
				helper_d7295df9()
				helper_17957835()
			end
			helper_1ef0d4b2()
			return 0
		end
		return nil
	end)
end

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_235ae843

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	if helper_9f88d853() ~= 0 then
		event.MapJump_2(-1, "g05")
	end
end

--- Event 250, which map data, a script or the engine runs by number.
function script.event_250()
	local var0: s32 = 0
	local var1: s32 = 0
	local at: number = 0
	return vm.guard(function()
		at = 1
		var0 = helper_1cbe46f3()
		if var0 ~= 1 then
			return
		end
		event.SetCnt(1, 9)
		var1 = event.GetEventData_2(3) or var1
		if var1 <= 1 then
			at = 2
			helper_f4ec8310()
			event.StopBgm(0)
			at = 3
			vm.wait(3)
			event.MapJump_2(-1, "s37")
			at = 4
			vm.wait(4)
		else
			at = 5
			helper_fdad3d3b()
			event.StopBgm(0)
			event.MapJump_2(100, "s38")
		end
		return
	end, function(received: { any })
		if at <= 1 then
			if at == 1 then
				var0 = received[1] :: number
			end
			return 0
		end
		if at <= 5 then
			if at == 5 then
			end
			if at <= 4 then
				helper_c99744f1()
			end
			return 0
		end
		return nil
	end)
end

--- Event 400, which map data, a script or the engine runs by number.
script.event_400 = helper_f57795f8

--- Event 1000, which map data, a script or the engine runs by number.
function script.event_1000()
	local var0: s32 = 0
	var0 = event.GetEventData_2(13) or var0
	if var0 == 8 then
		helper_9b12ab0c()
	end
end

return script
