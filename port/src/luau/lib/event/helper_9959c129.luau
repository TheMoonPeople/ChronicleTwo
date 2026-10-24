--!strict
-- Shared event helper used by 6 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_9959c129()
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -687.4, 0.0, -77.8)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.Finish()
	vm.wait(1)
end

return helper_9959c129
