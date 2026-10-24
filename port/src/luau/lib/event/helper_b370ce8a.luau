--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3c3d00b3 = require("@lib/event/helper_3c3d00b3")
local helper_4583dd6c = require("@lib/event/helper_4583dd6c")
local helper_75a97975 = require("@lib/event/helper_75a97975")
local helper_d5bb101b = require("@lib/event/helper_d5bb101b")
local helper_e9df1f4d = require("@lib/event/helper_e9df1f4d")

--- Helper function.
local function helper_b370ce8a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_75a97975(arg0, arg1)
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
		helper_75a97975(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_d5bb101b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_4583dd6c(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_e9df1f4d(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_3c3d00b3(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_b370ce8a
