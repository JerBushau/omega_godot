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
