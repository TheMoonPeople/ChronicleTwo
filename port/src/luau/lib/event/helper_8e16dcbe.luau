--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_18844bc4 = require("@lib/event/helper_18844bc4")
local helper_5b7d85f5 = require("@lib/event/helper_5b7d85f5")
local helper_6e79146c = require("@lib/event/helper_6e79146c")
local helper_9751dad4 = require("@lib/event/helper_9751dad4")
local helper_f564d048 = require("@lib/event/helper_f564d048")

--- Helper function.
local function helper_8e16dcbe(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_18844bc4(arg0, arg1)
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
		helper_18844bc4(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_6e79146c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_f564d048(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5b7d85f5(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_9751dad4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_8e16dcbe
