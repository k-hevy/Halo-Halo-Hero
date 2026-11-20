class_name DialogueBox
extends CanvasLayer

signal finished

@onready var label: RichTextLabel = $Panel/Control/RichTextLabel

var lines: Array[String] = []
var current_index: int = 0


func _ready() -> void:
	hide()
	set_process_unhandled_input(false)


func start(new_lines: Array[String]) -> void:
	if new_lines.is_empty():
		finished.emit()
		return
	
	lines = new_lines
	current_index = 0
	show_line()
	show()
	set_process_unhandled_input(true)


func show_line() -> void:
	if current_index < lines.size():
		label.text = lines[current_index]


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	
	var mb := event as InputEventMouseButton
	if mb and mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled()
		advance_dialogue()


func advance_dialogue() -> void:
	current_index += 1
	
	if current_index < lines.size():
		show_line()
	else:
		hide()
		set_process_unhandled_input(false)
		finished.emit()
