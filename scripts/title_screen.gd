extends CanvasLayer


@onready var ttile: Label = $Control/Panel/VBoxContainer/Label
@onready var start: Button = $Control/Panel/VBoxContainer/Start
@onready var quit: Button = $Control/Panel/VBoxContainer/Quit


func _ready() -> void:
	start.pressed.connect(on_start)
	quit.pressed.connect(get_tree().quit)
	start.grab_focus()


func on_start() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/counter.tscn")
