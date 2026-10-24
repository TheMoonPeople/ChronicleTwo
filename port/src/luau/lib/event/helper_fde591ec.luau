--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1fec178d = require("@lib/event/helper_1fec178d")
local helper_2fe8a087 = require("@lib/event/helper_2fe8a087")
local helper_af705a23 = require("@lib/event/helper_af705a23")
local helper_ed4bc2f4 = require("@lib/event/helper_ed4bc2f4")

--- Helper function.
local function helper_fde591ec(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_af705a23(arg0, arg1, 0)
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
		helper_af705a23(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_1fec178d(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_2fe8a087(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_ed4bc2f4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_fde591ec
