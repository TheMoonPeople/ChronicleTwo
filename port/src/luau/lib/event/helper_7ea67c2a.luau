--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local helper_c624bc16 = require("@lib/event/helper_c624bc16")
local helper_e34416e2 = require("@lib/event/helper_e34416e2")

--- Helper function.
local function helper_7ea67c2a(arg0: any)
	event.CmrsSetPos(-0.73, 30.22, -58.88)
	event.CmrsSetRef(0.18, 32.06, -95.16)
	event.SetCharaPos(34, 0.22, 5.19, -94.18)
	event.SetCharaRot(34, 0.0, 0.0, 0.0)
	event.CmrsMove2(-0.4, 30.22, -71.81, 0.18, 32.06, -95.16, 100, 0, 0.4)
	event.SetPakuAnim(2, "通常口パク")
	helper_e34416e2(1090080)
	event.ResetPakuAnim()
	helper_c624bc16()
end

return helper_7ea67c2a
