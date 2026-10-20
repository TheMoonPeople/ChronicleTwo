--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_37c8faeb = require("@lib/event/helper_37c8faeb")
local helper_465a2536 = require("@lib/event/helper_465a2536")
local helper_65fc1678 = require("@lib/event/helper_65fc1678")
local helper_e0b6079b = require("@lib/event/helper_e0b6079b")

--- Helper function.
local function helper_e8dd20ce(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_37c8faeb(arg0, arg1)
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
		helper_37c8faeb(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 12) or var2
	if var2 == 0 then
		helper_465a2536(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_e0b6079b(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_65fc1678(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_e8dd20ce
