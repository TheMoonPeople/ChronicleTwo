--!strict
-- map/i/i02/h01/i02h01_1.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_1565f910 = require("@lib/event/helper_1565f910")
local helper_15d7e8e6 = require("@lib/event/helper_15d7e8e6")
local helper_36526538 = require("@lib/event/helper_36526538")
local helper_4adb8cbe = require("@lib/event/helper_4adb8cbe")
local helper_4b68ef15 = require("@lib/event/helper_4b68ef15")
local helper_6432ba85 = require("@lib/event/helper_6432ba85")
local helper_89004d78 = require("@lib/event/helper_89004d78")
local helper_8f562e83 = require("@lib/event/helper_8f562e83")
local helper_946c0402 = require("@lib/event/helper_946c0402")
local helper_98430d9a = require("@lib/event/helper_98430d9a")
local helper_9d3aacf6 = require("@lib/event/helper_9d3aacf6")
local helper_9f53b697 = require("@lib/event/helper_9f53b697")
local helper_9fa62045 = require("@lib/event/helper_9fa62045")
local helper_aafd6a80 = require("@lib/event/helper_aafd6a80")
local helper_b436078b = require("@lib/event/helper_b436078b")
local helper_c9057fa5 = require("@lib/event/helper_c9057fa5")
local helper_ed7a22dd = require("@lib/event/helper_ed7a22dd")

