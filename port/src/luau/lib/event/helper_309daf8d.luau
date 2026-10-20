--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_484d38e3 = require("@lib/event/helper_484d38e3")
local helper_716d808c = require("@lib/event/helper_716d808c")
local helper_b50b76fc = require("@lib/event/helper_b50b76fc")
local helper_f5fe1344 = require("@lib/event/helper_f5fe1344")

--- Helper function.
local function helper_309daf8d(arg0: s32, arg1: s32)
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
		helper_f5fe1344(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_716d808c(arg0, arg1)
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

return helper_309daf8d
