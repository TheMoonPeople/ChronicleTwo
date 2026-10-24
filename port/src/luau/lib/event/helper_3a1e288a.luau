--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local helper_25abe6d2 = require("@lib/event/helper_25abe6d2")
local helper_3300e99f = require("@lib/event/helper_3300e99f")

--- Helper function.
local function helper_3a1e288a(arg0: f32, arg1: s32)
	local var2: s32 = 0
	helper_3300e99f(arg0)
	event.SetMotion(0, "立ち")
	var2 = event.GetSndId(2) or var2
	if arg1 ~= 0 then
		event.SndSePlay(var2, 92)
	else
		event.SndSePlay(var2, 94)
	end
	event.SetFadeOut(30)
	helper_25abe6d2(30)
end

return helper_3a1e288a
