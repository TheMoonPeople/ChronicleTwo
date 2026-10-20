--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_204cd68f = require("@lib/event/helper_204cd68f")
local helper_2f56a1f6 = require("@lib/event/helper_2f56a1f6")
local helper_698e6ad2 = require("@lib/event/helper_698e6ad2")
local helper_99aef62d = require("@lib/event/helper_99aef62d")
local helper_d2bc23c8 = require("@lib/event/helper_d2bc23c8")

--- Helper function.
local function helper_bd9165c4(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_2f56a1f6(arg0, arg1)
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
		helper_2f56a1f6(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_204cd68f(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_d2bc23c8(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_99aef62d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_698e6ad2(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_bd9165c4
