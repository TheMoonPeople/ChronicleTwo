--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_4a05197b(arg0: s32, arg1: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_47171f2d(arg0, -1, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"...<page>Ah! Hello!\nI've been a bit deaf lately.<page>I can't make out what you're\nsaying unless you speak slowly."
	)
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_4a05197b
