--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_403f0e66 = require("@lib/event/helper_403f0e66")
local helper_6632ae5d = require("@lib/event/helper_6632ae5d")
local helper_7f3762dd = require("@lib/event/helper_7f3762dd")
local helper_dae2ac4c = require("@lib/event/helper_dae2ac4c")

--- Helper function.
local function helper_37cd5d9b(arg0: s32, arg1: s32)
	local active_chr_no: s32 = 0
	local photo: s32 = 0
	local photo_2: s32 = 0
	local photo_3: s32 = 0
	local photo_4: s32 = 0
	local photo_5: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			if at <= 2 then
				helper_403f0e66(0, -1, arg0, arg1, 0)
			end
			return
		end
		if at <= 4 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 5 then
			helper_403f0e66(0, -1, arg0, arg1, 0)
		end
		if at <= 6 then
			helper_7f3762dd()
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		helper_6632ae5d(arg0, arg1)
		if vm.skipping() then
			return skip(1)
		end
		return
	end
	event.SetMesPreset(0, 0)
	helper_dae2ac4c(arg0, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
	photo = event.CheckInventPhoto(2009) or photo
	photo_2 = event.CheckInventPhoto(52, 3) or photo_2
	photo_3 = event.CheckInventPhoto(53, 3) or photo_3
	photo_4 = event.CheckInventPhoto(54, 3) or photo_4
	photo_5 = event.CheckInventPhoto(55, 3) or photo_5
	if vm.i32(vm.i32(vm.i32(vm.i32(photo + photo_2) + photo_3) + photo_4) + photo_5) <= 0 then
		event.MesMake_2(
			0,
			"Hai fotografato un fiore insolito?<page>So tutto sui fiori... se non [UNI00e8]\ndavvero speciale non mi interessa!"
		)
		helper_403f0e66(0, -1, arg0, arg1, 0)
		if vm.skipping() then
			return skip(3)
		end
		event.SetMotion(arg0, "立ち")
		event.Finish()
		return
	end
	event.MesMake_2(0, "Hai fotografato un fiore insolito?\nVediamo, vediamo!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(4)
	end
	event.MesMake_2(0, "Wow! [UNI00c8] incredibile! Allora,\nsi trovano fiori cos[UNI00ec] l[UNI00e0] fuori!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(5)
	end
	event.MesMake_2(0, "Mmh... cosa dovrei fare?<page>Oh, va bene! Portatemi con voi!")
	helper_403f0e66(0, -1, arg0, arg1, 0)
	if vm.skipping() then
		return skip(6)
	end
	event.SetMotion(arg0, "立ち")
	helper_7f3762dd()
	if vm.skipping() then
		return skip(7)
	end
	event.Finish()
	event.SetQuestEtc(1, 4, 1)
end

return helper_37cd5d9b
