--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_38448da1 = require("@lib/event/helper_38448da1")
local helper_57cb224f = require("@lib/event/helper_57cb224f")
local helper_e304888c = require("@lib/event/helper_e304888c")

--- Helper function.
local function helper_be531301(arg0: s32)
	local stream_open_state: s32 = 0
	local stream_open_state_2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			helper_e304888c(0, -1, 8, 0, 0)
			helper_57cb224f(0)
		end
		helper_38448da1(0)
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
	helper_e304888c(0, -1, 8, 0, 0)
	event.StreamPlay(1)
	helper_57cb224f(0)
	if vm.skipping() then
		return skip(4)
	end
	helper_38448da1(0)
	event.StreamClose(1)
end

return helper_be531301
