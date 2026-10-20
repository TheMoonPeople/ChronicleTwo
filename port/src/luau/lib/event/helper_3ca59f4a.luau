--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_12c6290d = require("@lib/event/helper_12c6290d")
local helper_13b3e735 = require("@lib/event/helper_13b3e735")
local helper_1bd7ffcb = require("@lib/event/helper_1bd7ffcb")
local helper_df895fdf = require("@lib/event/helper_df895fdf")
local helper_f27a3bbe = require("@lib/event/helper_f27a3bbe")

--- Helper function.
local function helper_3ca59f4a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_13b3e735(arg0, arg1)
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
		helper_13b3e735(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_f27a3bbe(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_1bd7ffcb(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_12c6290d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_df895fdf(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_3ca59f4a
