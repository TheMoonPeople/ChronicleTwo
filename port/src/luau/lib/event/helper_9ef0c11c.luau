--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_35329934 = require("@lib/event/helper_35329934")

--- Helper function.
local function helper_9ef0c11c()
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_35329934()
	flag = event.GetFlag(18) or flag
	if flag == 1 then
		flag = event.GetFlag(17) or flag
		if flag == 0 then
			event.SetFlag(17, 1)
		end
	end
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.SetFadeIn(30)
	event.GotoOutside(-1, "m01")
end

return helper_9ef0c11c
