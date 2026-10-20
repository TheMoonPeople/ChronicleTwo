--!strict
-- Shared monster helper used by 102 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_27f80314()
	local piyori_mark: s32 = 0
	monster.SetPiyoriMark()
	piyori_mark = monster.CheckPiyori() or piyori_mark
	while piyori_mark > 0 do
		piyori_mark = monster.CheckPiyori() or piyori_mark
		vm.wait()
	end
end

return helper_27f80314
