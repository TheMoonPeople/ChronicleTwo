--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local helper_d22e028d = require("@lib/event/helper_d22e028d")

--- Helper function.
local function helper_0d50eeb4()
	local flag: s32 = 0
	event.StopBgm(0)
	flag = event.GetFlag(24) or flag
	if flag ~= 0 then
		event.FuncPointShow("", "e255", 0)
		helper_d22e028d(2)
		flag = event.GetFlag(260) or flag
		if flag ~= 0 then
			event.FuncPointShow("", "e256", 0)
			helper_d22e028d(1)
		else
			event.FuncPointShow("", "e256", 1)
		end
	else
		event.FuncPointShow("", "e255", 1)
		event.FuncPointShow("", "e256", 0)
		flag = event.GetFlag(23) or flag
		if flag ~= 0 then
			helper_d22e028d(0)
		else
			helper_d22e028d(3)
		end
	end
end

return helper_0d50eeb4
