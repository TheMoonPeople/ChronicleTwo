--!strict
-- Shared event helper used by 40 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27ff0b8f = require("@lib/event/helper_27ff0b8f")
local helper_dd7a6f53 = require("@lib/event/helper_dd7a6f53")
local helper_f37e8af2 = require("@lib/event/helper_f37e8af2")

--- Helper function.
local function helper_1f9a3afd(arg0: s32, arg1: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_27ff0b8f(0, -1, 8, 0, 0)
			helper_f37e8af2(0, arg1)
		end
		helper_dd7a6f53(0)
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	while true do
		stream_open_state = event.StreamOpenCheck() or stream_open_state
		if stream_open_state == 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
	event.StreamStandby(1)
	while true do
		stream_open_state_2 = event.StreamOpenCheck() or stream_open_state_2
		if stream_open_state_2 == 0 then
			break
		else
			if vm.wait() then
				return skip(3)
			end
		end
	end
	event.MesMake_2(0, arg0)
	helper_27ff0b8f(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_f37e8af2(0, arg1)
	if vm.skipping() then
		return skip(4)
	end
	helper_dd7a6f53(0)
	event.StreamClose(1)
	event.SetMesPos(0, 0)
end

return helper_1f9a3afd
