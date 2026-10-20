--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_3f0dde4d()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	event.CharaActive(1, 0)
	event.SetCharaPos(0, -687.4, 0.0, -77.8)
	event.SetCharaRot(0, 0.0, 1.62, 0.0)
	event.DeleteChara(34)
	event.DeleteChara(36)
	event.DeleteChara(35)
	event.EohSetShow(6, 1)
	event.EohSetShow(7, 1)
	event.EohSetShow(8, 1)
	event.EohSetShow(9, 1)
	event.EohSetShow(10, 1)
	event.CharaActive(1, 8)
	event.CharaActive(1, 9)
	event.CharaActive(1, 10)
end

return helper_3f0dde4d
