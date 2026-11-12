class_name IngredientStation
extends Area2D

@export var data: Ingredient
@export var item_scene: PackedScene

func _ready() -> void:
	$ColorRect.color = data.color
	input_event.connect(_on_input_event)

func _on_input_event(_vp, event: InputEvent, _idx) -> void:
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		var item := item_scene.instantiate() as IngredientItem
		item.data = data
		get_tree().current_scene.add_child(item)
		item.global_position = get_global_mouse_position()
