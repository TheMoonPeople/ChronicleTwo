--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_f616ba9e(arg0: s32)
	local stream_open_state: s32 = 0
	local var2: s32 = 0
	local at: number = 0
	return vm.guard(function()
		var2 = 0
		while true do
			at = 1
			vm.wait(1)
			var2 = vm.i32(var2 + 1)
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				break
			end
		end
		event.StreamStandby(arg0)
		while true do
			at = 2
			vm.wait(2)
			var2 = vm.i32(var2 + 1)
			stream_open_state = event.StreamOpenCheck() or stream_open_state
			if stream_open_state == 0 then
				break
			end
		end
		return var2
	end, function(received: { any })
		if at <= 2 then
			if at <= 1 then
				var2 = var2 + 1
			end
			var2 = var2 + 1
			return var2
		end
		return nil
	end)
end

return helper_f616ba9e
