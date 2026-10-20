--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_5234fa3a = require("@lib/event/helper_5234fa3a")
local helper_57c92ab3 = require("@lib/event/helper_57c92ab3")
local helper_7fcea6c5 = require("@lib/event/helper_7fcea6c5")
local helper_c95f6183 = require("@lib/event/helper_c95f6183")
local helper_ec14e073 = require("@lib/event/helper_ec14e073")

--- Helper function.
local function helper_3d05eb42(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_5234fa3a(arg0, arg1)
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
		helper_5234fa3a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_ec14e073(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_c95f6183(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_7fcea6c5(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_57c92ab3(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_3d05eb42
