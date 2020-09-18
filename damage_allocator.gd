extends Node

var targets = []

func _add_target(target):
	targets.append(target)
	
func _remove_target(target):
	targets.erase(target)

func _ready():
	pass

func _on_Timer_timeout():
	var target_count = len(targets)
	if target_count > 0:
		var damage = floor(rand_range(5, 30))
		var target_index = randi() % target_count
		targets[target_index].call("_take_damage", damage)
