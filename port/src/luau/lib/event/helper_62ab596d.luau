--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_26edd796 = require("@lib/event/helper_26edd796")
local helper_49ecb44b = require("@lib/event/helper_49ecb44b")
local helper_82fb1428 = require("@lib/event/helper_82fb1428")
local helper_ef6eb46a = require("@lib/event/helper_ef6eb46a")

--- Helper function.
local function helper_62ab596d(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_26edd796(arg0, arg1)
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
		helper_26edd796(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_49ecb44b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_ef6eb46a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_82fb1428(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_62ab596d
