--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2b60b6d5 = require("@lib/event/helper_2b60b6d5")
local helper_38749954 = require("@lib/event/helper_38749954")
local helper_44ccb72b = require("@lib/event/helper_44ccb72b")
local helper_cfaca14a = require("@lib/event/helper_cfaca14a")
local helper_db664d66 = require("@lib/event/helper_db664d66")

--- Helper function.
local function helper_637db0ce(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2b60b6d5(arg0, arg1)
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
		helper_2b60b6d5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_db664d66(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_44ccb72b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_cfaca14a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_38749954(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_637db0ce
