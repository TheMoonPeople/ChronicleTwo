--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1cc5268f = require("@lib/event/helper_1cc5268f")
local helper_1f64c8ad = require("@lib/event/helper_1f64c8ad")
local helper_24d1805d = require("@lib/event/helper_24d1805d")
local helper_2b13de4f = require("@lib/event/helper_2b13de4f")
local helper_8465a1e3 = require("@lib/event/helper_8465a1e3")
local helper_91ea5cf4 = require("@lib/event/helper_91ea5cf4")
local helper_b594d692 = require("@lib/event/helper_b594d692")
local helper_e9655638 = require("@lib/event/helper_e9655638")
local helper_f3a90693 = require("@lib/event/helper_f3a90693")

--- Helper function.
local function helper_11455f1b()
	local flags: s32 = 0
	local item_x: s32 = 0
	local item_y: s32 = 0
	local num_x: s32 = 0
	local num_y: s32 = 0
	local now_party_chara_id: s32 = 0
	local var6: any = 0
	local var8: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_24d1805d(0, -1, 5, 0, 0)
				var6 = helper_1f64c8ad(0, 2, 2, 0)
			end
			return 0
		end
		if at <= 3 then
			return 0
		end
		if at <= 4 then
			return 0
		end
		if at <= 5 then
			return 0
		end
		if at <= 6 then
			var8 = 1
			helper_91ea5cf4(item_x, num_x, item_y, num_y)
		end
		if at <= 7 then
			var8 = 1
			helper_8465a1e3(item_x, num_x)
		end
		var8 = 1
		return item_x
	end
	event.Initialize()
	do
		local out1, out2, out3, out4, out5 = event.GetTboxParam()
		flags = out1 or flags
		item_x = out2 or item_x
		item_y = out3 or item_y
		num_x = out4 or num_x
		num_y = out5 or num_y
	end
	print("-----------------------------------------------------------------------------------------\n")
	print("tbox type = ", flags, "\n")
	print("item1 = ", item_x, ", ", num_x, "\n")
	print("item2 = ", item_y, ", ", num_y, "\n")
	print("-----------------------------------------------------------------------------------------\n")
	if bit32.band(flags, 256) ~= 0 then
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		if now_party_chara_id == 9 then
			event.DngPause(513, 1)
			helper_e9655638()
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Huh? Hold on! I smell something funny!\n　　　Be careful! I think it's a Mimic.")
			helper_f3a90693(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesQuestionGyou(0, 1)
			event.SetMesShippo(0, 0)
			event.SetMesEtc(0, 0, 1)
			event.SetMesEtc(0, 1, 1)
			event.MesMake_2(0, "You still want to open it?\nYes.\nNo.")
			helper_24d1805d(0, -1, 5, 0, 0)
			var6 = helper_1f64c8ad(0, 2, 2, 0)
			if vm.skipping() then
				return skip(2)
			end
			event.SetMesQuestionGyou(0, 0)
			event.SetMesShippo(0, 1)
			event.SetMesEtc(0, 0, 0)
			event.SetMesEtc(0, 1, 0)
			event.DngPause(513, 0)
			if var6 == 1 then
			else
				return 0
			end
		end
		helper_b594d692(item_x, num_x)
		if vm.skipping() then
			return skip(3)
		end
		return 0
	end
	event.DngPause(513, 1)
	helper_e9655638()
	event.SetMesWindowMode(0, 1)
	event.SetMesQuestionGyou(0, 1)
	event.SetMesShippo(0, 0)
	event.SetMesEtc(0, 0, 1)
	event.SetMesEtc(0, 1, 1)
	if bit32.band(flags, 2) ~= 0 then
		local t0: s32
		t0, flags = helper_2b13de4f(flags)
		local t1 = t0
		if vm.skipping() then
			return skip(4)
		end
		if t1 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return 0
		end
	end
	if bit32.band(flags, 4) ~= 0 then
		local t2: s32
		t2, flags = helper_1cc5268f(flags)
		local t3 = t2
		if vm.skipping() then
			return skip(5)
		end
		if t3 ~= 0 then
			event.DngPause(513, 0)
			event.Finish()
			return 0
		end
	end
	event.SetMesQuestionGyou(0, 0)
	event.SetMesShippo(0, 1)
	event.SetMesEtc(0, 0, 0)
	event.SetMesEtc(0, 1, 0)
	event.DngPause(513, 0)
	event.SetCrossfade(30)
	event.SetStatusbarShow(0, 0.16666667)
	event.CharaActive(0, 0)
	var8 = 0
	if bit32.band(flags, 512) ~= 0 then
		helper_8465a1e3(-1, -1)
		if vm.skipping() then
			return skip(6)
		end
		var8 = 1
	end
	if bit32.band(flags, 128) ~= 0 then
		helper_91ea5cf4(item_x, num_x, item_y, num_y)
		if vm.skipping() then
			return skip(7)
		end
		var8 = 1
	end
	if var8 == 0 then
		helper_8465a1e3(item_x, num_x)
		if vm.skipping() then
			return skip(8)
		end
		var8 = 1
	end
	event.SetStatusbarShow(1, 0.16666667)
	return item_x
end

return helper_11455f1b
