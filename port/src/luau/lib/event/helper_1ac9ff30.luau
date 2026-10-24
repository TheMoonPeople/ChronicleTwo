--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0bf1ae31 = require("@lib/event/helper_0bf1ae31")
local helper_7d091696 = require("@lib/event/helper_7d091696")
local helper_acfd40a3 = require("@lib/event/helper_acfd40a3")
local helper_b240a72c = require("@lib/event/helper_b240a72c")

--- Helper function.
local function helper_1ac9ff30(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_acfd40a3(arg0, arg1)
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
	flag = event.GetFlag(424) or flag
	if var2 ~= 2 or flag == 0 then
		helper_acfd40a3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 16) or var2
	if var2 == 0 then
		helper_0bf1ae31(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_b240a72c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_7d091696(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_1ac9ff30
