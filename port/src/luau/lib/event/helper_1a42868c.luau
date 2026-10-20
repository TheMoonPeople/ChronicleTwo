--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5eb0d96a = require("@lib/event/helper_5eb0d96a")
local helper_78fd9b9f = require("@lib/event/helper_78fd9b9f")
local helper_df965a3c = require("@lib/event/helper_df965a3c")
local helper_ecfd482c = require("@lib/event/helper_ecfd482c")

--- Helper function.
local function helper_1a42868c(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_ecfd482c(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 2) or var2
	if var2 == 0 then
		helper_df965a3c(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var2 == 1 then
		helper_5eb0d96a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 2 then
		helper_78fd9b9f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_1a42868c
