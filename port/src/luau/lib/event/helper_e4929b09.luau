--!strict
-- Shared event helper used by 4 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_f1049565 = require("@lib/event/helper_f1049565")

--- Helper function.
local function helper_e4929b09(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "Ich k[UNI00f6]nnte dir nie\netwas abschlagen.")
	else
		event.MesMake_2(0, "Ich werde der beste Koch\nder Welt, und wenn's soweit ist,\nisst du immer gratis bei mir.")
	end
	helper_f1049565(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_e4929b09
