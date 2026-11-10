--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8e5b8087(arg0: s32, arg1: f32, arg2: f32, arg3: s32)
	local get_now_frame_wait: f32 = 0
	if arg2 == -1.0 then
		arg2 = vm.f32(0.01)
	end
	for var4 = 0, arg3 - 1 do
		get_now_frame_wait = event.get_character_motion_wait(arg0) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(arg1 + arg2) and get_now_frame_wait > vm.f32(arg1 - arg2) then
			return
		end
		vm.wait(1)
	end
end

return helper_8e5b8087
