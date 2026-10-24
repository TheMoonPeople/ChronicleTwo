--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_691c3e0a()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return 0
	end
	if vm.skipping() then
		return skip(1)
	end
	var1 = event.GetAnalyze(103) or var1
	if var1 == 0 then
		return 0
	end
	flag = event.GetFlag(260) or flag
	if flag == 0 then
		return 0
	end
	flag = event.GetFlag(280) or flag
	if flag ~= 0 then
		return 0
	end
	var2 = event.CheckEnableCharaChange(1) or var2
	if var2 == 0 then
		return 0
	end
	return 1
end

return helper_691c3e0a
