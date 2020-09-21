extends Resource
class_name Equippable

enum EquipSlot {
	MAIN_HAND,
	OFF_HAND,
	TWO_HAND,
	ONE_HAND
}

export var description : String
export(EquipSlot) var slot
export var min_damage : int
export var max_damage : int
export var attack_speed : float

func get_dps():
	return stepify(((min_damage + max_damage) / 2) / attack_speed, 0.01)
