--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_086cc8fc = require("@lib/event/helper_086cc8fc")
local helper_16b6dad6 = require("@lib/event/helper_16b6dad6")
local helper_223e403b = require("@lib/event/helper_223e403b")
local helper_5c6ba16c = require("@lib/event/helper_5c6ba16c")
local helper_887e23f3 = require("@lib/event/helper_887e23f3")
local helper_e0346e2e = require("@lib/event/helper_e0346e2e")

--- Helper function.
local function helper_aa921c33(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local var4: f32 = 0
	local var6: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_223e403b(arg0, arg1)
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
		helper_223e403b(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e0346e2e(arg0, arg1)
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
		helper_086cc8fc(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 9) or var3
	if var3 == 0 then
		helper_5c6ba16c(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 1 then
		helper_887e23f3(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
	if var3 == 2 then
		helper_16b6dad6(arg0, arg1)
		if vm.skipping() then
			return skip(7)
		end
		return
	end
end

return helper_aa921c33
