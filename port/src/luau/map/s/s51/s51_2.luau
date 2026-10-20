--!strict
-- map/s/s51/s51_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_2f2a31d5 = require("@lib/event/helper_2f2a31d5")
local helper_53932f10 = require("@lib/event/helper_53932f10")
local helper_8639c6bb = require("@lib/event/helper_8639c6bb")
local helper_8cce5119 = require("@lib/event/helper_8cce5119")
local helper_ed0a80b8 = require("@lib/event/helper_ed0a80b8")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
-- Defined empty, so the engine runs this instead of its default.
script[150] = function() end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 2 then
			helper_2f2a31d5(0, -1, 8, 0, 0)
		end
	end
	helper_8cce5119()
	if vm.skipping() then
		return skip(1)
	end
	event.LoadMonsterFile(523, 1)
	event.AutoSetMonster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.AutoSetMonster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.AutoSetMonster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.AutoSetMonster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	if vm.wait() then
		return skip(2)
	end
	event.DngPause(16385, 1)
	event.SetFadeIn(20)
	event.SetMesWindowMode(0, 4)
	event.SetMesDrawspeed(0, 1)
	event.MesMake_2(0, "Viser : (X)\nParer : [r1]\nAttaquer : (O)\nMagie : [l1]+(O)")
	helper_2f2a31d5(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(3)
	end
	event.DngPause(1, 0)
	event.Finish()
end

--- Program 510.
script[510] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_53932f10()
			if not vm.skipping() then
				return part2()
			end
		end
	end
	function part2()
		event.CheckEquepChange(1)
		event.SetActiveChrNo(0)
		event.ExtTyped(1078, "ii", 0, 1)
		event.ExtTyped(1078, "ii", 1, 0)
		event.AddItem(353)
		event.AddItem(311)
		event.AddItem(268, 5)
		event.AddItem(294, 3)
		event.AddItem(298, 3)
		event.AddItem(425, 3)
		event.AddItem(275, 2)
		event.SetFlag(54, 1)
		event.BgmLoadCancel()
		event.GotoEdit(19, 151)
		if vm.wait() then
			return skip(3)
		end
	end
	event.Initialize()
	event.ActchrSetDefMotion(0)
	event.SetFadeOut(30)
	helper_ed0a80b8(30)
	if vm.skipping() then
		return skip(1)
	end
	event.DelMonster(-1)
	helper_53932f10()
	if vm.skipping() then
		return skip(2)
	end
	return part2()
end

--- Program 1200.
script[1200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_8639c6bb(0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 10500.
script[10500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.AddItem(110)
	event.AddItem(127)
	event.AddItem(133)
	event.AddItem(266)
	event.SetCharaEquip(1, 110)
	event.SetCharaEquip(1, 127)
	event.SetCharaEquip(1, 133)
	event.SetCharaEquip(1, 266)
	event.DngSetupMainUnit(1)
	helper_8cce5119()
	if vm.skipping() then
		return skip(1)
	end
	event.DngPause(16384, 1)
	event.LoadMonsterFile(523, 1)
	event.AutoSetMonster(523, -382.5, -0.2, 120.2, 0.0, 1.61, 0.0)
	event.AutoSetMonster(523, -428.0, -0.2, 202.7, 0.0, 1.71, 0.0)
	event.AutoSetMonster(523, -452.5, -0.2, 287.0, 0.0, 1.98, 0.0)
	event.AutoSetMonster(523, -324.2, -0.2, 260.5, 0.0, 2.34, 0.0)
	if vm.wait() then
		return skip(2)
	end
	event.SetFadeIn(20)
	event.Finish()
end

return script
