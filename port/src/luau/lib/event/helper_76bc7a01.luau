--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3db3e33e = require("@lib/event/helper_3db3e33e")
local helper_486a22f0 = require("@lib/event/helper_486a22f0")
local helper_8088431e = require("@lib/event/helper_8088431e")
local helper_98bdc450 = require("@lib/event/helper_98bdc450")
local helper_c1b4c101 = require("@lib/event/helper_c1b4c101")

--- Helper function.
local function helper_76bc7a01(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_98bdc450(arg0, arg1)
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
		helper_98bdc450(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_8088431e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_486a22f0(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_3db3e33e(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_c1b4c101(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_76bc7a01
