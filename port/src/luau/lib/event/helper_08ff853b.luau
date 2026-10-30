--!strict
-- Shared event helper used by 573 scripts, translated by tools/luau/stb2luau.

--- Helper function.
local function helper_08ff853b(arg0: s32)
	local var1: s32 = 0
	local get_lxf: f32 = 0
	local get_lyf: f32 = 0
	var1 = event.get_message_window_frame(arg0) or var1
	do
		local out1, out2, _, _ = event.get_analog_sticks_4()
		get_lxf = out1 or get_lxf
		get_lyf = out2 or get_lyf
	end
	if var1 == 5 then
		if get_lxf < -0.5 then
			return -1
		end
		if 0.5 < get_lxf then
			return 1
		end
	else
		if get_lyf < -0.5 then
			return -1
		end
		if 0.5 < get_lyf then
			return 1
		end
	end
	return 0
end

return helper_08ff853b
