--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1bc7f95a = require("@lib/event/helper_1bc7f95a")
local helper_202a4718 = require("@lib/event/helper_202a4718")
local helper_321dc1e3 = require("@lib/event/helper_321dc1e3")
local helper_b41a8bc6 = require("@lib/event/helper_b41a8bc6")
local helper_b5df5c42 = require("@lib/event/helper_b5df5c42")

--- Helper function.
local function helper_39b27494(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_321dc1e3(arg0, arg1)
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
		helper_321dc1e3(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_1bc7f95a(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_b41a8bc6(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_202a4718(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_b5df5c42(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_39b27494
