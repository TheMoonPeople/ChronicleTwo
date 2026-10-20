--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_3e597d0a = require("@lib/event/helper_3e597d0a")
local helper_475a0a6b = require("@lib/event/helper_475a0a6b")
local helper_6fa8c12f = require("@lib/event/helper_6fa8c12f")
local helper_a9967ae9 = require("@lib/event/helper_a9967ae9")

--- Helper function.
local function helper_6bb3f5ac(arg0: s32, arg1: s32)
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
		helper_a9967ae9(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 == 0 then
		helper_6fa8c12f(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	if var3 == 1 then
		helper_475a0a6b(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var3 == 2 then
		helper_3e597d0a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
end

return helper_6bb3f5ac
