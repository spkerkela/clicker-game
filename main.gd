extends Node2D

const Clickable = preload("res://click_target.tscn")
const DamageAllocator = preload("res://damage_allocator.tscn")
const Healer = preload("res://healer.tscn")
onready var score_label = $Score

export var base_class : Resource
export var base_item : Resource

export(Array, Resource) var bosses

var damage_allocators = []
var healers = []
var score = 0
var group_members_alive = 0
var bosses_killed = 0
var bosses_total = 0

onready var enemy = $Enemy
onready var game_over_popup = $PopupMenu
onready var timer = $Timer

func _ready():
	timer.start()
	enemy.initialize(bosses[0])
	bosses_total = len(bosses)
	var melee_dps = base_class
	var weapon = base_item
	score_label.text = str(score)
	healers.append(Healer.instance())
	var damager = DamageAllocator.instance()
	damage_allocators.append(damager)
	for damage_allocator in damage_allocators:
		add_child(damage_allocator)
		damage_allocator.initialize(bosses[0])
	for healer in healers:
		add_child(healer)
	for x in range (100, 1000, 100):
		for y in range (100, 600, 100):
			var clickable = Clickable.instance()
			clickable.add_to_group("allies")
			clickable.position.x = x
			clickable.position.y = y
			add_child(clickable)
			for damage_allocator in damage_allocators:
				damage_allocator._add_target(clickable)
			for healer in healers:
				healer._add_target(clickable)
			clickable.connect("dead", self, "_remove_target")
			clickable.connect("healed", self, "_add_score")
			clickable.connect("attack_boss", self, "_attack_boss")
			clickable.initialize(melee_dps, weapon)
			group_members_alive += 1

func _attack_boss(damage):
	enemy._take_damage(damage)

func _add_score(heal_score):
	score += heal_score
	score_label.text = str(score)

func _remove_target(target):
	for healer in healers:
		healer._remove_target(target)
	for damage_allocator in damage_allocators:
		damage_allocator._remove_target(target)
	
	group_members_alive -= 1
	if group_members_alive <= 0:
		_end_game("You were defeated!")

func _end_game(text):
	game_over_popup.get_node("VBoxContainer/Game Over Text").text = text
	game_over_popup.show()


func _add_damage_allocator():
	var allocator = DamageAllocator.instance()
	for child in get_children():
		if child.is_in_group("allies"):
			if child._is_alive():
				allocator._add_target(child)
	damage_allocators.append(allocator)
	add_child(allocator)
	allocator.initialize(bosses[bosses_killed])


func _add_healer():
	var healer = Healer.instance()
	for child in get_children():
		if child.is_in_group("allies"):
			if child._is_alive():
				healer._add_target(child)
	healers.append(healer)
	add_child(healer)

func _allocate_loot():
	var loot = bosses[bosses_killed].loot
	var receiver_count = 0
	var allies = []
	for child in get_children():
		if child.is_in_group("allies") and child._is_alive():
			receiver_count += 1
			allies.append(child)
	if len(allies) <= 0:
		return
	for l in loot:
		var receiver_index = randi() % receiver_count
		allies[receiver_index].equip(l)

func _on_Enemy_died():
	_allocate_loot()
	bosses_killed += 1
	timer.stop()
	for damage_allocator in damage_allocators:
		damage_allocator._stop()
	if bosses_killed >= bosses_total:
		_end_game("You defeated the monster!")
	else:
		yield(get_tree().create_timer(5), "timeout")
		enemy.initialize(bosses[bosses_killed])
		for damage_allocator in damage_allocators:
			damage_allocator.initialize(bosses[bosses_killed])
			damage_allocator.start()
		timer.start()

func _on_Restart_Button_pressed():
	get_tree().reload_current_scene()


func _on_Back_To_Menu_Button_pressed():
	get_tree().change_scene("res://start.tscn")
