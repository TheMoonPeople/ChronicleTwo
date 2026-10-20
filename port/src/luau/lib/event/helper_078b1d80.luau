--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_9d142a11 = require("@lib/event/helper_9d142a11")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_078b1d80(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 4 then
			if at <= 1 then
				helper_06ed6d94(arg0, 0, 0)
			end
			if at <= 2 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			if at <= 3 then
				helper_dbd14b96(0, -1, arg0, arg1, 0)
			end
			return
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		event.SetMesPreset(0, 0)
		helper_06ed6d94(arg0, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "やぁ、こんにちは。<page>君は、確かモニカと\n言ったね。")
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.MesMake_2(0, "僕はパトリ。\n魔法絵師をしているんだ。")
		helper_dbd14b96(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(4)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.SetMesPreset(0, 0)
	event.MesMake_2(
		0,
		"やぁ、ユリス、\nこんにちは。<page>いつも元気そうで\nうらやましいよ。"
	)
	helper_9d142a11(arg0, -1, 0, 0)
	if vm.skipping() then
		return skip(5)
	end
end

return helper_078b1d80
