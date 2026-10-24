--!strict
-- map/d/d02/b03/d02b03.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_d82a052e = require("@lib/event/helper_d82a052e")

--- Helper function.
local function helper_dbc8()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d82a052e(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(255, 1)
	event.MesMake_2(0, "いべんと２５５ｂ")
	helper_d82a052e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_de40()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d82a052e(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.MesMake_2(0, "あいてむまちがい")
	helper_d82a052e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Helper function.
local function helper_dd04()
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d82a052e(0, -1, 8, 0, 0)
		end
	end
	if vm.skipping() then
		return skip(1)
	end
	event.SetFlag(255, 1)
	event.MesMake_2(0, "いべんと２５５ａ")
	helper_d82a052e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(2)
	end
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.MesMake_2(0, "どどーん")
	helper_d82a052e(0, -1, 8, 0, 0)
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 200.
script[200] = function()
	event.SetCharaPos(0, -124.13, 782.88, -644.77)
	event.SetFadeIn(30)
	event.ResetCamera(0)
end

--- Program 400.
script[400] = function()
	local var0: s32 = 0
	local flag: s32 = 0
	local var2: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_d82a052e(0, -1, 5, 0, 0)
		end
		if at <= 3 then
			helper_dbc8()
		end
		if at <= 4 then
			helper_de40()
		end
		if at <= 6 then
			helper_dd04()
		end
		if at <= 7 then
			helper_de40()
		end
	end
	print("event400\n")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"大きな苗が出ている。\nまだ何か足りないようだ。<page>植物の成長を早めるアイテム・・・？\n（(#)ボタンでメニューを開く）"
				)
				helper_d82a052e(0, -1, 5, 0, 0)
				if vm.skipping() then
					return skip(1)
				end
				event.SetMesShippo(0, 1)
			else
				event.SetMesShippo(0, 0)
				event.MesMake_2(
					0,
					"小さな沼がある。何か不思議な\n感じがするなぁ・・・\n（(#)ボタンでメニューを開く）"
				)
				helper_d82a052e(0, -1, 5, 0, 0)
				if vm.skipping() then
					return skip(2)
				end
				event.SetMesShippo(0, 1)
			end
		end
	end
	if var0 == 2 then
		flag = event.GetFlag(24) or flag
		if flag ~= 0 then
		else
			flag = event.GetFlag(23) or flag
			if flag ~= 0 then
				event.GotoUseItem(356)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(3)
					end
				end
				if var2 == 356 then
					helper_dbc8()
					if vm.skipping() then
						return skip(4)
					end
					event.SetFlag(24, 1)
				else
					helper_de40()
					if vm.skipping() then
						return skip(5)
					end
				end
			else
				event.GotoUseItem(361)
				do
					local skipped = vm.wait()
					var2 = event.DeferredOutput() or var2
					if skipped then
						return skip(6)
					end
				end
				if var2 == 361 then
					helper_dd04()
					if vm.skipping() then
						return skip(7)
					end
					event.SetFlag(23, 1)
				else
					helper_de40()
					if vm.skipping() then
						return skip(8)
					end
				end
			end
		end
	end
end

return script
