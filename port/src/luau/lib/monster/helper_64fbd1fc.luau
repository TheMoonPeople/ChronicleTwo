--!strict
-- Shared monster helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_787df986 = require("@lib/monster/helper_787df986")
local helper_79d6eaca = require("@lib/monster/helper_79d6eaca")
local helper_8971d3b6 = require("@lib/monster/helper_8971d3b6")

--- Helper function.
local function helper_64fbd1fc(arg0: f32, arg1: f32, arg2: f32)
	local var3: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	arg0 = helper_787df986(arg0)
	if arg0 > vm.f32(3.1415927) then
		arg0 = vm.f32(arg0 - vm.f32(6.2831855))
	end
	if arg0 <= vm.f32(-3.1415927) then
		arg0 = vm.f32(arg0 + vm.f32(6.2831855))
	end
	arg1 = helper_787df986(arg1)
	var8 = arg2
	var7 = 0.0
	while var7 < var8 do
		monster.call_command(67, var3, var4, var5) -- retail: command 67 is not registered
		if var4 > vm.f32(arg0 - arg1) and var4 < vm.f32(arg0 + arg1) then
			helper_79d6eaca()
			break
		elseif helper_8971d3b6(arg0, var4, arg1) == 0 then
			helper_79d6eaca()
			break
		elseif var7 >= arg2 then
			helper_79d6eaca()
			break
		else
			vm.wait()
			var7 = vm.f32(var7 + 1.0)
		end
	end
	helper_79d6eaca()
	return var7
end

return helper_64fbd1fc
