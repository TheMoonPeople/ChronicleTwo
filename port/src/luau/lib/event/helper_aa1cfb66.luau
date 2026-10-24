--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0cadc6b7 = require("@lib/event/helper_0cadc6b7")
local helper_299e94f2 = require("@lib/event/helper_299e94f2")
local helper_7fa1026d = require("@lib/event/helper_7fa1026d")
local helper_8146f3ab = require("@lib/event/helper_8146f3ab")

--- Helper function.
local function helper_aa1cfb66(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8146f3ab(arg0, arg1)
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
		helper_8146f3ab(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 14) or var2
	if var2 == 0 then
		helper_7fa1026d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_0cadc6b7(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_299e94f2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_aa1cfb66
