--!strict
-- map/g/g02/i02/g02i02_2.stb: event script, translated from the NTSC-timed bytecode by tools/luau/stb2luau.

local vm = require("@lib/vm")
local helper_0cbe7543 = require("@lib/event/helper_0cbe7543")
local helper_21ceb188 = require("@lib/event/helper_21ceb188")
local helper_38711c58 = require("@lib/event/helper_38711c58")
local helper_45424ea1 = require("@lib/event/helper_45424ea1")
local helper_4744b117 = require("@lib/event/helper_4744b117")
local helper_56b874f1 = require("@lib/event/helper_56b874f1")
local helper_63988eb6 = require("@lib/event/helper_63988eb6")
local helper_a0e17f3c = require("@lib/event/helper_a0e17f3c")
local helper_b6b83631 = require("@lib/event/helper_b6b83631")
local helper_b6c190ae = require("@lib/event/helper_b6c190ae")
local helper_d6af2bda = require("@lib/event/helper_d6af2bda")
local helper_e0a77950 = require("@lib/event/helper_e0a77950")

--- Helper function.
local function helper_281b4()
	local var0: s32 = 0
	local var1: s32 = 0
	local var2: s32 = 0
	local now_party_chara_id: s32 = 0
	local var4: s32 = 0
	local skip: (number) -> ...any
	local part2: () -> ...any
	local landing1: () -> ...any
	function skip(at: number)
		if at <= 1 then
			var0 = 2
		end
		if at <= 2 then
			helper_4744b117()
			if not vm.skipping() then
				return landing1()
			end
		end
		if at <= 3 then
			helper_d6af2bda()
		end
		if at <= 5 then
			helper_63988eb6()
		end
	end
	function part2() end
	function landing1()
		helper_d6af2bda()
		if vm.skipping() then
			return skip(4)
		end
		if vm.wait() then
			return skip(5)
		end
		now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
		var4 = event.GetNpcStatus(now_party_chara_id) or var4
		if bit32.band(var4, 4) ~= 0 then
			event.SetNpcStatus(now_party_chara_id, 4)
		else
			event.SetNpcStatus(now_party_chara_id, 2)
		end
		event.SetNpcStatus(26, 128)
		event.SetNpcStatus(26, 1)
		return part2()
	end
	event.Initialize()
	event.SetMotion(0, "立ち")
	var0 = event.GetEventData_2(6) or var0
	if var0 == 1 then
		event.SetMesWindowMode(0, 1)
		event.SetMesShippo(0, 0)
		event.MesMake_2(0, "On dirait que Lin souffre.\n(Pour ouvrir le menu : (#))")
		var1 = helper_21ceb188(0, -1, 5, 0, 0, var1)
		if vm.skipping() then
			return skip(1)
		end
		if var1 == 1 then
			var0 = 2
		end
	end
	if var0 == 2 then
		event.GotoUseItem(364)
		do
			local skipped = vm.wait()
			var2 = event.DeferredOutput() or var2
			if skipped then
				return skip(2)
			end
		end
		if var2 == 364 then
			event.FuncPointShow("", "syumai", 0)
			event.FuncPointShow("", "event_550", 0)
			helper_4744b117()
			if vm.skipping() then
				return skip(3)
			end
			helper_d6af2bda()
			if vm.skipping() then
				return skip(4)
			end
			if vm.wait() then
				return skip(5)
			end
			now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
			var4 = event.GetNpcStatus(now_party_chara_id) or var4
			if bit32.band(var4, 4) ~= 0 then
				event.SetNpcStatus(now_party_chara_id, 4)
			else
				event.SetNpcStatus(now_party_chara_id, 2)
			end
			event.SetNpcStatus(26, 128)
			event.SetNpcStatus(26, 1)
		elseif var2 > 0 then
			helper_63988eb6()
			if vm.skipping() then
				return skip(6)
			end
		end
	end
	return part2()
end

local script: { [any]: any } = {}

--- Runs when the script is loaded, before any program.
function script.setup() end

--- Program 99.
script[99] = helper_56b874f1

