class_name Bowl
extends Area2D

signal dropped_on_customer(customer: Customer)

const LAYER_HEIGHT := 4.0
const LAYER_WIDTH := 40.0  
var dragging := false
var grab_offset := Vector2.ZERO
var home: Vector2
var contents: Array[Ingredient] = []


func _ready() -> void:
	home = global_position
	var rect: ColorRect = $ColorRect
	$Layers.position = Vector2(
		rect.position.x + rect.size.x,
		rect.position.y + rect.size.y
	)


func _process(_delta: float) -> void:
	if dragging:
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			_drop()
		else:
			global_position = get_global_mouse_position() + grab_offset
	else:
		global_position = home


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		dragging = true
		grab_offset = global_position - get_global_mouse_position()


func _drop() -> void:
	dragging = false
	for area in get_overlapping_areas():
		if area is Customer:
			dropped_on_customer.emit(area)
			break;
	global_position = home


func add_ingredient(ingredient: Ingredient) -> bool:
	if ingredient.layer == Ingredient.Layer.RAW:
		return false
	if ingredient.layer == Ingredient.Layer.DRIZZLE and !has_base():
		print("add ice first")
		return false
		
	contents.append(ingredient)
	var r:= ColorRect.new()
	r.color = ingredient.color
	r.size = Vector2(LAYER_WIDTH, LAYER_HEIGHT)
	r.position = Vector2(-LAYER_WIDTH, -LAYER_HEIGHT * contents.size()) 
	$Layers.add_child(r)
	return true


func has_base() -> bool:
	for ingredient in contents:
		if ingredient.layer == Ingredient.Layer.BASE:
			return true;
	return false;


func reset() -> void:
	contents.clear()
	for content in $Layers.get_children():
		content.queue_free()
