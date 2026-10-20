--!strict
-- Shared event helper used by 7 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_6379d15a = require("@lib/event/helper_6379d15a")
local helper_667d4346 = require("@lib/event/helper_667d4346")
local helper_b73fcc0e = require("@lib/event/helper_b73fcc0e")
local helper_de64e465 = require("@lib/event/helper_de64e465")

--- Helper function.
local function helper_ae9f7c2f(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b73fcc0e(arg0, arg1)
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
		helper_b73fcc0e(arg0, arg1)
		if vm.skipping() then
			return skip(2)
		end
		return
	end
	var2 = event.GetQuestEtc(0, 4) or var2
	if var2 == 0 then
		helper_667d4346(arg0, arg1)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	if var2 == 1 then
		helper_6379d15a(arg0, arg1)
		if vm.skipping() then
			return skip(4)
		end
		return
	end
	if var2 == 2 then
		helper_de64e465(arg0, arg1)
		if vm.skipping() then
			return skip(5)
		end
		return
	end
end

return helper_ae9f7c2f
