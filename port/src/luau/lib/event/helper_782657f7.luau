--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_27d480fb = require("@lib/event/helper_27d480fb")
local helper_37b00c92 = require("@lib/event/helper_37b00c92")
local helper_3fa995af = require("@lib/event/helper_3fa995af")
local helper_833b82ed = require("@lib/event/helper_833b82ed")
local helper_d7ba72b4 = require("@lib/event/helper_d7ba72b4")

--- Helper function.
local function helper_782657f7(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_27d480fb(arg0, arg1)
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
		helper_27d480fb(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_833b82ed(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 8) or var3
	if var3 == 0 then
		helper_3fa995af(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_37b00c92(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_d7ba72b4(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_782657f7
