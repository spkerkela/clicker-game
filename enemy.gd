extends Node2D

const CombatText = preload("res://combat_effect_text.tscn")

onready var bar = $ProgressBar
onready var tween = $Tween
onready var name_label = $RichTextLabel
signal died
var health = 30000
var alive = true

func _ready():
	bar.max_value = health
	bar.value = health

func initialize(boss : Boss):
	alive = true
	health = boss.hp
	bar.max_value = boss.hp
	bar.value = boss.hp
	name_label.text = boss.name

func _update_bar():
	tween.interpolate_property(bar, "value", bar.value, health, 0.2, Tween.TRANS_LINEAR)
	tween.start()

func _take_damage(damage):
	if alive:
		var dmg = CombatText.instance()
		var txt = dmg.get_node("RichTextLabel")
		txt.modulate = Color(1, 0, 0, 1)
		txt.text = "-" + str(damage) 
		health -= damage
		add_child(dmg)
		_update_bar()
	if health <= 0 and alive:
		alive = false
		emit_signal("died")
