--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_b43e6f3f(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"Since you came along, I've\nhardly seen Max at all.\nI don't know what you're up to,<page>but I hope you're not using him."
	)
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_b43e6f3f
