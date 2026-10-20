--!strict
-- Shared action helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bac4ec65 = require("@lib/action/helper_bac4ec65")

--- Helper function.
local function helper_eb0c92cb()
	local var0: s32 = 0
	local prog: s32 = 0
	local var3: f32 = 0
	prog = action.ProgGet() or prog
	if prog == 200 then
		action.SetMos("中距離攻撃", -1, 6)
		action.ProgSet(prog + 1)
	end
	if prog == 201 then
		var3 = action.NowMosWait() or var3
		if var3 > vm.f32(0.3) and var3 < vm.f32(0.4) then
			action.SetBlowMove(6.0, 0.0, 12)
		end
		var0 = action.GetMosStatus() or var0
		if var0 == 4 then
			action.ProgSet(0)
			helper_bac4ec65(6)
		end
		return
	end
end

return helper_eb0c92cb
