--!strict
-- map/r01.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_8b4(arg0: s32)
	local get_pad_down: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		return vm.i32(bit32.band(get_pad_down, arg0))
	end
	if vm.skipping() then
		return skip(1)
	end
	get_pad_down = event.GetPaddown() or get_pad_down
	return vm.i32(bit32.band(get_pad_down, arg0))
end

--- Helper function.
local function helper_ab8(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_8b4(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_8b4(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 100.
script[100] = function()
	event.Initialize()
	event.AssignStack(4)
	event.ClearStack(4)
	event.ChangeDir("chara/")
	event.LoadChara(4, "c002a.chr", "info", 8)
	event.CharaActive(1, 8)
	event.SetCharaPos(8, -100.0, 0.0, 0.0)
	event.LoadChara(4, "c005a.chr", "info", 9)
	event.CharaActive(1, 9)
	event.SetCharaPos(9, -50.0, 0.0, 0.0)
	event.LoadChara(4, "sraim.chr", "info", 10)
	event.CharaActive(1, 10)
	event.SetCharaPos(10, 0.0, 0.0, 0.0)
	event.LoadChara(4, "a_ku.chr", "info", 11)
	event.CharaActive(1, 11)
	event.SetCharaPos(11, 50.0, 0.0, 0.0)
	event.ChangeDir("")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_ab8(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_ab8(32)
	if vm.skipping() then
		return skip(2)
	end
end

return script
