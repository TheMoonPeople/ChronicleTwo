--!strict
-- map/s/s06/s06c_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0d126c14 = require("@lib/event/helper_0d126c14")
local helper_18063f80 = require("@lib/event/helper_18063f80")
local helper_8d6da5b2 = require("@lib/event/helper_8d6da5b2")
local helper_91c23527 = require("@lib/event/helper_91c23527")
local helper_bdbefa67 = require("@lib/event/helper_bdbefa67")

--- Program 310.
local function program_310()
	local flag: s32 = 0
	local var1: s32 = 0
	local member: s32 = 0
	local active_chr_no: s32 = 0
	local var5: any = 0
	local stage_id: s32 = 0
	local var7: s32 = 0
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			return
		end
		if at <= 4 then
			return
		end
		if at <= 5 then
			return
		end
		if at <= 6 then
			return
		end
		if at <= 9 then
			if at <= 7 then
				helper_bdbefa67(30)
			end
			return
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	event.ActchrSetDefMotion(0)
	flag = event.GetFlag(7) or flag
	if flag == 0 then
		event.Initialize()
		event.DngPause(1, 1)
		member = event.JoinPartyMember(2) or member
		if member ~= 0 then
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			event.MesMake_2(0, "Pas le temps pour [UNI00e7]a !")
			helper_18063f80(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(1)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(2)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		else
			event.SetMotion(0, "立ち")
			var1 = event.GetMesWindowMode(0) or var1
			event.SetMesWindowMode(0, 1)
			event.SetMesShippo(0, 0)
			flag = event.GetFlag(104) or flag
			if flag == 1 then
				event.MesMake_2(0, "La porte semble verrouill[UNI00e9]e.\nRemontons pour l'instant.")
			else
				event.MesMake_2(0, "Pas le temps pour [UNI00e7]a !")
			end
			helper_18063f80(0, -1, 5, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetMesWindowMode(0, var1)
			if vm.wait() then
				return skip(4)
			end
			event.DngPause(1, 0)
			event.Finish()
			return
		end
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "On dirait que pour pouvoir\navancer, tu dois descendre du\nRobomobil.")
		helper_18063f80(0, -1, 8, 256, 208)
		if vm.skipping() then
			return skip(5)
		end
		event.Finish()
		return
	end
	if active_chr_no == 3 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		helper_18063f80(0, 21, 8, 256, 208)
		if vm.skipping() then
			return skip(6)
		end
		event.Finish()
		return
	end
	event.SetMesWindowMode(0, 5)
	event.SetMesDrawspeed(0, 1)
	var5 = helper_8d6da5b2(1, -1)
	if vm.skipping() then
		return skip(7)
	end
	if var5 == 0 then
		event.SetBitCtrl(1, 0)
		stage_id = event.DngGetStageId() or stage_id
		var7 = event.DngGetFloorId() or var7
		argc = event.GetNextFloor(var7, 0) or argc
		event.DngSetFloorId(argc)
		event.SetFloorInfo(stage_id, var7, 5, 2)
		event.SetFloorInfo(stage_id, argc, 5, 1)
		event.SetFadeOut(30)
		helper_bdbefa67(30)
		if vm.skipping() then
			return skip(8)
		end
		flag = event.GetFlag(8) or flag
		if flag == 0 then
			event.StopBgm(0)
			event.SetFlag(8, 1)
			event.BgmLoadCancel()
			event.GotoEdit(12, 540)
			if vm.wait() then
				return skip(9)
			end
			return
		end
		event.BgmLoadCancel()
		event.GotoDng(0, 5, 1000)
		if vm.wait() then
			return skip(10)
		end
	end
	event.Finish()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 300.
script[300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	program_310()
	if vm.skipping() then
		return skip(1)
	end
end

script[310] = program_310

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_91c23527()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.SetBitCtrl(1, 0)
		event.SetSavedataEtc(0, 3)
		event.BgmLoadCancel()
		event.GotoEdit(10, 530)
		if vm.wait() then
			return skip(4)
		end
	end
	event.Initialize()
	event.FadeOutBgm(15)
	event.SetFadeOut(15)
	helper_bdbefa67(15)
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(17, 1)
	if vm.wait() then
		return skip(2)
	end
	event.StopBgm(0)
	helper_91c23527()
	if vm.skipping() then
		return skip(3)
	end
	return part2()
end

--- Program 600.
script[600] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.DngPause(17, 1)
	helper_91c23527()
	if vm.skipping() then
		return skip(1)
	end
	event.SetFadeIn(30)
end

--- Program 1200.
script[1200] = function()
	local active_chr_no: s32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0d126c14(0)
		end
		if at <= 2 then
			helper_0d126c14(0)
		end
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 2 then
		flag = event.GetFlag(7) or flag
		if flag == 0 then
			event.SetFlag(6, 1)
			if vm.wait() then
				return skip(1)
			end
			event.LoadScript("s06/s06.stb", 503)
		else
			helper_0d126c14(0)
			if vm.skipping() then
				return skip(2)
			end
		end
	else
		helper_0d126c14(0)
		if vm.skipping() then
			return skip(3)
		end
	end
end

return script
