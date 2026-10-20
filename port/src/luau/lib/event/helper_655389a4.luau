--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_655389a4(arg0: s32)
	local count: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		count = count - 1
	end
	if vm.skipping() then
		return skip(1)
	end
	count = event.SphidaGetParCount() or count
	count = vm.i32(count - 1)
	event.SphidaSetParCount(count)
	if count <= 0 then
		event.DeleteChara(8)
		event.DeleteChara(9)
		event.DeleteChara(10)
		event.DeleteChara(11)
		event.SphidaSetPlayFlag(0)
		if arg0 ~= -1 then
			event.SndSePlay(arg0, 19)
		end
	end
end

return helper_655389a4
