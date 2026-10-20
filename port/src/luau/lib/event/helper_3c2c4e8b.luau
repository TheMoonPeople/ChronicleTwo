--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_bef6d9ba = require("@lib/event/helper_bef6d9ba")
local helper_dc3ddb2c = require("@lib/event/helper_dc3ddb2c")
local helper_de476315 = require("@lib/event/helper_de476315")
local helper_f4df25a7 = require("@lib/event/helper_f4df25a7")

--- Helper function.
local function helper_3c2c4e8b(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dc3ddb2c(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_dc3ddb2c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 15) or var2
	if var2 == 0 then
		helper_f4df25a7(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_bef6d9ba(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_de476315(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_3c2c4e8b
