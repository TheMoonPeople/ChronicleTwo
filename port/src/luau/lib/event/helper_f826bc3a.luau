--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_52c7aaa9 = require("@lib/event/helper_52c7aaa9")
local helper_95c04986 = require("@lib/event/helper_95c04986")

--- Helper function.
local function helper_f826bc3a(arg0: any, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_52c7aaa9(1)
		end
		if at <= 2 then
			helper_95c04986(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_52c7aaa9(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_95c04986(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_f826bc3a
