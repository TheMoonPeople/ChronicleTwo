--!strict
-- map/m/m08/m08_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_4183c250 = require("@lib/event/helper_4183c250")
local helper_451c15b0 = require("@lib/event/helper_451c15b0")
local helper_7d67d71a = require("@lib/event/helper_7d67d71a")

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = helper_1ef0d4b2

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4183c250()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_7d67d71a()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 152.
script[152] = function()
	local argc: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetLocalFlag(0, 0)
	helper_451c15b0()
	if vm.skipping() then
		return skip(1)
	end
	event.SndInReverb(0)
	argc = event.GetLocalFlag(0) or argc
	if argc == 1 then
		event.SetCrossfade(60)
	else
		event.SetFadeIn(60)
	end
	if vm.wait() then
		return skip(2)
	end
	event.AssignStack(5)
	event.ClearStack(5)
	event.SetBgColor(0, 0, 0)
	event.SetMovieCc(0, 0)
	event.SetMovieCc(1, 0, 105.0, "J'avais eu si peur [UNI00e0] ce moment-l[UNI00e0].", 90)
	event.SetMovieCc(1, 1, 210.0, "Mais dans un sens, c'[UNI00e9]tait super.", 90)
	event.SetMovieCc(1, 2, 390, "Bref, pour moi, tous les jours se\nressemblaient.", 90)
	event.SetMovieCc(
		1,
		3,
		540,
		"Mais [UNI00e7]a... [UNI00c7]a c'[UNI00e9]tait le d[UNI00e9]but\nd'une vraie aventure.",
		150
	)
	event.SetMovieCc(0, 1)
	event.LoadMovie(5, "movie/open1.mp4")
	event.SetFadeOut(0)
	if vm.wait() then
		return skip(3)
	end
	if vm.wait() then
		return skip(4)
	end
	event.SetMovieCc(0, 0)
	event.SndInReverb(1)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.MapJump(-1, "d01e01", 151)
end

return script
