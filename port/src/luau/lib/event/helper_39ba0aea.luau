--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_22a3e3b9 = require("@lib/event/helper_22a3e3b9")
local helper_2cfa4afd = require("@lib/event/helper_2cfa4afd")
local helper_33c72cde = require("@lib/event/helper_33c72cde")
local helper_53b79cb3 = require("@lib/event/helper_53b79cb3")
local helper_8f75c1a4 = require("@lib/event/helper_8f75c1a4")

--- Helper function.
local function helper_39ba0aea(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_22a3e3b9(arg0, arg1)
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
	if active_chr_no == 0 then
		helper_22a3e3b9(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_2cfa4afd(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_8f75c1a4(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_53b79cb3(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_33c72cde(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_39ba0aea
