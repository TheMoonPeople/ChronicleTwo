--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_228c999d = require("@lib/event/helper_228c999d")
local helper_677bd3a6 = require("@lib/event/helper_677bd3a6")
local helper_dba24d0b = require("@lib/event/helper_dba24d0b")
local helper_e99f2884 = require("@lib/event/helper_e99f2884")

--- Helper function.
local function helper_6aafbfd1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_228c999d(arg0, arg1, 0)
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
		helper_228c999d(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_e99f2884(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_dba24d0b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_677bd3a6(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_6aafbfd1