--- Helper function.
local function helper_1f628()
	local var0: any = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_c9057fa5(0, 1)
			return 0
		end
		if at <= 3 then
			helper_aafd6a80(15)
		end
		return 0
	end
	event.SetMotion(0, "立ち")
	event.Initialize()
	helper_c9057fa5(0, 4)
	event.MesMake_2(0, "Go inside\nLeave")
	var0 = helper_9d3aacf6(0, -1, 5, 256, 208, 2, 0)
	if vm.skipping() then
		return skip(1)
	end
	if var0 == -1 then
		helper_c9057fa5(0, 1)
		return 0
	end
	if var0 == 1 then
		event.SetFadeOut(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(2)
		end
		event.GotoMenu(19, 0)
		if vm.wait() then
			return skip(3)
		end
		event.SetFadeIn(15)
		helper_aafd6a80(15)
		if vm.skipping() then
			return skip(4)
		end
		return 0
	end
	return 1
end

--- Helper function.
local function helper_21acc()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_9fa62045(15)
		end
		if at <= 2 then
			helper_9fa62045(1)
		end
		if at <= 3 then
			helper_9fa62045(6)
		end
		if at <= 4 then
			helper_9fa62045(0)
		end
		if at <= 5 then
			helper_9fa62045(4)
		end
		if at <= 6 then
			helper_9fa62045(31)
		end
		if at <= 7 then
			helper_9fa62045(35)
		end
		if at <= 8 then
			helper_9fa62045(36)
		end
		if at <= 9 then
			helper_9fa62045(37)
		end
	end
	print("IN go_shop_up()\n")
	var0 = event.GetEventData_2(14) or var0
	var1 = event.GetEventData_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Welcome.")
	if var0 == 18 then
		event.MesMake_2(
			0,
			"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
		)
	end
	if var0 == 4 then
		event.MesMake_2(
			0,
			"Working hard, I see?\nYou need something?<page>No freebies, though.\nNot even for you, Max."
		)
	end
	if var0 == 34 then
		event.MesMake_2(
			0,
			"You need some more Georama\nelements?<page>If you don't have the time to\ncollect them yourself, maybe\nmoney can solve your problems."
		)
	end
	if var0 == 1012 then
		flag = event.GetFlag(45) or flag
		if flag == 0 then
			event.MesMake_2(
				0,
				"Hello. I'm a baker's apprentice.\nI'm handling the bakery while\nPolly's away.<page>I'm a little nervous, but this is\nall part of my training, I guess.\nI'll do my best!"
			)
			event.SetFlag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.GetFlag(46) or flag_2
		if flag_2 == 0 then
			event.MesMake_2(
				0,
				"We may not look very much alike...\nBut I'm Milane's little sister.<page>Milane made me watch the shop while she's away.\nI don't know the first thing about weapons!"
			)
			event.SetFlag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.GetFlag(47) or flag_3
		if flag_3 == 0 then
			event.MesMake_2(
				0,
				"Surprise you, did I? I guess anyone\nwould be surprised to see someone\nstanding here dressed like this.<page>I'm a good friend of Priest Bruno. I'm\nfilling in for him while he's away on a trip.\nSo, is there anything I can help you with?"
			)
			event.SetFlag(47, 1)
		else
			event.MesMake_2(
				0,
				"Would you like to borrow the\npower of the gods? Then please\nmake a donation to the church."
			)
		end
	end
	if var1 ~= -1 then
		helper_ed7a22dd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(1)
		end
	end
	if var0 == 18 then
		helper_9fa62045(15)
		if vm.skipping() then
			return skip(2)
		end
	end
	if var0 == 12 then
		helper_9fa62045(1)
		if vm.skipping() then
			return skip(3)
		end
	end
	if var0 == 4 then
		helper_9fa62045(6)
		if vm.skipping() then
			return skip(4)
		end
	end
	if var0 == 15 then
		helper_9fa62045(0)
		if vm.skipping() then
			return skip(5)
		end
	end
	if var0 == 33 then
		helper_9fa62045(4)
		if vm.skipping() then
			return skip(6)
		end
	end
	if var0 == 34 then
		helper_9fa62045(31)
		if vm.skipping() then
			return skip(7)
		end
	end
	if var0 == 1012 then
		helper_9fa62045(35)
		if vm.skipping() then
			return skip(8)
		end
	end
	if var0 == 1015 then
		helper_9fa62045(36)
		if vm.skipping() then
			return skip(9)
		end
	end
	if var0 == 1018 then
		helper_9fa62045(37)
		if vm.skipping() then
			return skip(10)
		end
	end
end

--- Helper function.
local function helper_22904()
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local var5: s32 = 0
	local active_chr_no: s32 = 0
	local var7: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local active_chr_no_2: s32 = 0
	local active_chr_no_3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 2 then
			return
		end
		if at <= 3 then
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
		if at <= 7 then
			return
		end
	end
	event.GetControlChrid()
	var1 = event.GetEventData_2(13) or var1
	var2 = event.GetEventData_2(14) or var2
	print("talk_chara_id=", var1, "talk_chara=", var2, "\n")
	do
		local out1, out2 = event.GetMesEtc(0, 3, var2)
		var3 = out1 or var3
		var4 = out2 or var4
	end
	active_chr_no = event.GetActiveChrNo() or active_chr_no
	if active_chr_no == 1 then
		var5 = 2
	else
		var5 = 1
	end
	event.CtrlcStay()
	event.SetAi(0, var1)
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	if var2 == 1012 or var2 == 1015 or var2 == 1018 then
		helper_21acc()
		if vm.skipping() then
			return skip(1)
		end
		event.SetAi(1, var1)
		return
	end
	if var2 == 50 then
		event.MesMake_2(0, "Hey! No admittance\nbeyond this point.")
		helper_ed7a22dd(var1, -1, 0, 0)
		if vm.skipping() then
			return skip(2)
		end
		event.SetAi(1, var1)
		return
	end
	var7 = event.GetChapter() or var7
	if var7 == 1 then
		flag = event.GetFlag(9) or flag
		if var2 == 2 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Take a look at that. Hard to\nbelieve this thing used to zoom\nalong, eh?<page>It really did...a long time ago.<page>It's my dream to set off on another\njourney in this thing. That's why I\nmake sure to keep 'er in top shape.<page>That way, if I ever get"
				)
			else
				event.MesMake_2(
					0,
					"You know how you go to exercise\nevery day or you get all stiff and\nachy? Same thing goes for machines."
				)
			end
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(3)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 63 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hey there, Max!\nIt's been ages since the\nrailroad stopped running.<page>But I'm still here patrolling\nthe station, every day."
				)
			else
				event.MesMake_2(
					0,
					"The Mayor finally got off his duff\nand got the trains going again. But\nthey're still not ready for the public.<page>Boy, I really want to let the\ntownspeople on board..."
				)
			end
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(4)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 65 then
			if flag == 0 then
				event.MesMake_2(
					0,
					"Hi, Max. Did you know that the\nStationmaster is my dad? We watch\nover this station together.<page>Until the day the railway is back\nup and running..."
				)
			else
				event.MesMake_2(
					0,
					"The train's running!\nBut it'll take a while before\nthe station's back to normal..."
				)
			end
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(5)
			end
			event.SetAi(1, var1)
			return
		end
	end
	if var7 == 8 then
		flag_2 = event.GetFlag(804) or flag_2
		if var2 == 61 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"I've been a secret admirer\nof Monica for ages, but I\nain't seen her around lately.<page>That's why I can't seem\nto concentrate on work."
				)
			else
				active_chr_no_2 = event.GetActiveChrNo() or active_chr_no_2
				if active_chr_no_2 ~= 1 then
					event.MesMake_2(0, "Hey, Max!\nSeems Monica's back.\nEveryone'll be really pleased!")
				else
					event.MesMake_2(0, "Monica! How've you been?\nI really missed you.")
				end
			end
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(6)
			end
			event.SetAi(1, var1)
			return
		end
		if var2 == 80 then
			if flag_2 == 0 then
				event.MesMake_2(
					0,
					"I'd just got to the point where\nI could talk to Monica normally,\nand then she disappeared.<page>Come on Max,\ntell me where she is, will ya?"
				)
			else
				active_chr_no_3 = event.GetActiveChrNo() or active_chr_no_3
				if active_chr_no_3 ~= 1 then
					event.MesMake_2(0, "Monica's back.\nHow on earth??")
				else
					event.MesMake_2(0, "Monica, you're back!\nHow on earth??")
				end
			end
			helper_ed7a22dd(var1, -1, 0, 0)
			if vm.skipping() then
				return skip(7)
			end
			event.SetAi(1, var1)
			return
		end
	end
	event.MesMake_2(0, "Hello there.\nGreat weather, isn't it.")
	event.MesMake_2(0, vm.i32(vm.i32(vm.i32(var3 * 10000) + vm.i32(var4 * 10)) + var5))
	helper_ed7a22dd(var1, -1, 0, 0)
	if vm.skipping() then
		return skip(8)
	end
	event.SetAi(1, var1)
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_6432ba85

