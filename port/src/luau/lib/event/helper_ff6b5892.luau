--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local helper_125385ee = require("@lib/event/helper_125385ee")
local helper_82705ce2 = require("@lib/event/helper_82705ce2")

--- Helper function.
local function helper_ff6b5892()
	local language_code: s32 = 0
	helper_125385ee(1, 7)
	event.SetMesPreset(1, 2)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.MesMake_2(1, "(O)でストップ")
	else
		event.MesMake_2(1, "It stops with (O) button.")
	end
	helper_82705ce2(1, -1, 15, 0, 0)
end

return helper_ff6b5892
