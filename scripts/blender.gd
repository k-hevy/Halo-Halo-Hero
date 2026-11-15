class_name Blender

extends Area2D

enum State { EMPTY, FILLED, BLENDING, DONE } 
var state := State.EMPTY


@export var data: Ingredient
@export var item_scene: PackedScene


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		match state:
			State.EMPTY: 
				print("ENTER ICE")
			State.FILLED:
				$BlendTimer.start()
				state = State.BLENDING
			State.BLENDING: 
				print("BLENDING NOT DONE")
			State.DONE: 
				spawn_ice()
				


func _on_blend_timer_timeout() -> void:
	state = State.DONE
	print("DONE")


func add_ice(ingredient: Ingredient) -> bool:
	if ingredient.layer != Ingredient.Layer.RAW:
		print("thhats not ice")
		return false
		
	if state == State.FILLED:
		print("thhis alreadty has ice")
		return false
		
	state = State.FILLED
	print("FILLED")
	return true


func spawn_ice() -> void:
	var shaved_iced := item_scene.instantiate() as IngredientItem
	shaved_iced.source = self
	shaved_iced.data = data
	shaved_iced.global_position = global_position
	get_tree().current_scene.add_child(shaved_iced)
	state = State.EMPTY


func take_back() -> void:
	state = State.DONE
