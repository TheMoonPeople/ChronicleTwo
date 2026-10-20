--!strict
-- Shared monster helper used by 18 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_b9fff8e1 = require("@lib/monster/helper_b9fff8e1")

--- Helper function.
local function helper_4a39d2ab(arg0: f32, arg1: f32)
	local var2: f32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	if arg1 == -1.0 then
		arg1 = vm.f32(0.03)
	end
	var3 = 0
	while true do
		helper_b9fff8e1()
		var2 = monster.NowMosWait() or var2
		if var2 < vm.f32(arg0 + arg1) and var2 > vm.f32(arg0 - arg1) then
			break
		else
			var4 = monster.CheckMosEnd() or var4
			if var4 ~= 0 then
				break
			else
				var3 = vm.i32(var3 + 1)
			end
		end
	end
end

return helper_4a39d2ab
