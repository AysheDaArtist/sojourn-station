/mob/living/carbon/human/proc/monkeyize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	stunned = 1
	icon = null
	invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.plane = plane
	animation.layer = ABOVE_MOB_LAYER
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	DEL_TRANSFORMATION_MOVEMENT_HANDLER(src)
	stunned = 0

	update_lying_buckled_and_verb_status()
	invisibility = initial(invisibility)

	if(!form.primitive_form) //If the creature in question has no primitive set, this is going to be messy.
		gib()
		return

	for(var/obj/item/W in src)
		drop_from_inventory(W)

	set_species(form.primitive_form)
	dna.SetSEState(MONKEYBLOCK,1)
	dna.SetSEValueRange(MONKEYBLOCK,0xDAC, 0xFFF)

	to_chat(src, "<B>You are now [species.name]. </B>")
	qdel(animation)
	return src

/mob/living/carbon/human/proc/humanize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	stunned = 1
	icon = null
	invisibility = 101
	var/atom/movable/overlay/animation = new /atom/movable/overlay( loc )
	animation.plane = plane
	animation.layer = ABOVE_MOB_LAYER
	animation.icon_state = "blank"
	animation.icon = 'icons/mob/mob.dmi'
	animation.master = src
	flick("h2monkey", animation)
	sleep(48)
	//animation = null

	DEL_TRANSFORMATION_MOVEMENT_HANDLER(src)
	stunned = 0

	update_lying_buckled_and_verb_status()
	invisibility = initial(invisibility)

	set_species("Human", null, FALSE)
	dna.SetSEState(MONKEYBLOCK,0)

	to_chat(src, "<B>You are now [species.name]. </B>")
	qdel(animation)
	return src

/mob/new_player/AIize()
	spawning = 1
	return ..()

/mob/proc/AIize(move=1)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	if(client)
		sound_to(src, sound(null, repeat = 0, wait = 0, volume = 85, channel = GLOB.lobby_sound_channel))
	var/mob/living/silicon/ai/O = new (loc, base_law_type,,1)//No MMI but safety is in effect.
	O.aiRestorePowerRoutine = 0

	if(mind)
		mind.transfer_to(O)
		O.mind.original = O
	else
		O.key = key

	if(move)
		var/obj/new_location = null
		for(var/turf/sloc in get_datum_spawn_locations("AI"))
			if(locate(/obj/structure/AIcore) in sloc)
				continue
			new_location = sloc
		if (!new_location)
			for(var/turf/sloc in get_datum_spawn_locations("triai"))
				if(locate(/obj/structure/AIcore) in sloc)
					continue
				new_location = sloc
		if (!new_location)
			to_chat(O, "Oh god sorry we can't find an unoccupied AI spawn location, so we're spawning you on top of someone.")
			new_location = pick_spawn_location("AI")

		O.forceMove(new_location)

	O.on_mob_init()

	O.add_ai_verbs()

	O.rename_self("ai",1)
	qdel(src)
	return O

//human -> robot
/mob/living/proc/Robotize(posibrain = FALSE)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	var/mob/living/silicon/robot/O = new /mob/living/silicon/robot( loc )

	if(mind)		//TODO
		mind.transfer_to(O)
		if(O.mind.assigned_role == "Robot")
			O.mind.original = O
		else if(mind && mind.antagonist.len)
			O.mind.store_memory("In case you look at this after being borged, the objectives are only here until I find a way to make them not show up for you, as I can't simply delete them without screwing up round-end reporting. --NeoFite")
	else
		O.key = key

	O.loc = loc
	O.job = "Robot"
	if(O.mind.role_alt_title == "Robot")
		posibrain = TRUE
	if(!posibrain)
		O.mmi = new /obj/item/device/mmi(O)
	else O.mmi = new /obj/item/device/mmi/digital/posibrain
	O.mmi.transfer_identity(src)

	callHook("borgify", list(O))
	O.Namepick()

	qdel(src)
	return O

/mob/living/proc/slimeize(adult as num, reproduce as num)
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	var/mob/living/carbon/slime/new_slime
	if(reproduce)
		var/number = pick(14;2,3,4)	//reproduce (has a small chance of producing 3 or 4 offspring)
		var/list/babies = list()
		for(var/i=1,i<=number,i++)
			var/mob/living/carbon/slime/M = new/mob/living/carbon/slime(loc)
			M.nutrition = round(nutrition/number)
			step_away(M,src)
			babies += M
		new_slime = pick(babies)
	else
		new_slime = new /mob/living/carbon/slime(loc)
		if(adult)
			new_slime.is_adult = 1
		else
	new_slime.key = key

	to_chat(new_slime, "<B>You are now a slime. Skreee!</B>")
	qdel(src)
	return

/mob/proc/corgize()
	if (HAS_TRANSFORMATION_MOVEMENT_HANDLER(src))
		return
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(src)
	canmove = 0
	icon = null
	invisibility = 101

	var/mob/living/simple/corgi/new_corgi = new /mob/living/simple/corgi (loc)
	new_corgi.a_intent = I_HURT
	new_corgi.key = key

	to_chat(new_corgi, "<B>You are now a Corgi. Yap Yap!</B>")
	qdel(src)
	return

/mob/proc/Animalize()

	var/list/mobtypes = typesof(/mob/living/simple)
	var/mobpath = input("Which type of mob should [src] turn into?", "Choose a type") in mobtypes

	var/mob/new_mob = new mobpath(src.loc)

	new_mob.key = key
	to_chat(new_mob, "You feel more... animalistic")

	qdel(src)

/* Certain mob types have problems and should not be allowed to be controlled by players.
 *
 * This proc is here to force coders to manually place their mob in this list, hopefully tested.
 * This also gives a place to explain -why- players shouldnt be turn into certain mobs and hopefully someone can fix them.
 */
/mob/proc/safe_animal(var/MP)

//Bad mobs! - Remember to add a comment explaining what's wrong with the mob
	if(!MP)
		return 0	//Sanity, this should never happen.

	if(ispath(MP, /mob/living/simple/space_worm))
		return 0 //Unfinished. Very buggy, they seem to just spawn additional space worms everywhere and eating your own tail results in new worms spawning.

//Good mobs!
	if(ispath(MP, /mob/living/simple/cat))
		return 1
	if(ispath(MP, /mob/living/simple/corgi))
		return 1
	if(ispath(MP, /mob/living/simple/crab))
		return 1
	if(ispath(MP, /mob/living/simple/hostile/carp))
		return 1
	if(ispath(MP, /mob/living/simple/mushroom))
		return 1
	if(ispath(MP, /mob/living/simple/hostile/tomato))
		return 1
	if(ispath(MP, /mob/living/simple/mouse))
		return 1 //It is impossible to pull up the player panel for mice (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple/hostile/bear))
		return 1 //Bears will auto-attack mobs, even if they're player controlled (Fixed! - Nodrak)
	if(ispath(MP, /mob/living/simple/parrot))
		return 1 //Parrots are no longer unfinished! -Nodrak

	//Not in here? Must be untested!
	return 0

