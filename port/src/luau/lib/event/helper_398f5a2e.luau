--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22c97964 = require("@lib/event/helper_22c97964")
local helper_70402a2d = require("@lib/event/helper_70402a2d")
local helper_98b28519 = require("@lib/event/helper_98b28519")
local helper_aaa679e8 = require("@lib/event/helper_aaa679e8")
local helper_f237ee0b = require("@lib/event/helper_f237ee0b")

--- Helper function.
local function helper_398f5a2e(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_70402a2d(arg0, arg1)
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
		helper_70402a2d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_22c97964(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 3) or var3
	if var3 == 0 then
		helper_98b28519(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_f237ee0b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_aaa679e8(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_398f5a2e
