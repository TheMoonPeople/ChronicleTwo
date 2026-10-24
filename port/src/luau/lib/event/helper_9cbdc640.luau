--!strict
-- Shared event helper used by 118 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9cbdc640(arg0: s32)
	local stream_open_state: s32 = 0
	while true do
		vm.wait(1)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
	event.StreamStandby(arg0)
	while true do
		vm.wait(2)
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		end
	end
end

return helper_9cbdc640
