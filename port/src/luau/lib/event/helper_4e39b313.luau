--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0a0f2168 = require("@lib/event/helper_0a0f2168")
local helper_172bfba4 = require("@lib/event/helper_172bfba4")
local helper_1daae0d3 = require("@lib/event/helper_1daae0d3")
local helper_3054012c = require("@lib/event/helper_3054012c")
local helper_6bae65b2 = require("@lib/event/helper_6bae65b2")
local helper_920b3567 = require("@lib/event/helper_920b3567")
local helper_c961ed17 = require("@lib/event/helper_c961ed17")

--- Helper function.
local function helper_4e39b313(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_920b3567(arg0, arg1)
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
				helper_6bae65b2(arg0, arg1)
			end
			if at <= 6 then
				helper_1daae0d3(arg0, arg1)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_920b3567(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_3054012c(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 7) or var3
	if var3 == 0 then
		helper_c961ed17(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		var4 = event.GetCnt(8) or var4
		if var4 == 0 then
			helper_0a0f2168(arg0, arg1)
			if vm.skipping() then
				return skip(5)
			end
		end
		if var4 == 1 then
			helper_6bae65b2(arg0, arg1)
			if vm.skipping() then
				return skip(6)
			end
		end
		if var4 == 2 then
			helper_1daae0d3(arg0, arg1)
			if vm.skipping() then
				return skip(7)
			end
		end
		return
	end
	if var3 == 2 then
		helper_172bfba4(arg0, arg1)
		if vm.skipping() then
			return skip(8)
		end
		return
	end
end

return helper_4e39b313
