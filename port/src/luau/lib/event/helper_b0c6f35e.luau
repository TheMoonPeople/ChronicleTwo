--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_30b29df0 = require("@lib/event/helper_30b29df0")
local helper_670d8954 = require("@lib/event/helper_670d8954")
local helper_ebf39946 = require("@lib/event/helper_ebf39946")
local helper_f055c788 = require("@lib/event/helper_f055c788")

--- Helper function.
local function helper_b0c6f35e(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_ebf39946(arg0, arg1, 0)
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
		helper_ebf39946(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_30b29df0(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_670d8954(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_f055c788(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_b0c6f35e
