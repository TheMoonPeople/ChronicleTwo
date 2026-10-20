--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_003fbe14 = require("@lib/event/helper_003fbe14")
local helper_465b4cea = require("@lib/event/helper_465b4cea")
local helper_55baf3bd = require("@lib/event/helper_55baf3bd")
local helper_f8849aea = require("@lib/event/helper_f8849aea")

--- Helper function.
local function helper_f18050be(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_55baf3bd(arg0, arg1)
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
		helper_55baf3bd(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_003fbe14(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_465b4cea(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_f8849aea(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_f18050be
