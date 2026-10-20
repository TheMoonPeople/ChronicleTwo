--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_29692558 = require("@lib/event/helper_29692558")
local helper_58091cda = require("@lib/event/helper_58091cda")
local helper_661d2cfd = require("@lib/event/helper_661d2cfd")
local helper_e8b32382 = require("@lib/event/helper_e8b32382")

--- Helper function.
local function helper_e845f005(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_661d2cfd(arg0, arg1)
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
		helper_661d2cfd(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 1) or var2
	if var2 == 0 then
		helper_58091cda(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_29692558(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_e8b32382(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_e845f005
