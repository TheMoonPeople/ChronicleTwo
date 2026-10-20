--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_037cb6f0 = require("@lib/event/helper_037cb6f0")
local helper_44cf2bcd = require("@lib/event/helper_44cf2bcd")
local helper_56dea11f = require("@lib/event/helper_56dea11f")
local helper_61177314 = require("@lib/event/helper_61177314")

--- Helper function.
local function helper_9f5da110(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_56dea11f(arg0, arg1)
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
		helper_56dea11f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_61177314(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_037cb6f0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_44cf2bcd(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_9f5da110
