extends Node2D

var targets = []
var healing_power = 10

func _ready():
	pass # Replace with function body.

func _add_target(target):
	targets.append(target)

func _remove_target(target):
	targets.erase(target)

func _cast_heal():
	var target_count = len(targets)
	var lowest_health = 100
	var heal_target = null
	for target in targets:
		var target_health = target._get_health()
		if(target_health < lowest_health):
			lowest_health = target_health
			heal_target = target
	if heal_target != null:
		heal_target._heal(healing_power)
