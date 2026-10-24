--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2daaf54b = require("@lib/event/helper_2daaf54b")
local helper_37ae00bc = require("@lib/event/helper_37ae00bc")
local helper_57fafea1 = require("@lib/event/helper_57fafea1")
local helper_71d76b5d = require("@lib/event/helper_71d76b5d")

--- Helper function.
local function helper_247d8b70(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_71d76b5d(arg0, arg1)
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
		helper_71d76b5d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 18) or var2
	if var2 == 0 then
		helper_57fafea1(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2daaf54b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_37ae00bc(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_247d8b70