--- Program 100.
script[100] = function()
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local now_party_chara_id: s32 = 0
	local var7: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			return
		end
		if at <= 3 then
			return
		end
	end
	helper_56b874f1()
	flag = event.GetFlag(300) or flag
	flag_2 = event.GetFlag(304) or flag_2
	flag_3 = event.GetFlag(306) or flag_3
	flag_4 = event.GetFlag(324) or flag_4
	flag_5 = event.GetFlag(328) or flag_5
	event.GetFlag(330)
	if flag == 1 then
		if flag_2 == 0 then
			helper_b6c190ae()
			if vm.skipping() then
				return skip(1)
			end
			return
		else
			now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
			if flag_3 == 0 and now_party_chara_id == 6 then
				helper_b6b83631()
				if vm.skipping() then
					return skip(2)
				end
				event.SetNpcStatus(6, 2)
				event.BgmLoadCancel()
				event.MapJump(-1, "g02", 503)
				if vm.wait() then
					return skip(3)
				end
				return
			end
			if flag_4 == 1 and flag_5 == 0 then
				helper_45424ea1()
				if vm.skipping() then
					return skip(4)
				end
				return
			end
		end
	end
	var7 = event.GetSndId(2) or var7
	event.SndSePlay(var7, 61)
	event.SetCharaPos(0, 8.0, 0.0, 120.0)
	event.SetCharaRot(0, 0.0, 3.14, 0.0)
	event.SetMotion(0, "立ち", 4)
	event.CharaResetDa(0)
	event.ResetCamera(1, 0.0, 10.0)
	event.SetFadeIn(30)
end

--- Program 150.
script[150] = function()
	local now_party_chara_id: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_d6af2bda()
	if vm.skipping() then
		return skip(1)
	end
	if vm.wait() then
		return skip(2)
	end
	now_party_chara_id = event.GetNowPartyChara() or now_party_chara_id
	event.SetNpcStatus(now_party_chara_id, 2)
	event.SetNpcStatus(26, 128)
	event.SetNpcStatus(26, 1)
end

--- Program 200.
script[200] = function()
	local now_map_no: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number) end
	now_map_no = event.GetNowMapNo() or now_map_no
	if now_map_no == 1 then
		event.GotoOutside(-1, "g02", 100)
	else
		event.MapJump(-1, "g02", 100)
	end
	if vm.wait() then
		return skip(1)
	end
end

--- Program 500.
script[500] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	helper_281b4()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 550.
script[550] = function()
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			var5 = vm.f32(9.52)
			var7 = vm.f32(-125.12)
			helper_38711c58(player_chara, var8)
		end
		if at <= 2 then
			helper_e0a77950(0, -1, 4, 256, 312)
		end
		if at <= 3 then
			helper_a0e17f3c(15)
		end
	end
	print("550-------------------------------------------------")
	event.SetFadeOut(1)
	if vm.wait() then
		return skip(1)
	end
	event.Initialize()
	event.SetCameraPos(9.08, 28.93, -152.07)
	event.SetCameraRef(11.2, 18.91, -112.52)
	event.SetFadeIn(15)
	player_chara = event.GetControlChrid() or player_chara
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	var5 = vm.f32(9.52)
	var7 = vm.f32(-125.12)
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_38711c58(player_chara, var8)
	if vm.skipping() then
		return skip(2)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(306) or flag
	if flag == 0 then
		event.MesMake_2(0, "Ooooh...\nNnnnn... ahhhh...")
	else
		event.MesMake_2(0, "Ohhh, ohhh...")
	end
	helper_e0a77950(0, -1, 4, 256, 312)
	if vm.skipping() then
		return skip(3)
	end
	event.SetFadeOut(15)
	helper_a0e17f3c(15)
	if vm.skipping() then
		return skip(4)
	end
	event.ResetCamera(1, 3.1415927)
	event.Finish()
	event.SetFadeIn(15)
end

