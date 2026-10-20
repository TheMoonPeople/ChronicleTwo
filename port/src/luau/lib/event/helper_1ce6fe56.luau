--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_1ce6fe56(arg0: s32)
	local stream_open_state: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var2 = 0
		end
		if at <= 2 then
			var2 = vm.i32(var2 + 1)
		end
		var2 = vm.i32(var2 + 1)
		return var2
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = 0
	while true do
		if vm.wait() then
			return skip(2)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		if vm.wait() then
			return skip(3)
		end
		var2 = vm.i32(var2 + 1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	return var2
end

return helper_1ce6fe56
