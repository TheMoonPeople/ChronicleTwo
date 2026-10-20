--!strict
-- Shared monster helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_442b9962 = require("@lib/monster/helper_442b9962")
local helper_461f64ff = require("@lib/monster/helper_461f64ff")
local helper_787df986 = require("@lib/monster/helper_787df986")

--- Helper function.
local function helper_9944827a(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	if arg2 == -1.0 then
		arg2 = vm.f32(0.05)
	end
	var5 = helper_787df986(arg0)
	if var5 > vm.f32(3.1415927) then
		var5 = vm.f32(var5 - vm.f32(6.2831855))
	end
	if var5 <= vm.f32(-3.1415927) then
		var5 = vm.f32(var5 + vm.f32(6.2831855))
	end
	while true do
		var3 = monster.GetTargetAngle() or var3
		monster.SetNextRot(var3, var5)
		var4 = monster.NowMosWait() or var4
		if var4 < vm.f32(arg1 + arg2) and var4 > vm.f32(arg1 - arg2) then
			break
		else
			helper_461f64ff()
		end
	end
	helper_442b9962()
end

return helper_9944827a
