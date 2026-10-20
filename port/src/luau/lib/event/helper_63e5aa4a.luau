--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_318506ca = require("@lib/event/helper_318506ca")
local helper_4e8f5ea7 = require("@lib/event/helper_4e8f5ea7")
local helper_5adbb0bf = require("@lib/event/helper_5adbb0bf")
local helper_cb595d91 = require("@lib/event/helper_cb595d91")
local helper_eecf7fd1 = require("@lib/event/helper_eecf7fd1")

--- Helper function.
local function helper_63e5aa4a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_318506ca(arg0, arg1)
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
		helper_318506ca(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_cb595d91(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_eecf7fd1(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_5adbb0bf(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_4e8f5ea7(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_63e5aa4a
