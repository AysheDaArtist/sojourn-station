/mob/living/simple/hostile/alien
	name = "alien hunter"
	desc = "Hiss!"
	icon = 'icons/mob/alien.dmi'
	icon_state = "alienh_running"
	icon_dead = "alien_l"
	icon_gib = "syndicate_gib"
	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"
	speed = -1
	meat_type = /obj/item/reagent_containers/snacks/meat/xenomeat
	maxHealth = 100
	health = 100
	harm_intent_damage = 5
	melee_damage_lower = 25
	melee_damage_upper = 25
	attacktext = "slashed"
	a_intent = I_HURT
	attack_sound = 'sound/weapons/bladeslice.ogg'
	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	unsuitable_atoms_damage = 15
	faction = "alien"
	environment_smash = 2
	status_flags = CANPUSH
	minbodytemp = 0
	heat_damage_per_tick = 20
	sanity_damage = 2


/mob/living/simple/hostile/alien/drone
	name = "alien drone"
	icon_state = "aliend_running"
	icon_dead = "aliend_l"
	health = 60
	melee_damage_lower = 15
	melee_damage_upper = 15

/mob/living/simple/hostile/alien/sentinel
	name = "alien sentinel"
	icon_state = "aliens_running"
	icon_dead = "aliens_l"
	health = 120
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'


/mob/living/simple/hostile/alien/queen
	name = "alien queen"
	icon_state = "alienq_running"
	icon_dead = "alienq_l"
	health = 250
	maxHealth = 250
	melee_damage_lower = 15
	melee_damage_upper = 15
	ranged = 1
	move_to_delay = 3
	projectiletype = /obj/item/projectile/neurotox
	projectilesound = 'sound/weapons/pierce.ogg'
	rapid = 1
	status_flags = 0
	sanity_damage = 4

/mob/living/simple/hostile/alien/queen/large
	name = "alien empress"
	icon = 'icons/mob/64x64.dmi'
	icon_state = "queen_s"
	icon_dead = "queen_dead"
	move_to_delay = 4
	maxHealth = 400
	health = 400

/obj/item/projectile/neurotox
	damage_types = list(BURN = 30)
	icon_state = "toxin"

/mob/living/simple/hostile/alien/death()
	..()
	visible_message("[src] lets out a waning guttural screech, green blood bubbling from its maw...")
	playsound(src, 'sound/voice/hiss6.ogg', 100, 1)