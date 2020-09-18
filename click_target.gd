extends Node2D

const CombatText = preload("res://combat_effect_text.tscn")
onready var body = $KinematicBody2D

# warning-ignore:unused_signal
signal dead
signal healed

func _ready():
	pass

func _is_alive():
	return body.alive

func _take_damage(damage):

	body._take_damage(damage)


func _heal(amount):
	body._heal(amount)

func _get_health():
	return body.health

func _on_KinematicBody2D_dead(t):
	emit_signal("dead", self)

func _on_KinematicBody2D_healed(amount):
	var dmg = CombatText.instance()
	var txt = dmg.get_node("RichTextLabel")
	txt.modulate = Color(0,1,0,1)
	txt.text = "+ " + str(amount)
	add_child(dmg)
	emit_signal("healed", amount)


func _on_KinematicBody2D_damaged(damage):
	var dmg = CombatText.instance()
	var txt = dmg.get_node("RichTextLabel")
	txt.modulate = Color(1,0,0,1)
	txt.text = "- " + str(damage)
	add_child(dmg)
