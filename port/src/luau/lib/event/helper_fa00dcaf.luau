--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_36d70903 = require("@lib/event/helper_36d70903")
local helper_3cca8fc5 = require("@lib/event/helper_3cca8fc5")
local helper_4aa77388 = require("@lib/event/helper_4aa77388")
local helper_589b08e4 = require("@lib/event/helper_589b08e4")
local helper_e11b1104 = require("@lib/event/helper_e11b1104")

--- Helper function.
local function helper_fa00dcaf(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_3cca8fc5(arg0, arg1)
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
		helper_3cca8fc5(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_589b08e4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_4aa77388(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_36d70903(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_e11b1104(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_fa00dcaf
