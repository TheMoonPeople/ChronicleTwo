--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_395677d7 = require("@lib/event/helper_395677d7")
local helper_40db34d0 = require("@lib/event/helper_40db34d0")
local helper_7ba74223 = require("@lib/event/helper_7ba74223")
local helper_88c68d2f = require("@lib/event/helper_88c68d2f")
local helper_dc0f536e = require("@lib/event/helper_dc0f536e")

--- Helper function.
local function helper_8407ad32(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_7ba74223(arg0, arg1)
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
		helper_7ba74223(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_dc0f536e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_40db34d0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_88c68d2f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_395677d7(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_8407ad32