--- Program 100.
script[100] = function()
	local mc_load: s32 = 0
	local old_map_no: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_4adb8cbe()
		end
	end
	event.Initialize()
	helper_6432ba85()
	print("start_event--------------------------------------------\n")
	mc_load = event.CheckMcLoad() or mc_load
	if mc_load == 1 then
		event.SetCharaPos(0, -240.0, 35.8, 140.0)
		event.SetCharaRot(0, 0.0, 3.14, 0.0)
		event.SetMotion(0, "立ち", 4)
		event.CharaNormalDrive(0)
		event.CharaResetDa(0)
		event.ResetCamera(1, 3.14, 20.0)
	else
		old_map_no = event.GetOldMapNo() or old_map_no
		var2 = event.GetMapType(old_map_no) or var2
		if var2 ~= -1 then
			if old_map_no == 10 or old_map_no == 22 or old_map_no == 121 then
				event.SetCharaPos(0, 0.0, 198.8, 1450.0)
				event.SetCharaRot(0, 0.0, 3.14, 0.0)
				event.ResetCamera(1, 3.14)
				event.SetFadeIn(30)
			else
				var3 = event.GetCnt(1) or var3
				if (old_map_no == 18 or old_map_no == 23 or old_map_no == 120 or old_map_no == 108) and var3 == 1 then
					helper_946c0402()
					event.SetFadeIn(15)
					event.ResetCamera(1, 0.0)
				else
					var4 = event.GetChapter() or var4
					if var4 ~= 6 and var4 ~= 7 then
						helper_b436078b()
						if vm.skipping() then
							return skip(1)
						end
					else
						helper_4adb8cbe()
						if vm.skipping() then
							return skip(2)
						end
					end
				end
			end
		end
		event.SetMotion(0, "立ち")
	end
end

