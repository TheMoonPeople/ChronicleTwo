--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6dd899ba = require("@lib/event/helper_6dd899ba")
local helper_7de453f4 = require("@lib/event/helper_7de453f4")
local helper_85bc3aac = require("@lib/event/helper_85bc3aac")
local helper_8ebd40ea = require("@lib/event/helper_8ebd40ea")
local helper_eb4e4dca = require("@lib/event/helper_eb4e4dca")

--- Helper function.
local function helper_b4df1b31(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_8ebd40ea(arg0, arg1)
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
		helper_8ebd40ea(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_eb4e4dca(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_6dd899ba(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_7de453f4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_85bc3aac(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_b4df1b31
