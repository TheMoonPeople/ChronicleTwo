--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_fb70dad4 = require("@lib/event/helper_fb70dad4")
local helper_fdffeda5 = require("@lib/event/helper_fdffeda5")

--- Helper function.
local function helper_17c523b0()
	local language_code: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_fb70dad4(1, 7)
		helper_fdffeda5(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_fb70dad4(1, 7)
	event.SetMesPreset(1, 2)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.MesMake_2(1, "(O)でストップ")
	else
		event.MesMake_2(1, "It stops with (O) button.")
	end
	helper_fdffeda5(1, -1, 15, 0, 0)
end

return helper_17c523b0
