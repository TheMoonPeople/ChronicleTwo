--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4eaa4a89 = require("@lib/event/helper_4eaa4a89")
local helper_6eb9ed37 = require("@lib/event/helper_6eb9ed37")
local helper_6ef696bf = require("@lib/event/helper_6ef696bf")
local helper_f480af6b = require("@lib/event/helper_f480af6b")

--- Helper function.
local function helper_bb8f5e71(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_4eaa4a89(arg0, arg1)
			end
			return
		end
		if at <= 3 then
			return
		end
		if at <= 4 then
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	flag = event.GetFlag(314) or flag
	if flag == 0 then
		helper_4eaa4a89(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 17) or var3
	if var3 == 0 then
		helper_6eb9ed37(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 1 then
		helper_6ef696bf(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var3 == 2 then
		helper_f480af6b(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_bb8f5e71
