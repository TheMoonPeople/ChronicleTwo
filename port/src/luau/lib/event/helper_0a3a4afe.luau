--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_10b5403a = require("@lib/event/helper_10b5403a")
local helper_373a36bd = require("@lib/event/helper_373a36bd")
local helper_455d9e2e = require("@lib/event/helper_455d9e2e")
local helper_d2ab3470 = require("@lib/event/helper_d2ab3470")
local helper_f8e9db45 = require("@lib/event/helper_f8e9db45")

--- Helper function.
local function helper_0a3a4afe(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_10b5403a(arg0, arg1)
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
		helper_10b5403a(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_455d9e2e(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 6) or var3
	if var3 == 0 then
		helper_d2ab3470(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_f8e9db45(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_373a36bd(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_0a3a4afe
