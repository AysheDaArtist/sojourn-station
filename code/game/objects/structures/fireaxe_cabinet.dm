/obj/structure/fireaxecabinet
	name = "fire axe cabinet"
	desc = "There is small label that reads \"For Emergency use only\" along with details for safe use of the axe. As if."
	icon_state = "fireaxe"
	anchored = TRUE
	density = FALSE

	var/damage_threshold = 15
	var/open
	var/unlocked
	var/shattered
	var/obj/item/tool/fireaxe/fireaxe
	req_one_access = list(access_heads, access_engine)

/obj/structure/fireaxecabinet/attack_generic(mob/user, damage, attack_message, damagetype = BRUTE, attack_flag = ARMOR_MELEE, sharp = FALSE, edge = FALSE)
	attack_animation(user)
	playsound(user, 'sound/effects/Glasshit.ogg', 50, 1)
	visible_message(SPAN_DANGER("[user] [attack_message] \the [src]!"))
	if(damage_threshold > damage)
		to_chat(user, SPAN_DANGER("Your strike is deflected by the reinforced glass!"))
		return
	if(shattered)
		return
	shattered = TRUE
	unlocked = TRUE
	open = TRUE
	sanity_damage = 0.1 //Broken window theory
	playsound(user, 'sound/effects/Glassbr3.ogg', 100, 1)
	update_icon()

/obj/structure/fireaxecabinet/update_icon()
	cut_overlays()
	if(fireaxe)
		add_overlay(image(icon, "fireaxe_item"))
	if(shattered)
		add_overlay(image(icon, "fireaxe_window_broken"))
	else if(!open)
		add_overlay(image(icon, "fireaxe_window"))

/obj/structure/fireaxecabinet/New()
	..()
	fireaxe = new(src)
	update_icon()

/obj/structure/fireaxecabinet/attack_ai(mob/user)
	toggle_lock(user)

/obj/structure/fireaxecabinet/attack_hand(mob/user)
	if(!unlocked)
		to_chat(user, SPAN_WARNING("\The [src] is locked."))
		return
	toggle_open(user)

/obj/structure/fireaxecabinet/MouseDrop(over_object, src_location, over_location)
	if(over_object == usr)
		var/mob/user = over_object
		if(!istype(user))
			return

		if(!open)
			to_chat(user, SPAN_WARNING("\The [src] is closed."))
			return

		if(!fireaxe)
			to_chat(user, SPAN_WARNING("\The [src] is empty."))
			return

		fireaxe.forceMove(get_turf(user))
		user.put_in_hands(fireaxe)
		fireaxe = null
		update_icon()

	return

/obj/structure/fireaxecabinet/Destroy()
	if(fireaxe)
		fireaxe.forceMove(get_turf(src))
		fireaxe = null
	return ..()

/obj/structure/fireaxecabinet/attackby(obj/item/O, mob/user)

	if(istype(O, /obj/item/tool/multitool))
		toggle_lock(user)
		return

	if(istype(O, /obj/item/card/id))
		var/obj/item/card/id/ID = O
		if(has_access(list(), req_one_access, ID.GetAccess()))
			toggle_lock(user)
		else
			to_chat(user, SPAN_NOTICE("You try to unlock the cabinet, but nothing happens."))

	if(istype(O, /obj/item/tool/fireaxe))
		if(open)
			if(fireaxe)
				to_chat(user, SPAN_WARNING("There is already \a [fireaxe] inside \the [src]."))
			else if(user.unEquip(O))
				O.forceMove(src)
				fireaxe = O
				to_chat(user, SPAN_NOTICE("You place \the [fireaxe] into \the [src]."))
				update_icon()
			return

	if(O.force)
		user.setClickCooldown(10)
		attack_generic(user, O.force, "bashes")
		return

	return ..()

/obj/structure/fireaxecabinet/proc/toggle_open(mob/user)
	if(shattered)
		open = TRUE
		unlocked = TRUE
	else
		user.setClickCooldown(10)
		open = !open
		to_chat(user, "<span class='notice'>You [open ? "open" : "close"] \the [src].</span>")
	update_icon()

/obj/structure/fireaxecabinet/proc/toggle_lock(mob/user)


	if(open)
		return

	if(shattered)
		open = TRUE
		unlocked = TRUE
	else
		user.setClickCooldown(10)
		to_chat(user, "<span class='notice'>You begin [unlocked ? "enabling" : "disabling"] \the [src]'s maglock.</span>")

		if(!do_after(user, 20,src))
			return

		if(shattered)
			return

		unlocked = !unlocked
		playsound(user, 'sound/machines/lockreset.ogg', 50, 1)
		to_chat(user, "<span class = 'notice'>You [unlocked ? "disable" : "enable"] the maglock.</span>")

	update_icon()
