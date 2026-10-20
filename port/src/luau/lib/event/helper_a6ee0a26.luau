--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_47171f2d = require("@lib/event/helper_47171f2d")

--- Helper function.
local function helper_a6ee0a26(arg0: s32, arg1: any)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		event.MesMake_2(0, "N'h[UNI00e9]site pas [UNI00e0] utiliser mes\nnouveaux pouvoirs quand tu le\nvoudras.")
	else
		event.MesMake_2(
			0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	helper_47171f2d(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

return helper_a6ee0a26
