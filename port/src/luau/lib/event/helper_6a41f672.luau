--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30c30f62 = require("@lib/event/helper_30c30f62")

--- Helper function.
local function helper_6a41f672(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Mi hai dato la foto della luna.\nSei un bravo Umano.")
	else
		event.MesMake_2(
			0,
			"Se la Ferrovia Carbonero viagger[UNI00e0]\nper tutto il mondo, potremo\nvisitare un sacco di bei posti."
		)
	end
	helper_30c30f62(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_6a41f672
