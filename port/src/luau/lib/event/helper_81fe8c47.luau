--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_336066bf = require("@lib/event/helper_336066bf")
local helper_61156711 = require("@lib/event/helper_61156711")
local helper_824b95e3 = require("@lib/event/helper_824b95e3")
local helper_c631b2e2 = require("@lib/event/helper_c631b2e2")

--- Helper function.
local function helper_81fe8c47(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c631b2e2(arg0, arg1)
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
		helper_c631b2e2(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_824b95e3(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_336066bf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_61156711(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_81fe8c47
