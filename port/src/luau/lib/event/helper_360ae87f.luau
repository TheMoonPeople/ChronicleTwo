--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_034dffd5 = require("@lib/event/helper_034dffd5")
local helper_0e703742 = require("@lib/event/helper_0e703742")
local helper_9d6a191b = require("@lib/event/helper_9d6a191b")
local helper_aa400fd7 = require("@lib/event/helper_aa400fd7")

--- Helper function.
local function helper_360ae87f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_0e703742(arg0, arg1)
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
		helper_0e703742(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_9d6a191b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_034dffd5(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_aa400fd7(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_360ae87f
