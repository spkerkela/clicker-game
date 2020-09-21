extends Node2D

const CombatText = preload("res://combat_effect_text.tscn")
onready var body = $KinematicBody2D

signal dead
signal healed
signal attack_boss

onready var timer = $Timer
onready var icon = $KinematicBody2D/Sprite
onready var dps_label = $DPS

var damage = 0
var speed = 0

var stats : Stats

func _ready():
	pass

func equip(weapon : Equippable):
	damage = rand_range(weapon.min_damage, weapon.max_damage)
	timer.stop()
	timer.wait_time = weapon.attack_speed
	dps_label.text = str(weapon.get_dps())
	timer.start()

func initialize(stats : Stats, weapon : Equippable):
	damage = rand_range(weapon.min_damage, weapon.max_damage)
	body.initialize(stats.hp)
	timer.wait_time = weapon.attack_speed
	icon = stats.icon
	timer.start()
	dps_label.text = str(weapon.get_dps())
	
func _is_alive():
	return body.alive

func _take_damage(damage):
	body._take_damage(damage)

func _heal(amount):
	body._heal(amount)

func _get_health():
	return body.health

func _on_KinematicBody2D_dead(_t):
	timer.stop()
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


func _on_Timer_timeout():
	emit_signal("attack_boss", damage)
