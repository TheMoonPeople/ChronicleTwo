--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_4b80b191 = require("@lib/event/helper_4b80b191")
local helper_7ab386d2 = require("@lib/event/helper_7ab386d2")
local helper_c60a8e40 = require("@lib/event/helper_c60a8e40")
local helper_d1e65749 = require("@lib/event/helper_d1e65749")

--- Helper function.
local function helper_09659241(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_c60a8e40(arg0, arg1, 0)
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
		helper_c60a8e40(arg0, arg1, 0)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 13) or var2
	if var2 == 0 then
		helper_7ab386d2(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_4b80b191(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_d1e65749(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_09659241
