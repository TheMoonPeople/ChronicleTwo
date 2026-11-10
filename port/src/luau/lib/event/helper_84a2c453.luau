--!strict
-- Shared event helper used by 5 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_038a2e4d = require("@lib/event/helper_038a2e4d")

--- Helper function.
local function helper_84a2c453(arg0: s32)
	local var1: f32 = 0
	local var2: f32 = 0
	local var3: f32 = 0
	local var11: s32 = 0
	print("train_id=", var11, "----------------\n")
	print("fpos[0]=", vm.float(var1), "---------------\n")
	print("fpos[1]=", vm.float(var2), "---------------\n")
	print("fpos[2]=", vm.float(var3), "---------------\n")
	print("train_id=", var11, "---------------\n")
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(18)
	helper_038a2e4d(12)
	helper_038a2e4d(30)
	helper_038a2e4d(10)
	helper_038a2e4d(20)
	helper_038a2e4d(18)
	helper_038a2e4d(12)
	helper_038a2e4d(30)
end

return helper_84a2c453
