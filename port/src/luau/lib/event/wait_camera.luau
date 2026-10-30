--!strict
-- Shared event helper used by 603 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Waits until the camera sequence has run its commands.
local function wait_camera()
	local var0: s32 = 0
	while true do
		var0 = event.is_camera_sequence_running() or var0
		if var0 == 0 then
			break
		else
			vm.wait(1)
		end
	end
end

return wait_camera
