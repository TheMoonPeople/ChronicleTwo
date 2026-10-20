--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_82987b29 = require("@lib/event/helper_82987b29")
local helper_96722e48 = require("@lib/event/helper_96722e48")
local helper_aed4d88b = require("@lib/event/helper_aed4d88b")
local helper_c18b9b50 = require("@lib/event/helper_c18b9b50")

--- Helper function.
local function helper_42113073(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_aed4d88b(arg0, arg1)
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
		helper_aed4d88b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_c18b9b50(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_82987b29(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_96722e48(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_42113073
