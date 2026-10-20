--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_af1dcd9e()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -687.4, 0.0, -77.8)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
	event.ObjsSetPos(4, 0.0, 0.0, 0.0)
	event.DeleteChara(40)
	event.DeleteChara(41)
	event.DeleteChara(42)
	event.Finish()
	if vm.wait() then
		return skip(2)
	end
end

return helper_af1dcd9e
