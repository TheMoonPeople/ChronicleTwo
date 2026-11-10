--!strict
-- test.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_888ab2a3 = require("@lib/event/helper_888ab2a3")
local interpolate = require("@lib/event/interpolate")

--- Helper function.
local function helper_2484(arg0: s32, arg1: s32)
	event.call_command(800, 0, arg0, arg1) -- retail: command 800 is not registered
	event.open_message_window_2(0, arg1)
	vm.wait(1)
end

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Event 0, which map data, a script or the engine runs by number.
function script.event_0()
	helper_2484(2, 0)
end

--- Event 1, which map data, a script or the engine runs by number.
function script.event_1()
	helper_2484(3, 1)
end

--- Event 2, which map data, a script or the engine runs by number.
function script.event_2()
	helper_2484(4, 2)
end

--- Event 3, which map data, a script or the engine runs by number.
function script.event_3()
	helper_2484(5, 3)
end

--- Event 4, which map data, a script or the engine runs by number.
function script.event_4()
	helper_2484(6, 4)
end

--- Event 5, which map data, a script or the engine runs by number.
function script.event_5()
	helper_2484(7, 5)
end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
function script.default_event()
	local var0: f32 = 0
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var6: f32 = 0
	local var7: f32 = 0
	local pos_x: f32 = 0
	local pos_z: f32 = 0
	event.initialize_event()
	vm.wait(1)
	var0 = 0.0
	var1 = 300.0
	while var0 <= var1 do
		event.set_camera_position(168.64, 58.93, -170.8)
		event.set_camera_look_at(134.38, 0.0, 16.4)
		var0 = vm.f32(var0 + 1.0)
		vm.wait(2)
	end
	event.asq_initialize(0)
	event.asq_sync_character(0, 3)
	event.asq_set_position(0, 203.3, 0, -51.0)
	event.asq_set_rotation(0, 0.0)
	event.asq_motion_play(0, "歩き")
	event.asq_motion_trigger(0)
	event.asq_rotate_toward_position(0, 71.9, 0, 58.4, 0.1)
	event.asq_move(0, 71.9, 0, 58.4, 100)
	event.asq_motion_play(0, "立ち")
	event.asq_motion_trigger(0)
	var2 = vm.f32(203.3)
	var5 = vm.f32(71.9)
	var3 = vm.f32(97.4)
	var6 = vm.f32(146.2)
	var4 = -51.0
	var7 = vm.f32(58.4)
	var0 = 0.0
	var1 = 300.0
	while var0 <= var1 do
		pos_x = interpolate(var2, var5, var0, var1)
		local _ = interpolate(var3, var6, var0, var1)
		pos_z = interpolate(var4, var7, var0, var1)
		event.set_camera_look_at(pos_x, 0, pos_z)
		var0 = vm.f32(var0 + 1.0)
		vm.wait(3)
	end
end

--- Event 200, which map data, a script or the engine runs by number.
function script.event_200()
	helper_888ab2a3(10)
	event.go_to_interior_map(-1, "i01h01", 123)
end

--- Event 201, which map data, a script or the engine runs by number.
function script.event_201()
	helper_888ab2a3(10)
	event.go_to_interior_map(-1, "i02h01", 123)
end

return script
