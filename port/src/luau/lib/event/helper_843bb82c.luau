--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_06ed6d94 = require("@lib/event/helper_06ed6d94")
local helper_dbd14b96 = require("@lib/event/helper_dbd14b96")

--- Helper function.
local function helper_843bb82c(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
		if at <= 2 then
			helper_dbd14b96(0, -1, arg0, arg1, 0)
		end
	end
	event.SetMesPreset(0, 0)
	helper_06ed6d94(arg0, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(
		0,
		"やぁ、ユリス。\n悪いが今は\n手が離せない。<page>町の安全のための\nとても重要な資料を\nまとめている所でね。"
	)
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(2)
	end
	event.MesMake_2(0, "急ぎの用事でなければ、\n明日にしてもらえないか。")
	helper_dbd14b96(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.SetMotion(arg0, "立ち")
	event.Finish()
end

return helper_843bb82c
