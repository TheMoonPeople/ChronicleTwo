--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4d26fac7 = require("@lib/event/helper_4d26fac7")
local helper_5360dede = require("@lib/event/helper_5360dede")
local helper_57f02332 = require("@lib/event/helper_57f02332")
local helper_e0a7e89a = require("@lib/event/helper_e0a7e89a")

--- Helper function.
local function helper_f3544964(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5360dede(arg0, arg1)
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
		helper_5360dede(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_e0a7e89a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_57f02332(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_4d26fac7(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_f3544964
