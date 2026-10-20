--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b488fc2 = require("@lib/event/helper_2b488fc2")
local helper_42ba9053 = require("@lib/event/helper_42ba9053")
local helper_808dac74 = require("@lib/event/helper_808dac74")
local helper_8588ef79 = require("@lib/event/helper_8588ef79")
local helper_992c6214 = require("@lib/event/helper_992c6214")

--- Helper function.
local function helper_fa3c33f1(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8588ef79(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_8588ef79(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_808dac74(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_992c6214(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2b488fc2(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_42ba9053(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_fa3c33f1
