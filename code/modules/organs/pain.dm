/mob/proc/flash_pain(var/target)
	if(pain)
		var/matrix/M
		if(client && max(client.last_view_x_dim, client.last_view_y_dim) > 7)
			M = matrix()
			M.Scale(CEILING(client.last_view_x_dim/7), CEILING(client.last_view_y_dim/7))
		pain.transform = M
		animate(pain, alpha = target, time = 15, easing = ELASTIC_EASING)
		animate(pain, alpha = 0, time = 20)

// message is the custom message to be displayed
// power decides how much painkillers will stop the message
// force means it ignores anti-spam timer
/mob/living/proc/can_feel_pain(var/check_organ)
	return TRUE

/mob/living/proc/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	set waitfor = FALSE
	if(!message || stat || !can_feel_pain() || has_chemical_effect(CE_PAINKILLER, power))
		return
	power -= GET_CHEMICAL_EFFECT(src, CE_PAINKILLER)	//Take the edge off.
	var/decl/bodytype/bodytype = get_bodytype()
	if(bodytype)
		power *= bodytype.pain_mod
	// Excessive halloss is horrible, just give them enough to make it visible.
	if(!nohalloss && power)
		if(affecting)
			affecting.add_pain(CEILING(power/2))
		else
			adjustHalLoss(CEILING(power/2))
	flash_pain(min(round(2*power)+55, 255))

	// Anti message spam checks
	if(force || (message != last_pain_message) || (world.time >= next_pain_time))
		last_pain_message = message
		if(power >= 700)
			to_chat(src, "<span class='danger'><font size=3>[message]</font></span>")
		else if(power >= 400)
			to_chat(src, "<span class='danger'><font size=2>[message]</font></span>")
		else if(power >= 200)
			to_chat(src, "<span class='danger'>[message]</span>")
		else
			to_chat(src, "<span class='warning'>[message]</span>")
	next_pain_time = world.time + max(30 SECONDS - power, 10 SECONDS)

/mob/living/carbon/custom_pain(var/message, var/power, var/force, var/obj/item/organ/external/affecting, var/nohalloss)
	. = ..()
	if(.)
		var/force_emote = species.get_pain_emote(src, power)
		if(force_emote && prob(power))
			var/decl/emote/use_emote = usable_emotes[force_emote]
			if(!(use_emote.message_type == AUDIBLE_MESSAGE &&HAS_STATUS(src, STAT_SILENCE)))
				emote(force_emote)

/mob/living/carbon/human/proc/handle_pain()
	if(stat)
		return
	if(!can_feel_pain())
		return
	if(world.time < next_pain_time)
		return
	var/maxdam = 0
	var/obj/item/organ/external/damaged_organ = null
	for(var/obj/item/organ/external/E in get_external_organs())
		if(!E.can_feel_pain()) continue
		var/dam = E.get_damage()
		// make the choice of the organ depend on damage,
		// but also sometimes use one of the less damaged ones
		if(dam > maxdam && (maxdam == 0 || prob(70)) )
			damaged_organ = E
			maxdam = dam
	if(damaged_organ && has_chemical_effect(CE_PAINKILLER, maxdam))
		if(maxdam > 10 &&HAS_STATUS(src, STAT_PARA))
			ADJ_STATUS(src, STAT_PARA, -(round(maxdam/10)))
		if(maxdam > 50 && prob(maxdam / 5))
			drop_held_items()
		var/burning = damaged_organ.burn_dam > damaged_organ.brute_dam
		var/msg
		switch(maxdam)
			if(1 to 10)
				msg =  "Your [damaged_organ.name] [burning ? "burns" : "hurts"]."
			if(11 to 90)
				msg = "Your [damaged_organ.name] [burning ? "burns" : "hurts"] badly!"
			if(91 to 10000)
				msg = "OH GOD! Your [damaged_organ.name] is [burning ? "on fire" : "hurting terribly"]!"
		custom_pain(msg, maxdam, prob(10), damaged_organ, TRUE)
	// Damage to internal organs hurts a lot.
	for(var/obj/item/organ/internal/I in get_internal_organs())
		if(prob(1) && !((I.status & ORGAN_DEAD) || BP_IS_PROSTHETIC(I)) && I.damage > 5)
			var/obj/item/organ/external/parent = GET_EXTERNAL_ORGAN(src, I.parent_organ)
			if(parent)
				var/pain = 10
				var/message = "You feel a dull pain in your [parent.name]"
				if(I.is_bruised())
					pain = 25
					message = "You feel a pain in your [parent.name]"
				if(I.is_broken())
					pain = 50
					message = "You feel a sharp pain in your [parent.name]"
				src.custom_pain(message, pain, affecting = parent)

	if(prob(1))
		switch(getToxLoss())
			if(5 to 100)
				custom_pain("Your body stings slightly.", getToxLoss())
			if(100 to 150)
				custom_pain("Your body stings.", getToxLoss())
			if(150 to 250)
				custom_pain("Your body stings strongly.", getToxLoss())
			if(250 to 400)
				custom_pain("Your whole body hurts badly.", getToxLoss())
			if(400 to INFINITY)
				custom_pain("Your body aches all over, it's driving you mad!", getToxLoss())