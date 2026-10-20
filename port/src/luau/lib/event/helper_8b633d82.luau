--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_41ce3e45 = require("@lib/event/helper_41ce3e45")
local helper_51e27364 = require("@lib/event/helper_51e27364")
local helper_cd1be78a = require("@lib/event/helper_cd1be78a")
local helper_fa91c9af = require("@lib/event/helper_fa91c9af")

--- Helper function.
local function helper_8b633d82(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_51e27364(arg0, arg1)
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
		helper_51e27364(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_cd1be78a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_fa91c9af(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_41ce3e45(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_8b633d82
