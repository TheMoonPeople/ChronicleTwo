--!strict
-- Shared event helper used by 2 scripts, translated by tools/luau/stb2luau.

local vm = require("@lib/vm")

--- Helper function.
local function helper_2a88c5a8(arg0: s32, arg1: s32)
	local skip: (number) -> ...any
	function skip(at: number) end
	if vm.skipping() then
		return skip(1)
	end
	if arg1 == 1 then
		event.MesMake_2(
			arg0,
			"Revoir le chemin de fer Noirpierre\ntraverser tout le continent est un\nr[UNI00ea]ve que Need et moi partageons.<page>On peut compter sur ton aide, hein ?"
		)
	end
	if arg1 == 2 then
		event.MesMake_2(
			arg0,
			"S'ils d[UNI00e9]couvrent de la zelmite, je\nserai tr[UNI00e8]s occup[UNI00e9] moi aussi. Ouais,\nje vais creuser jour et nuit !!!"
		)
	end
	if arg1 == 3 then
		event.MesMake_2(arg0, "Il doit y avoir tant de plantes\nqu'on ne conna[UNI00ee]t pas encore.")
	end
	if arg1 == 4 then
		event.MesMake_2(
			arg0,
			"H[UNI00e9] ! Alors, cette chasse [UNI00e0] la\nzelmite ? Si je peux faire quoi\nque ce soit, appelle-moi."
		)
	end
	if arg1 == 5 then
		event.MesMake_2(
			arg0,
			"Peindre des portraits est un art\ncomplexe. Le ma[UNI00ee]triser prend toute\nune vie, mais [UNI00e7]a en vaut la peine."
		)
	end
	if arg1 == 6 then
		event.MesMake_2(
			arg0,
			"Tu peux passer ton temps [UNI00e0] chercher\nde la zelmite si tu veux. Mais fais\nattention [UNI00e0] toi, gamin."
		)
	end
	if arg1 == 7 then
		event.MesMake_2(
			arg0,
			"Je serai un jour le plus grand\ncuisinier au monde, et l[UNI00e0], tu auras\nun repas gratuit quand tu voudras."
		)
	end
	if arg1 == 8 then
		event.MesMake_2(
			arg0,
			"Enfin, le chemin de fer Noirpierre\nva s'[UNI00e9]tendre au reste du monde.\nComme c'est excitant !"
		)
	end
	if arg1 == 9 then
		event.MesMake_2(arg0, "H[UNI00e9], [UNI00e7]a roule ? Moi, c'est l'top !")
	end
	if arg1 == 10 then
		event.MesMake_2(arg0, "La Mine de zelmite est un endroit\nterrifiant. Reste toujours sur\ntes gardes.")
	end
	if arg1 == 11 then
		event.MesMake_2(arg0, "Je prie pour ta s[UNI00e9]curit[UNI00e9]...")
	end
	if arg1 == 12 then
		event.MesMake_2(arg0, "Si un jour tu as envie de pain,\ntu sauras o[UNI00f9] me trouver.")
	end
	if arg1 == 13 then
		event.MesMake_2(arg0, "[UNI00c7]a t'emballe vraiment cette\naventure, hein ?")
	end
	if arg1 == 14 then
		event.MesMake_2(arg0, "Si je peux t'aider en quoi que ce\nsoit, n'h[UNI00e9]site pas [UNI00e0] me demander.")
	end
	if arg1 == 15 then
		event.MesMake_2(arg0, "Alors, t'as un scoop ? T'as\nvu des gros durs dans cette mine ?")
	end
	if arg1 == 16 then
		event.MesMake_2(
			arg0,
			"Je vais d[UNI00e8]s maintenant aider Need\net C[UNI00e9]dric [UNI00e0] reconstruire le monde.\nOn doit tous travailler ensemble."
		)
	end
	if arg1 == 17 then
		event.MesMake_2(
			arg0,
			"Je voulais te dire... je sais que\nla Mine de zelmite est un endroit\ndangereux. Ne prends aucun risque."
		)
	end
	if arg1 == 18 then
		event.MesMake_2(arg0, "Je prie pour que le monde vive\nenfin en paix.")
	end
	if arg1 == 19 then
		event.MesMake_2(
			arg0,
			"Si la voie ferr[UNI00e9]e Noirpierre couvre\nle monde entier, on va d[UNI00e9]couvrir\ndes tas de super nouveaux endroits."
		)
	end
	if arg1 == 20 then
		event.MesMake_2(
			arg0,
			"J'ai h[UNI00e2]te de d[UNI00e9]couvrir les nouveaux\nhauts-lieux de la p[UNI00ea]che qu'a [UNI00e0]\noffrir le monde. [UNI00c7]a sera trop top."
		)
	end
	if arg1 == 21 then
		event.MesMake_2(
			arg0,
			"J'aimerais tant que Fabio\ns'int[UNI00e9]resse un peu [UNI00e0] autre chose\nque la p[UNI00ea]che."
		)
	end
	if arg1 == 22 then
		event.MesMake_2(arg0, "Cette Mine de zelmite ne m'inspire\npas confiance. Sois prudent, OK ?")
	end
	if arg1 == 23 then
		event.MesMake_2(
			arg0,
			"Si la Voie ferr[UNI00e9]e Noirpierre\ns'[UNI00e9]tend au monde entier, j'irai\npeut-[UNI00ea]tre aussi voyager."
		)
	end
	if arg1 == 24 then
		event.MesMake_2(
			arg0,
			"Ne dis pas le contraire. Je sais\nque tu as fait plein de trucs hyper\ncool. Viens m'en parler un jour !"
		)
	end
	if arg1 == 25 then
		event.MesMake_2(
			arg0,
			'Quand la voie ferr[UNI00e9]e Noirpierre\nsera termin[UNI00e9]e, j\'adorerais aller \naux "Confins de la Terre".'
		)
	end
end

return helper_2a88c5a8
