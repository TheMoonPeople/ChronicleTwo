--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_7d878e1f = require("@lib/event/helper_7d878e1f")
local helper_a4f6a8d8 = require("@lib/event/helper_a4f6a8d8")
local helper_dcfc74de = require("@lib/event/helper_dcfc74de")
local helper_dff0cdbe = require("@lib/event/helper_dff0cdbe")

--- Helper function.
local function helper_4e92bfe4(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_dcfc74de(arg0, arg1, 0)
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
		helper_dcfc74de(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_a4f6a8d8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_7d878e1f(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_dff0cdbe(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_4e92bfe4