--- Program 150.
script[150] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_4adb8cbe()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 151.
script[151] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_15d7e8e6()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 160.
script[160] = function()
	local pos_x: f32 = 0
	local pos_y: f32 = 0
	local pos_z: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			print("pos[0]=", string.format("%f", pos_x), "-----------\n")
			print("pos[1]=", string.format("%f", pos_y), "-----------\n")
			print("pos[2]=", string.format("%f", pos_z), "-----------\n")
		end
		if at <= 2 then
			helper_4b68ef15(64)
		end
	end
	event.Initialize()
	if vm.wait() then
		return skip(1)
	end
	event.EohSyncObj(0, "p01_train01")
	event.EohSetRot(0, 0.0, 0.0, 0.0)
	do
		local out1, out2, out3 = event.EohGetPos(0)
		pos_x = out1 or pos_x
		pos_y = out2 or pos_y
		pos_z = out3 or pos_z
	end
	print("pos[0]=", string.format("%f", pos_x), "-----------\n")
	print("pos[1]=", string.format("%f", pos_y), "-----------\n")
	print("pos[2]=", string.format("%f", pos_z), "-----------\n")
	event.EohSetPos(0, pos_x, pos_y, 0.0)
	event.CharaActive(0, 122)
	event.CharaActive(0, 123)
	event.CharaActive(0, 0)
	event.SetCameraPos(-345.21, 89.08, 234.02)
	event.SetCameraRef(-238.57, 83.73, 148.63)
	if vm.wait() then
		return skip(2)
	end
	helper_4b68ef15(64)
	if vm.skipping() then
		return skip(3)
	end
	event.CharaActive(1, 122)
	event.CharaActive(1, 123)
	event.CharaActive(1, 0)
	event.EohSetPos(0, pos_x, pos_y, -1800.0)
	event.EohSetRot(0, 0.0, 3.1415927, 0.0)
	event.ResetCamera(0)
end

--- Program 200.
script[200] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.wait() then
		return skip(1)
	end
	event.MapJump(-1, "m02")
	if vm.wait() then
		return skip(2)
	end
	event.Ext(103, 1645.1, -41.3, -1812.6) -- retail: the handler rejects 3 arguments
	event.Ext(104, 0, -0.09, 0) -- retail: the handler rejects 3 arguments
end

--- Program 250.
script[250] = function()
	local flag: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local var3: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 3 then
			if at <= 1 then
				helper_c9057fa5(0, 1)
				helper_36526538(0, -1, 5, 256, 208)
			end
			if at <= 2 then
				helper_36526538(0, -1, 5, 256, 208)
			end
			return
		end
		if at <= 4 then
			return
		end
		if at <= 6 then
			helper_8f562e83()
		end
		if at <= 9 then
			helper_98430d9a(0)
		end
		if at <= 10 then
			helper_89004d78()
		end
	end
	flag = event.GetFlag(202) or flag
	if flag == 0 then
		helper_9f53b697(0, vm.f32(1.57))
		if vm.skipping() then
			return skip(1)
		end
		helper_c9057fa5(0, 1)
		event.MesMake_2(
			0,
			"Cedric called this contraption a train,\ndidn't he...<page>Now Erik and Borneo are\nusing it as their house.<page>Cedric said it used to move,\nway back before I was born.<page>Is that true?"
		)
		helper_36526538(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(2)
		end
		event.MesMake_2(0, "Can something this big really move?<page>If it does move,\nI'd sure love to see it!")
		helper_36526538(0, -1, 5, 256, 208)
		if vm.skipping() then
			return skip(3)
		end
		return
	end
	var1 = helper_1f628()
	if vm.skipping() then
		return skip(4)
	end
	if var1 ~= 1 then
		return
	end
	event.SetCnt(1, 1)
	var2 = event.GetChapter() or var2
	var3 = event.GetEventData_2(3) or var3
	if var3 <= 1 then
		if var2 ~= 6 and var2 ~= 7 then
			helper_8f562e83()
			if vm.skipping() then
				return skip(5)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(6)
			end
			event.MapJump(-1, "s08")
		else
			helper_8f562e83()
			if vm.skipping() then
				return skip(7)
			end
			event.StopBgm(0)
			if vm.wait() then
				return skip(8)
			end
			event.MapJump(-1, "s37")
		end
		if vm.wait() then
			return skip(9)
		end
	elseif var2 ~= 6 and var2 ~= 7 then
		helper_98430d9a(0)
		if vm.skipping() then
			return skip(10)
		end
		event.StopBgm(0)
		event.MapJump(100, "s07")
	else
		helper_89004d78()
		if vm.skipping() then
			return skip(11)
		end
		event.StopBgm(0)
		event.MapJump(100, "s38")
	end
end

--- Program 400.
script[400] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_1565f910()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local var0: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	var0 = event.SearchCharaNo(2) or var0
	event.CharaActive(0, var0)
	event.SetAi(0, var0)
	helper_15d7e8e6()
	if vm.skipping() then
		return skip(1)
	end
	event.GotoDng(0, -1, 1000)
end

--- Program 1000.
script[1000] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_22904()
	if vm.skipping() then
		return skip(1)
	end
end

return script
