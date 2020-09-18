extends Node2D

onready var tween = $Tween
onready var text = $RichTextLabel

func _ready():
	var endColor = text.modulate
	endColor.a = 0
	tween.interpolate_property(text, "rect_position", text.rect_position, text.rect_position +  Vector2(0, -60), 2, Tween.EASE_OUT)
	tween.interpolate_property(text, "modulate", text.modulate, endColor, 2, Tween.TRANS_LINEAR)
	tween.start()
	pass # Replace with function body.

func _on_Timer_timeout():
	queue_free()
