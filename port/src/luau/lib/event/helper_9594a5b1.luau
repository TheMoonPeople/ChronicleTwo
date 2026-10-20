--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_a1c406d9 = require("@lib/event/helper_a1c406d9")
local helper_acadb06e = require("@lib/event/helper_acadb06e")
local helper_db451723 = require("@lib/event/helper_db451723")
local helper_fa7554e8 = require("@lib/event/helper_fa7554e8")

--- Helper function.
local function helper_9594a5b1(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_a1c406d9(arg0, arg1, 0)
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
	var2 = event.GetQuestEtc(0, 0) or var2
	if var2 ~= 2 then
		helper_a1c406d9(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_db451723(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_acadb06e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_fa7554e8(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_9594a5b1
