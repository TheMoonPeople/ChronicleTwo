--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_09d382f8 = require("@lib/event/helper_09d382f8")
local helper_30755d86 = require("@lib/event/helper_30755d86")
local helper_48cb4aa8 = require("@lib/event/helper_48cb4aa8")
local helper_5007a5d6 = require("@lib/event/helper_5007a5d6")
local helper_7bc5041b = require("@lib/event/helper_7bc5041b")

--- Helper function.
local function helper_74546ec2(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7bc5041b(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_7bc5041b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_5007a5d6(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_09d382f8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_48cb4aa8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_30755d86(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_74546ec2
