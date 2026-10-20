--!strict
-- Shared event helper used by 27 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_e2203e72 = require("@lib/event/helper_e2203e72")

--- Helper function.
local function helper_3a204093(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_e2203e72(15)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeOut(15)
	helper_e2203e72(15)
	if vm.skipping() then
		return skip(2)
	end
	event.GotoMenu(6, arg0)
	if vm.wait() then
		return skip(3)
	end
	event.SetFadeIn(15)
end

return helper_3a204093
