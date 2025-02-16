// Noises made when hit while typing.
var/global/list/hit_appends = list("-OOF", "-ACK", "-UGH", "-HRNK", "-HURGH", "-GLORF")

// Some scary sounds.
var/global/list/scarySounds = list(
	'sound/weapons/thudswoosh.ogg',
	'sound/weapons/Taser.ogg',
	'sound/weapons/armbomb.ogg',
	'sound/voice/hiss1.ogg',
	'sound/voice/hiss2.ogg',
	'sound/voice/hiss3.ogg',
	'sound/voice/hiss4.ogg',
	'sound/voice/hiss5.ogg',
	'sound/voice/hiss6.ogg',
	'sound/effects/Glassbr1.ogg',
	'sound/effects/Glassbr2.ogg',
	'sound/effects/Glassbr3.ogg',
	'sound/items/Welder.ogg',
	'sound/items/Welder2.ogg',
	'sound/machines/airlock.ogg',
	'sound/effects/clownstep1.ogg',
	'sound/effects/clownstep2.ogg'
)

// Reference list for disposal sort junctions. Filled up by sorting junction's New()
var/global/list/tagger_locations = list()

var/global/list/station_prefixes = list("", "Imperium", "Heretical", "Cuban",
	"Psychic", "Elegant", "Common", "Uncommon", "Rare", "Unique",
	"Houseruled", "Religious", "Atheist", "Traditional", "Houseruled",
	"Mad", "Super", "Ultra", "Secret", "Top Secret", "Deep", "Death",
	"Zybourne", "Central", "Main", "Government", "Uoi", "Fat",
	"Automated", "Experimental", "Augmented")

var/global/list/station_names = list("", "Stanford", "Dwarf", "Alien",
	"Aegis", "Death-World", "Rogue", "Safety", "Paranoia",
	"Explosive", "North", "West", "East", "South", "Slant-ways",
	"Widdershins", "Rimward", "Expensive", "Procreatory", "Imperial",
	"Unidentified", "Immoral", "Carp", "Orc", "Pete", "Control",
	"Nettle", "Class", "Crab", "Fist", "Corrogated", "Skeleton",
	"Gentleman", "Capitalist", "Communist", "Bear", "Beard", "Space",
	"Star", "Moon", "System", "Mining", "Research", "Supply", "Military",
	"Orbital", "Battle", "Science", "Asteroid", "Home", "Production",
	"Transport", "Delivery", "Extraplanetary", "Orbital", "Correctional",
	"Robot", "Hats", "Pizza"
)

var/global/list/station_suffixes = list("Station", "Frontier",
	"Death-trap", "Space-hulk", "Lab", "Hazard", "Junker",
	"Fishery", "No-Moon", "Tomb", "Crypt", "Hut", "Monkey", "Bomb",
	"Trade Post", "Fortress", "Village", "Town", "City", "Edition", "Hive",
	"Complex", "Base", "Facility", "Depot", "Outpost", "Installation",
	"Drydock", "Observatory", "Array", "Relay", "Monitor", "Platform",
	"Construct", "Hangar", "Prison", "Center", "Port", "Waystation",
	"Factory", "Waypoint", "Stopover", "Hub", "HQ", "Office", "Object",
	"Fortification", "Colony", "Planet-Cracker", "Roost", "Airstrip")

var/global/list/greek_letters = list("Alpha", "Beta", "Gamma", "Delta",
	"Epsilon", "Zeta", "Eta", "Theta", "Iota", "Kappa", "Lambda", "Mu",
	"Nu", "Xi", "Omicron", "Pi", "Rho", "Sigma", "Tau", "Upsilon", "Phi",
	"Chi", "Psi", "Omega")

var/global/list/phonetic_alphabet = list("Alpha", "Bravo", "Charlie",
	"Delta", "Echo", "Foxtrot", "Golf", "Hotel", "India", "Juliet",
	"Kilo", "Lima", "Mike", "November", "Oscar", "Papa", "Quebec",
	"Romeo", "Sierra", "Tango", "Uniform", "Victor", "Whiskey", "X-ray",
	"Yankee", "Zulu")

var/global/list/numbers_as_words = list("One", "Two", "Three", "Four",
	"Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve",
	"Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen",
	"Eighteen", "Nineteen")

var/global/list/music_tracks = list(
	"Beyond" = /decl/music_track/ambispace,
	"Clouds of Fire" = /decl/music_track/clouds_of_fire,
	"Floating" = /decl/music_track/floating,
	"Endless Space" = /decl/music_track/endless_space,
	"Absconditus" = /decl/music_track/absconditus,
	"lasers rip apart the bulkhead" = /decl/music_track/lasers,
	"Comet Halley" = /decl/music_track/comet_haley,
	"Please Come Back Any Time" = /decl/music_track/elevator,
	"Human" = /decl/music_track/human,
	"Memories of Lysendraa" = /decl/music_track/lysendraa,
	"Marhaba" = /decl/music_track/marhaba,
	"Space Oddity" = /decl/music_track/space_oddity,
	"Treacherous Voyage" = /decl/music_track/treacherous_voyage,
	"every light is blinking at once" = /decl/music_track/elibao,
	"In Orbit" = /decl/music_track/inorbit,
	"Martian Cowboy" = /decl/music_track/martiancowboy,
	"Monument" = /decl/music_track/monument,
	"Wild Encounters" = /decl/music_track/wildencounters,
	"Torn" = /decl/music_track/torn,
	"Nebula" = /decl/music_track/nebula,
	"Robopup - Copy" = /decl/music_track/robopup/copy,
	"Robopup - Nothing Feels The Way It Should" = /decl/music_track/robopup/nothingfeelsthewayitshould,
	"Robopup - Program Me" = /decl/music_track/robopup/programme,
	"Robopup - Silly Girl" = /decl/music_track/robopup/sillygirl,
	"Robopup - Waste" = /decl/music_track/robopup/waste,
	"Incontinent Cell - Sex" = /decl/music_track/incontinent_cell/sex,
	"Rachel Lorin - Only 1" = /decl/music_track/seven_clouds/onlyone
)

var/global/list/engineering_music_tracks = list(
	"Night Shift" = /decl/music_track/nightshift
)

/proc/setup_music_tracks(var/list/tracks, var/specialization) //engineering, medical, expedition
	tracks = list()
	var/list/track_list = LAZYLEN(tracks) ? tracks : global.music_tracks
	switch(specialization)
		if("engineering")
			track_list.Add(engineering_music_tracks)
	for(var/track_name in track_list)
		var/track_path = track_list[track_name]
		tracks += new/datum/track(track_name, track_path)
	return tracks

GLOBAL_GETTER(cable_colors, /list, SetupCableColors())
/proc/SetupCableColors()
	. = list()

	var/list/valid_cable_coils = typesof(/obj/item/stack/cable_coil)
	for(var/ctype in list(
		/obj/item/stack/cable_coil/single,
		/obj/item/stack/cable_coil/cut,
		/obj/item/stack/cable_coil/cyborg,
		/obj/item/stack/cable_coil/fabricator,
		/obj/item/stack/cable_coil/random
	))
		valid_cable_coils -= typesof(ctype)

	var/special_name_mappings = list(/obj/item/stack/cable_coil = "Red")
	for(var/coil_type in valid_cable_coils)
		var/name = special_name_mappings[coil_type] || capitalize(copytext_after_last("[coil_type]", "/"))

		var/obj/item/stack/cable_coil/C = coil_type
		var/color = initial(C.color)

		.[name] = color
	. = sortTim(., /proc/cmp_text_asc)
