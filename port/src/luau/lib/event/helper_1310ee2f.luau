--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_971ac40c = require("@lib/event/helper_971ac40c")
local helper_9e457fe2 = require("@lib/event/helper_9e457fe2")

--- Helper function.
local function helper_1310ee2f()
	local language_code: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		helper_9e457fe2(1, 7)
		helper_971ac40c(1, -1, 15, 0, 0)
	end
	if vm.skipping() then
		return skip(1)
	end
	helper_9e457fe2(1, 7)
	event.SetMesPreset(1, 2)
	language_code = event.GetLanguage() or language_code
	if language_code == 0 then
		event.MesMake_2(1, "(O)でストップ")
	else
		event.MesMake_2(1, "It stops with (O) button.")
	end
	helper_971ac40c(1, -1, 15, 0, 0)
end

return helper_1310ee2f
