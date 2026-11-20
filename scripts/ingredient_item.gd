class_name IngredientItem
extends Area2D

var data : Ingredient
var dragging := true
var source : Blender

func _ready() -> void:
	$Label.text = data.display_name
	$ColorRect.color = data.color


func _process(_delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	
	if not dragging:
		return
	
	var accepted := false
	var mb := event as InputEventMouseButton
	if mb and not mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		dragging = false
		
		for area in get_overlapping_areas():
			
			if area is Bowl:
				if area.add_ingredient(data):
					accepted = true
					queue_free()
				break
				
			elif area is Blender:
				if area.add_ice(data):
					accepted = true
					queue_free()
				break
				
		if !accepted and source != null:
			source.take_back()
			
		queue_free()
