--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ced885 = require("@lib/event/helper_06ced885")
local helper_51dafb2f = require("@lib/event/helper_51dafb2f")
local helper_570fb977 = require("@lib/event/helper_570fb977")
local helper_cecbde9f = require("@lib/event/helper_cecbde9f")
local helper_d8093a30 = require("@lib/event/helper_d8093a30")
local helper_e720c6d4 = require("@lib/event/helper_e720c6d4")

--- Helper function.
local function helper_0fb4735a(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_06ced885(arg0, arg1)
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
		if at <= 6 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_06ced885(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e720c6d4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	do
		local out1, _, out3 = event.GetCharaPos(arg0)
		var4 = out1 or var4
		var6 = out3 or var6
	end
	if var4 < 1182.0 or 1183.0 < var4 or var6 < 210.0 or 211.0 < var6 then
		print("kokokokokokokokokoko\n")
		helper_570fb977(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_cecbde9f(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_d8093a30(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_51dafb2f(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

return helper_0fb4735a
