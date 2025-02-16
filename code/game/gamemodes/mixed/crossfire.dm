/decl/game_mode/crossfire
	name = "Mercenary & Heist"
	round_description = "Mercenaries and raiders are preparing for a nice visit..."
	extended_round_description = "Nothing can possibly go wrong with lots of people and lots of guns, right?"
	uid = "crossfire"
	required_players = 25
	required_enemies = 6
	end_on_antag_death = FALSE
	associated_antags = list(
		/decl/special_role/raider,
		/decl/special_role/mercenary
	)
	require_all_templates = TRUE
	votable = FALSE