--!strict
-- Shared event helper used by 3 scripts, translated by tools/luau/stb2luau.

local helper_1c04a0eb = require("@lib/event/helper_1c04a0eb")
local helper_59a16271 = require("@lib/event/helper_59a16271")

--- Helper function.
local function helper_a2ef9c8d()
	local var0: s32 = 0
	local var1: s32 = 0
	local flag: s32 = 0
	local flag_2: s32 = 0
	local flag_3: s32 = 0
	print("IN go_shop_up()\n")
	var0 = event.get_triggered_event_data_2(14) or var0
	var1 = event.get_triggered_event_data_2(13) or var1
	print("talk_chara=", var0, "talk_chara_id=", var1, "\n")
	event.set_message_bubble_tail(0, 1)
	event.apply_message_window_preset(0, 0)
	event.open_message_window_2(0, "Bienvenue.")
	if var0 == 18 then
		event.open_message_window_2(
			0,
			"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
		)
	end
	if var0 == 4 then
		event.open_message_window_2(
			0,
			"[UNI00c7]a travaille dur, je vois ?\nIl te faut quelque chose ?<page>Ah mais, rien n'est gratuit.\nPas m[UNI00ea]me pour toi, Max."
		)
	end
	if var0 == 34 then
		event.open_message_window_2(
			0,
			"Il te faut plus d'[UNI00e9]l[UNI00e9]ments de\nG[UNI00e9]orama ?<page>Si tu n'as pas le temps d'aller en\nchercher toi-m[UNI00ea]me, peut-[UNI00ea]tre que\nl'argent r[UNI00e9]soudra tes probl[UNI00e8]mes."
		)
	end
	if var0 == 1012 then
		flag = event.get_save_flag(45) or flag
		if flag == 0 then
			event.open_message_window_2(
				0,
				"Bonjour, je suis apprentie boulang[UNI00e8]re\net je m'occupe de la boulangerie\npendant l'absence de Polly.<page>Je suis un peu nerveuse, mais [UNI00e7]a\npassera avec l'exp[UNI00e9]rience, je\nsuppose. Je ferai de mon mieux !"
			)
			event.set_save_flag(45, 1)
		end
	end
	if var0 == 1015 then
		flag_2 = event.get_save_flag(46) or flag_2
		if flag_2 == 0 then
			event.open_message_window_2(
				0,
				"On se ressemble peu mais...\nJe suis la petite s[UNI0153]ur de Milane.<page>Je tiens le magasin pendant son absence.\nEt je suis archi-nulle en armes !"
			)
			event.set_save_flag(46, 1)
		end
	end
	if var0 == 1018 then
		flag_3 = event.get_save_flag(47) or flag_3
		if flag_3 == 0 then
			event.open_message_window_2(
				0,
				"Tu ne t'y attendais pas ? N'importe\nqui serait surpris de voir ici un\nindividu habill[UNI00e9] de cette mani[UNI00e8]re.<page>Je suis bon ami avec le P[UNI00e8]re Bruno.\nJe le remplace pendant son voyage.\nAlors, que puis-je faire pour toi ?"
			)
			event.set_save_flag(47, 1)
		else
			event.open_message_window_2(
				0,
				"Aimerais-tu que les dieux te\npr[UNI00ea]tent leur puissance ? Alors,\nfais un don [UNI00e0] l'[UNI00e9]glise, je te prie."
			)
		end
	end
	if var1 ~= -1 then
		helper_1c04a0eb(var1, -1, 0, 0)
	end
	if var0 == 18 then
		helper_59a16271(15)
	end
	if var0 == 12 then
		helper_59a16271(1)
	end
	if var0 == 4 then
		helper_59a16271(6)
	end
	if var0 == 15 then
		helper_59a16271(0)
	end
	if var0 == 33 then
		helper_59a16271(4)
	end
	if var0 == 34 then
		helper_59a16271(31)
	end
	if var0 == 1012 then
		helper_59a16271(35)
	end
	if var0 == 1015 then
		helper_59a16271(36)
	end
	if var0 == 1018 then
		helper_59a16271(37)
	end
end

return helper_a2ef9c8d
