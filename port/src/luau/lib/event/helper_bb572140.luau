--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ba31a4e = require("@lib/event/helper_1ba31a4e")
local helper_73c0280a = require("@lib/event/helper_73c0280a")
local helper_75b575e4 = require("@lib/event/helper_75b575e4")
local helper_e61a0414 = require("@lib/event/helper_e61a0414")

--- Helper function.
local function helper_bb572140(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_e61a0414(arg0, arg1)
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
		helper_e61a0414(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_75b575e4(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_1ba31a4e(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_73c0280a(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_bb572140
