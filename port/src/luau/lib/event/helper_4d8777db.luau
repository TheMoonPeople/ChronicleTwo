--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0fd3dd8a = require("@lib/event/helper_0fd3dd8a")
local helper_57ead333 = require("@lib/event/helper_57ead333")
local helper_a012d558 = require("@lib/event/helper_a012d558")
local helper_d4ce4b76 = require("@lib/event/helper_d4ce4b76")
local helper_e925fec8 = require("@lib/event/helper_e925fec8")

--- Helper function.
local function helper_4d8777db(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_d4ce4b76(arg0, arg1)
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
		helper_d4ce4b76(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_e925fec8(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 10) or var3
	if var3 == 0 then
		helper_0fd3dd8a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 1 then
		helper_57ead333(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
	if var3 == 2 then
		helper_a012d558(arg0, arg1)
		if vm.skipping() then
			return skip(6)
		end
		return
	end
end

return helper_4d8777db
