--!strict
--- Camera helpers for monster scripts.


local camera = {}

--- Resets the camera mode and camera limits.
function camera.reset_mode()
	monster.set_camera_mode(0)
	monster.reset_camera_limits()
end

return camera
