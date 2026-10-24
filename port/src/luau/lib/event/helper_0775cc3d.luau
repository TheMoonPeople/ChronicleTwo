--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_e31fb26a = require("@lib/event/helper_e31fb26a")

--- Helper function.
local function helper_0775cc3d()
	local flag: s32 = 0
	event.StopBgm(0)
	flag = event.GetFlag(24) or flag
	if flag ~= 0 then
		event.FuncPointShow("", "e255", 0)
		helper_e31fb26a(2)
		flag = event.GetFlag(260) or flag
		if flag ~= 0 then
			event.FuncPointShow("", "e256", 0)
			helper_e31fb26a(1)
		else
			event.FuncPointShow("", "e256", 1)
		end
	else
		event.FuncPointShow("", "e255", 1)
		event.FuncPointShow("", "e256", 0)
		flag = event.GetFlag(23) or flag
		if flag ~= 0 then
			helper_e31fb26a(0)
		else
			helper_e31fb26a(3)
		end
	end
end

return helper_0775cc3d
