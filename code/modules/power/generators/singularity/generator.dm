/////SINGULARITY SPAWNER
/obj/machinery/the_singularitygen
	name = "gravitational singularity generator"
	desc = "An odd device which produces a gravitational singularity when set up."
	icon = 'icons/obj/engine/singularity.dmi'
	icon_state = "TheSingGen"
	anchored = 0
	density = 1
	use_power = POWER_USE_OFF
	matter = list(
		/decl/material/solid/exotic_matter = MATTER_AMOUNT_PRIMARY,
		/decl/material/solid/metal/steel = MATTER_AMOUNT_SECONDARY
	)

	var/energy = 0
	var/creation_type = /obj/singularity
	var/is_activated = FALSE

/obj/machinery/the_singularitygen/get_matter_amount_modifier()
	. = ..() * (1/HOLLOW_OBJECT_MATTER_MULTIPLIER) * 10 // Big solid chunk of matter.

/obj/machinery/the_singularitygen/Process()
	var/turf/T = get_turf(src)
	if(energy >= 200 && !is_activated)
		is_activated = TRUE
		var/atom/movable/overlay/animation = new(T)
		animation.master = src
		animation.pixel_x = -32
		animation.pixel_y = -32
		animation.layer = SINGULARITY_EFFECT_LAYER
		flick('icons/effects/singularity_effect.dmi', animation)
		addtimer(CALLBACK(src, PROC_REF(spawn_contained), T), 6 SECOND)
		QDEL_IN(animation, 7 SECOND)

/obj/machinery/the_singularitygen/proc/spawn_contained(turf/T)
	new creation_type(T || get_turf(src), 50)
	if(!QDELETED(src))
		qdel(src)

/obj/machinery/the_singularitygen/attackby(obj/item/W, mob/user)
	if(IS_WRENCH(W))
		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
		if(anchored)
			user.visible_message("[user.name] secures [src.name] to the floor.", \
				"You secure the [src.name] to the floor.", \
				"You hear a ratchet.")
		else
			user.visible_message("[user.name] unsecures [src.name] from the floor.", \
				"You unsecure the [src.name] from the floor.", \
				"You hear a ratchet.")
		return
	return ..()
