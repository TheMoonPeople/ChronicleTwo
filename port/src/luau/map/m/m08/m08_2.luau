--!strict
-- map/m/m08/m08_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1ef0d4b2 = require("@lib/event/helper_1ef0d4b2")
local helper_32d84646 = require("@lib/event/helper_32d84646")
local helper_492ae9b3 = require("@lib/event/helper_492ae9b3")
local helper_f9ed45d9 = require("@lib/event/helper_f9ed45d9")

local script: { [any]: (...any) -> ...any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- The event the engine runs on entering a town or interior, jumping to a map and leaving it, and the one an omitted event number means.
script.default_event = helper_1ef0d4b2

--- The event the town walk runs when the square button is pressed, after reloading the map script.
script.key_open = helper_32d84646

--- Event 151, which map data, a script or the engine runs by number.
script.event_151 = helper_f9ed45d9

--- Event 152, which map data, a script or the engine runs by number.
function script.event_152()
	local argc: s32 = 0
	event.SetLocalFlag(0, 0)
	helper_492ae9b3()
	event.SndInReverb(0)
	argc = event.GetLocalFlag(0) or argc
	if argc == 1 then
		event.SetCrossfade(60)
	else
		event.SetFadeIn(60)
	end
	vm.wait(2)
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
	vm.wait(3)
	vm.wait(4)
	event.SetMovieCc(0, 0)
	event.SndInReverb(1)
	event.BgmLoadCancel()
	event.SoundLoadCancel()
	event.MapJump_3(-1, "d01e01", 151)
end

return script
