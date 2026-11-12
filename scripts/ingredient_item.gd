class_name IngredientItem
extends Area2D

var data: Ingredient
var dragging:= true

func _ready() -> void:
	$ColorRect.color = data.color
	
func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()
		
func _input(event: InputEvent) -> void:
	if not dragging:
		return
	var mb := event as InputEventMouseButton
	if mb and not mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		dragging = false
		for area in get_overlapping_areas():
			if area is Bowl:
				area.add_ingredient(data)
				break
		queue_free()
