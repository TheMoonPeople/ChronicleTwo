--!strict
-- Shared event helper used by 18 scripts, translated by tools/luau/stb2luau.

local helper_06e9e7c4 = require("@lib/event/helper_06e9e7c4")
local helper_07691b82 = require("@lib/event/helper_07691b82")
local helper_08141713 = require("@lib/event/helper_08141713")
local helper_b014bcfe = require("@lib/event/helper_b014bcfe")
local helper_dac0534c = require("@lib/event/helper_dac0534c")

--- Helper function.
local function helper_4f9cb005(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local var3: s32 = 0
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_07691b82(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 0) or var3
	if var3 ~= 2 then
		helper_b014bcfe(arg0, arg1)
		return
	end
	var3 = event.GetQuestEtc(0, 11) or var3
	if var3 == 0 then
		helper_dac0534c(arg0, arg1)
		return
	end
	if var3 == 1 then
		helper_06e9e7c4(arg0, arg1)
		return
	end
	if var3 == 2 then
		helper_08141713(arg0, arg1)
		return
	end
end

return helper_4f9cb005
