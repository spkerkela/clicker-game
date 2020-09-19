extends KinematicBody2D

onready var bar = $ProgressBar
signal dead
signal healed
signal damaged
onready var alive = true
onready var tween = $Tween
onready var anim = $AnimationPlayer
var health = 100
func _ready():
	bar.value = health

func _update_bar():
	tween.interpolate_property(bar, "value", bar.value, health, 0.1, Tween.TRANS_LINEAR)
	tween.start()

func _heal(amount):
	if alive:
		var temp_value = health
		health += amount
		if health > 100:
			health = 100
		var score = health - temp_value
		if(score > 0):
			anim.play("player_healed")
			emit_signal("healed", score)
		_update_bar()

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.is_pressed() and not event.is_echo():
		_heal(50)

func _take_damage(damage):
	health -= damage
	if health <= 0:
		health = 0
		alive = false
		anim.play("hero_killed", -1, 2)
		emit_signal("dead", self)
	else:
		anim.play("hero_attacked")
		emit_signal("damaged", damage)
	_update_bar()
