extends CanvasLayer

@onready var title: Label = $Control/Panel/VBoxContainer/Title
@onready var message: Label = $Control/Panel/VBoxContainer/Message
@onready var play_again: Button = $Control/Panel/VBoxContainer/PlayAgain
@onready var quit: Button = $Control/Panel/VBoxContainer/Quit

func _ready() -> void:
	if GameState.run_won:
		title.text = "You survived!"
		message.text = "Five days of El Niño, and the stand is still open."
	else:
		title.text = "Game Over"
		message.text = "Too many customers left unserved."
	play_again.pressed.connect(on_play_again)
	quit.pressed.connect(get_tree().quit)


func on_play_again() -> void:
	GameState.reset()
	get_tree().change_scene_to_file("res://scenes/counter.tscn")
