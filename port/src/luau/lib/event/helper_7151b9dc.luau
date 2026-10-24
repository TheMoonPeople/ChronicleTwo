--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4def91a5 = require("@lib/event/helper_4def91a5")
local helper_856dbe85 = require("@lib/event/helper_856dbe85")

--- Helper function.
local function helper_7151b9dc(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4def91a5(1)
		end
		if at <= 2 then
			helper_856dbe85(0, arg1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.StreamOpen3(1, arg0)
	helper_4def91a5(1)
	if vm.skipping() then
		return skip(2)
	end
	event.StreamPlay(1)
	helper_856dbe85(0, arg1)
	if vm.skipping() then
		return skip(3)
	end
	event.StreamClose(1)
end

return helper_7151b9dc
