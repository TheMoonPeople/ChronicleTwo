--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_027ca9a8 = require("@lib/event/helper_027ca9a8")
local helper_1a2692aa = require("@lib/event/helper_1a2692aa")
local helper_6d1d8396 = require("@lib/event/helper_6d1d8396")
local helper_91bc1a60 = require("@lib/event/helper_91bc1a60")
local helper_c1f6c1e4 = require("@lib/event/helper_c1f6c1e4")

--- Helper function.
local function helper_6336b270(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_027ca9a8(arg0, arg1)
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
		helper_027ca9a8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_c1f6c1e4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_91bc1a60(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_6d1d8396(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_1a2692aa(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_6336b270
