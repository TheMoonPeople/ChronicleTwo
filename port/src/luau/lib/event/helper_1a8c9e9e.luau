--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_04ed57b9 = require("@lib/event/helper_04ed57b9")
local helper_39c58907 = require("@lib/event/helper_39c58907")
local helper_792acded = require("@lib/event/helper_792acded")
local helper_96811468 = require("@lib/event/helper_96811468")
local helper_ace9eb28 = require("@lib/event/helper_ace9eb28")

--- Helper function.
local function helper_1a8c9e9e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_04ed57b9(arg0, arg1)
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
		helper_04ed57b9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_96811468(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_39c58907(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_792acded(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_ace9eb28(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_1a8c9e9e
