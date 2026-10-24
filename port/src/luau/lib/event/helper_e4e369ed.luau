--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_137d8ca2 = require("@lib/event/helper_137d8ca2")
local helper_2b17f83a = require("@lib/event/helper_2b17f83a")
local helper_61dcb5a8 = require("@lib/event/helper_61dcb5a8")
local helper_6b727c95 = require("@lib/event/helper_6b727c95")
local helper_7e145394 = require("@lib/event/helper_7e145394")

--- Helper function.
local function helper_e4e369ed(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_61dcb5a8(arg0, arg1)
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
		helper_61dcb5a8(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_137d8ca2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_7e145394(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_2b17f83a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_6b727c95(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_e4e369ed
