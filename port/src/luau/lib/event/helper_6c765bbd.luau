--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_6c765bbd(arg0: s32, arg1: f32, arg2: f32, arg3: any)
	local var4: s32 = 0
	local get_now_frame_wait: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg2 = vm.f32(0.01)
			arg3 = arg3
			var4 = 0
			return
		end
		var4 = vm.i32(var4 + 1)
	end
	if vm.skipping() then
		return skip(1)
	end
	if arg2 == -1.0 then
		arg2 = vm.f32(0.01)
	end
	if arg3 > 0 then
		arg3 = arg3
	end
	var4 = 0
	while var4 < arg3 do
		get_now_frame_wait = event.GetMotNowWait(arg0) or get_now_frame_wait
		if get_now_frame_wait < vm.f32(arg1 + arg2) and get_now_frame_wait > vm.f32(arg1 - arg2) then
			return
		end
		if vm.wait() then
			return skip(2)
		end
		var4 = vm.i32(var4 + 1)
	end
end

return helper_6c765bbd