--- Program 551.
script[551] = function()
	local player_chara: s32 = 0
	local var1: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	local flag_4: s32 = 0
	local flag_5: s32 = 0
	local flag_6: s32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0cbe7543(0, -1, var1, player_chara, 0)
		end
		if at <= 2 then
			helper_0cbe7543(0, -1, var1, player_chara, 0)
		end
		if at <= 3 then
			helper_0cbe7543(0, -1, var1, player_chara, 0)
		end
		if at <= 4 then
			helper_0cbe7543(0, -1, var1, player_chara, 0)
		end
	end
	print("551-------------------------------------------------")
	player_chara = event.GetControlChrid() or player_chara
	var1 = 24
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var1)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_38711c58(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	flag = event.GetFlag(356) or flag
	if flag ~= 0 then
		event.MesMake_2(
			0,
			"Lin est partie [UNI00e9]tudier, hou. Elle\na dit qu'elle ne reviendrait pas\navant d'[UNI00ea]tre devenue un vrai sage.<page>Mais qui d[UNI00e9]cide qu'on est\nenfin un vrai sage ?<page>Je me moque qu'elle y parvienne ou\npas. Je veux juste qu'elle se\nd[UNI00e9]p[UNI00ea]che de revenir [UNI00e0] la maison hou."
		)
	else
		flag_2 = event.GetFlag(330) or flag_2
		if flag_2 ~= 0 then
			event.MesMake_2(0, "Prenez soin de Lin, d'accord ?\nEt faites attention, houuu.")
		else
			flag_3 = event.GetFlag(324) or flag_3
			if flag_3 ~= 0 then
				event.MesMake_2(0, "Plus vite, plus vite !<page>Donnez-moi une boulette,\nvite, hou !")
			else
				flag_4 = event.GetFlag(317) or flag_4
				if flag_4 ~= 0 then
					event.MesMake_2(0, "Vous ne vous [UNI00ea]tes pas encore\nprocur[UNI00e9] ce plat miracle ?")
					helper_0cbe7543(0, -1, var1, player_chara, 0)
					if vm.skipping() then
						return skip(2)
					end
					event.MesMake_2(0, "Pikidiots, houu, nininuls !\nVous n'[UNI00ea]tes bons [UNI00e0] rien, houuu !")
				else
					flag_5 = event.GetFlag(320) or flag_5
					if flag_5 ~= 0 then
						event.MesMake_2(0, 'Vous n\'avez toujours pas la, hou,\n "fleur de vent-blanc" ?')
						helper_0cbe7543(0, -1, var1, player_chara, 0)
						if vm.skipping() then
							return skip(3)
						end
						event.MesMake_2(
							0,
							"Pikidiots, houu, nininuls !\nVous n'[UNI00ea]tes bons [UNI00e0] rien, houuu !"
						)
					else
						flag_6 = event.GetFlag(306) or flag_6
						if flag_6 ~= 0 then
							event.MesMake_2(
								0,
								"Hou, le Restaurant de Lao Chao\nn'est pas remis en [UNI00e9]tat houuu ?"
							)
							helper_0cbe7543(0, -1, var1, player_chara, 0)
							if vm.skipping() then
								return skip(4)
							end
							event.MesMake_2(
								0,
								"Pikidiots, houu, nininuls !\nVous n'[UNI00ea]tes bons [UNI00e0] rien, houuu !"
							)
						else
							event.MesMake_2(0, "Amenez un docteur, vite ! houu.\nLe plus vite possible, houu.")
						end
					end
				end
			end
		end
	end
	helper_0cbe7543(0, -1, var1, player_chara, 0)
	if vm.skipping() then
		return skip(5)
	end
end

--- Program 1000.
script[1000] = function()
	local var0: s32 = 0
	local player_chara: s32 = 0
	local var2: f32 = 0
	local var4: f32 = 0
	local var5: f32 = 0
	local var7: f32 = 0
	local var8: f32 = 0
	local skip: (number) -> ...any
	function skip(at: number)
		if at <= 1 then
			helper_0cbe7543(0, -1, var0, player_chara, 0)
		end
	end
	print("KITA-------------------------------\n")
	var0 = event.GetEventData_2(13) or var0
	player_chara = event.GetControlChrid() or player_chara
	do
		local out1, _, out3 = event.GetCharaPos(player_chara)
		var2 = out1 or var2
		var4 = out3 or var4
	end
	do
		local out1, _, out3 = event.GetCharaPos(var0)
		var5 = out1 or var5
		var7 = out3 or var7
	end
	var8 = event.GetRotLookPos(var5 - var2, var7 - var4) or var8
	helper_38711c58(player_chara, var8)
	if vm.skipping() then
		return skip(1)
	end
	event.SetCharaRot(player_chara, 0.0, var8, 0.0)
	event.SetMotion(player_chara, "立ち")
	event.SetMesShippo(0, 1)
	event.SetMesPreset(0, 0)
	event.MesMake_2(0, "Bonjouuuur.\nBeau temps, non ?")
	helper_0cbe7543(0, -1, var0, player_chara, 0)
	if vm.skipping() then
		return skip(2)
	end
end

--- Program 13040.
script[13040] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 0)
	event.SetFlag(306, 0)
	event.SetFlag(324, 0)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_b6c190ae()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13060.
script[13060] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 1)
	event.SetFlag(306, 0)
	event.SetFlag(324, 0)
	event.SetFlag(330, 0)
	event.SetNpcStatus(6, 128)
	event.SetNpcStatus(6, 1)
	helper_56b874f1()
	helper_b6b83631()
	if vm.skipping() then
		return skip(1)
	end
	event.MapJump(-1, "g02", 503)
	if vm.wait() then
		return skip(2)
	end
end

--- Program 13280.
script[13280] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(304, 1)
	event.SetFlag(306, 1)
	event.SetFlag(324, 1)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_45424ea1()
	if vm.skipping() then
		return skip(1)
	end
end

--- Program 13300.
script[13300] = function()
	local skip: (number) -> ...any
	function skip(at: number) end
	event.SetFlag(324, 1)
	event.SetFlag(330, 0)
	helper_56b874f1()
	helper_4744b117()
	if vm.skipping() then
		return skip(1)
	end
end

return script
