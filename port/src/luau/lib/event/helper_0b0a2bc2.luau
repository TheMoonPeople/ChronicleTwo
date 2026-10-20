--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_484d38e3 = require("@lib/event/helper_484d38e3")
local helper_b50b76fc = require("@lib/event/helper_b50b76fc")
local helper_df16c38e = require("@lib/event/helper_df16c38e")
local helper_e6774a8e = require("@lib/event/helper_e6774a8e")

--- Helper function.
local function helper_0b0a2bc2(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_484d38e3(arg0, arg1)
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
		helper_484d38e3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_df16c38e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_e6774a8e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_b50b76fc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_0b0a2bc2
