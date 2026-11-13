--!strict
--- Waits on and controls the event camera.

local vm = require("@lib/vm")

local camera = {}

--- Puts the camera behind the player relative to a facing angle and enables camera control.
function camera.place_behind_player(facing_angle: f32)
	local x: f32 = 0
	local y: f32 = 0
	local z: f32 = 0
	event.set_camera_control_enabled(0)
	do
		local out1, out2, out3 = event.get_character_position(0)
		x = out1 or x
		y = out2 or y
		z = out3 or z
	end
	y = vm.f32(y + 25.0)
	event.set_camera_look_at(x, y, z)
	facing_angle = vm.f32(facing_angle - vm.f32(3.1415927))
	facing_angle = event.wrap_angle(facing_angle) or facing_angle
	x = vm.f32(vm.f32(vm.sin(facing_angle) * 100.0) + x)
	y = vm.f32(y + 0.0)
	z = vm.f32(vm.f32(vm.cos(facing_angle) * 100.0) + z)
	event.set_camera_position(x, y, z)
	event.set_camera_control_enabled(1)
	event.set_camera_control_range(10.0, 40.0, 60.0, 160.0)
end

--- Waits until the camera sequence has run its commands.
function camera.wait_until_done()
	local running: s32 = 0
	while true do
		running = event.is_camera_sequence_running() or running
		if running == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return camera
