--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1b3555ca = require("@lib/event/helper_1b3555ca")
local helper_1db8a044 = require("@lib/event/helper_1db8a044")
local helper_be1773de = require("@lib/event/helper_be1773de")
local helper_c95ffb86 = require("@lib/event/helper_c95ffb86")
local helper_fc7f93f4 = require("@lib/event/helper_fc7f93f4")

--- Helper function.
local function helper_716ebc6a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_be1773de(arg0, arg1)
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
		helper_be1773de(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c95ffb86(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_1db8a044(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_fc7f93f4(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1b3555ca(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_716ebc6a
