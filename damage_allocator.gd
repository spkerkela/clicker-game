extends Node

onready var timer = $Timer
var targets = []

var min_damage = 0
var max_damage = 0

func _add_target(target):
	targets.append(target)
	
func _remove_target(target):
	targets.erase(target)

func initialize(boss : Boss):
	min_damage = boss.min_damage
	max_damage = boss.max_damage
	timer.wait_time = boss.attack_speed

func _ready():
	pass

func _stop():
	timer.stop()

func start():
	timer.start()

func _on_Timer_timeout():
	var target_count = len(targets)
	if target_count > 0:
		var damage = floor(rand_range(min_damage, max_damage))
		var target_index = randi() % target_count
		targets[target_index].call("_take_damage", damage)
