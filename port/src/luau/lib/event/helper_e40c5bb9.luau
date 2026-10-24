--!strict
-- Shared event helper used by 8 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1835c25e = require("@lib/event/helper_1835c25e")
local helper_83d41b5d = require("@lib/event/helper_83d41b5d")
local helper_b201ba53 = require("@lib/event/helper_b201ba53")
local helper_ff9e7ace = require("@lib/event/helper_ff9e7ace")

--- Helper function.
local function helper_e40c5bb9(arg0: s32, arg1: s32)
	local flag: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
			return
		end
	end
	flag = event.GetFlag(42) or flag
	if flag == 0 then
		helper_1835c25e(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_83d41b5d(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_ff9e7ace(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_b201ba53(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_e40c5bb9
