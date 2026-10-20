--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1de2d79d = require("@lib/event/helper_1de2d79d")
local helper_28c6c00a = require("@lib/event/helper_28c6c00a")
local helper_5ef69380 = require("@lib/event/helper_5ef69380")
local helper_6c96b7e8 = require("@lib/event/helper_6c96b7e8")
local helper_7e464c47 = require("@lib/event/helper_7e464c47")
local helper_86870950 = require("@lib/event/helper_86870950")
local helper_abea7dbe = require("@lib/event/helper_abea7dbe")

--- Helper function.
local function helper_ac385c59(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_86870950(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 7 then
			if at <= 5 then
				helper_6c96b7e8(arg0, arg1)
			end
			if at <= 6 then
				helper_7e464c47(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_86870950(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_abea7dbe(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_1de2d79d(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_5ef69380(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_6c96b7e8(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_7e464c47(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_28c6c00a(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_ac385c59
