--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_86c454a8 = require("@lib/event/helper_86c454a8")
local helper_a5edb217 = require("@lib/event/helper_a5edb217")

--- Helper function.
local function helper_77ecb18e(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_a5edb217(1)
		end
		if at <= 2 then
			helper_86c454a8(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_a5edb217(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_86c454a8(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_77ecb18e
