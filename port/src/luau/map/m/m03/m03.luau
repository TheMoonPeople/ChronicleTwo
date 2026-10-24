--!strict
-- map/m/m03/m03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Program 99.
local function program_99() end

--- Helper function.
local function helper_988(arg0: s32)
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
local function helper_b8c(arg0: s32)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			local _ = helper_988(arg0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while true do
		if helper_988(arg0) ~= 0 then
			break
		else
			if vm.wait() then
				return skip(2)
			end
		end
	end
end

--- Helper function.
local function helper_884(arg0: any)
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			arg0 = vm.wrap(arg0 - 1)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	while arg0 >= 0 do
		arg0 = arg0 - 1
		if vm.wait() then
			return skip(2)
		end
	end
end

--- Helper function.
local function helper_24c4()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	while true do
		var0 = event.CmrsCheck() or var0
		if var0 == 0 then
			break
		else
			if vm.wait() then
				return skip(1)
			end
		end
	end
end

--- Helper function.
local function helper_d2d0()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 1 then
			if vm.skip_end() then
				return skip(2)
			end
			return part2()
		end
	end
	function part2()
		event.CancelDramaScene()
		event.DeleteChara(32)
		event.CharaActive(1, 0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starbre.gltf", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(2206.38, 45.78, 2788.73)
	event.CmrsSetRef(2151.7, 44.53, 2924.41)
	event.ObjsSetPos(0, 2105.62, 0.0, 2971.54)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	event.CmrsMove2(2585.56, 45.78, 2117.44, 2529.48, 44.53, 2252.55, 200, 2, 0.2)
	event.ObjsSetMotion(0, "歩き", 4)
	event.ObjsInitPas(0)
	event.ObjsSetPasFrm(0, 210)
	event.ObjsAddPas(0, 2105.62, 0.0, 2971.54)
	event.ObjsAddPas(0, 2089.82, 0.0, 3103.38)
	event.ObjsAddPas(0, 2075.37, 0.0, 3210.94)
	event.ObjsAddPas(0, 2068.3, 32.6, 3283.51)
	event.ObjsAddPas(0, 2053.56, 65.0, 3353.79)
	event.ObjsStartPas(0)
	event.CmrsFadeInit()
	event.CmrsFadeDelay(170)
	event.CmrsFadeOut(30)
	helper_24c4()
	if vm.skipping() then
		return skip(1)
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

script[99] = program_99

--- Program 100.
script[100] = function()
	program_99()
	print("e109a kita----------\n")
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_b8c(32)
		end
	end
	if vm.wait() then
		return skip(1)
	end
	helper_b8c(32)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 501.
script[501] = function()
	local skip: (number) -> ...any
	local part2: () -> ...any
	function skip(at: number)
		if at <= 2 then
			if at <= 1 then
				helper_b8c(32)
			end
			if vm.skip_end() then
				return skip(3)
			end
			return part2()
		end
		if at <= 3 then
			helper_884(30)
		end
	end
	function part2()
		event.SetFadeOut(30)
		helper_884(30)
		if vm.skipping() then
			return skip(4)
		end
		event.DeleteChara(32)
		event.CharaActive(1, 0)
		event.SetFadeIn(30)
	end
	event.Initialize()
	event.AssignStack(5)
	event.ClearStack(5)
	event.LoadChara(5, "event/e100/e109/e109_starble.chr", "info", 32)
	event.EohSyncChara(0, 32)
	event.ObjsInit(0)
	event.ObjsSyncObj(0, 0)
	print("m03-e109a---------------------------------\n")
	event.InitDramaScene()
	event.CharaActive(0, 0)
	event.CharaActive(1, 32)
	event.CmrsSetPos(1984.9, 50.0, 3002.6)
	event.CmrsSetRef(1984.9, 30.0, 2882.6)
	event.ObjsSetPos(0, 1984.9, 0.0, 2882.6)
	event.ObjsSetRot(0, 0.0, 0.0, 0.0)
	if vm.wait() then
		return skip(1)
	end
	helper_b8c(32)
	if vm.skipping() then
		return skip(2)
	end
	event.CancelDramaScene()
	return part2()
end

--- Program 11091.
script[11091] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d2d0()
	if vm.skipping() then
		return skip(1)
	end
	event.CancelLoadVillager()
	if vm.wait() then
		return skip(2)
	end
	event.GotoInterior(-1, "i03h01a", 500)
	if vm.wait() then
		return skip(3)
	end
end

return script
