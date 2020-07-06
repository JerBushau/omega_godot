extends Node


# Ship
signal ship_damage_taken
signal ship_hp_change(hp)
signal ship_dead
# Ship weapon
signal fire
signal cease_fire
# Ship shield
signal activate_shield
signal deactivate_shield
# Ship drones
signal release_ship_drones
signal drone_cd_up

# Hedgelord
signal hedge_hp_change(hp)

# Boss2
signal boss2_hp_change(hp)


# Game
signal pause(is_paused)
signal title_complete
signal fade_to_black(cb)
signal fade_from_black(cb)
signal fade_complete(who)
signal level_over(winOrLose)


