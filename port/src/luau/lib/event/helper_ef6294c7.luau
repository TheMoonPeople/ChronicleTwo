--!strict
-- Shared event helper used by 219 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5ac4b36d = require("@lib/event/helper_5ac4b36d")
local helper_6992f518 = require("@lib/event/helper_6992f518")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_ef6294c7(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			vm.wait(1)
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			vm.wait(2)
		end
	end
	helper_82705ce2(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_5ac4b36d(0)
	helper_6992f518(0)
	event.StreamClose(1)
end

return helper_ef6294c7
