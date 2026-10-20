--!strict
-- Shared event helper used by 10 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_02758812 = require("@lib/event/helper_02758812")
local helper_72b1d1ea = require("@lib/event/helper_72b1d1ea")

--- Helper function.
local function helper_7e621252(arg0: s32, arg1: s32)
	local var2: s32 = 0
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
	end
	event.SetMesPreset(0, 0)
	var2 = event.GetChapter() or var2
	if var2 ~= 8 then
		active_chr_no = event.GetActiveChrNo() or active_chr_no
		if active_chr_no == 1 then
			helper_02758812(arg0, arg1)
			if vm.skipping() then
				return skip(1)
			end
			return
		end
		event.MesMake_2(0, "あまり危ないところには\n行かないでね。")
	else
		event.MesMake_2(0, "いよいよ、バース鉄道が\n世界中に広がるのね。楽しみだわ。")
	end
	helper_72b1d1ea(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

return helper_7e621252
