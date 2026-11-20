extends CanvasLayer

@onready var day_label: Label = $Control/SummaryPanel/VBoxContainer/DayNumber
@onready var money_earned_label: Label = $Control/SummaryPanel/VBoxContainer/EarnedToday
@onready var current_money_label: Label = $Control/SummaryPanel/VBoxContainer/TotalMoney
@onready var next_day_button: Button = $Control/SummaryPanel/VBoxContainer/NextDay

func _ready() -> void:
	hide()
	EventBus.day_ended.connect(on_day_ended)
	next_day_button.pressed.connect(on_next_day)
	

func on_day_ended() -> void:
	day_label.text = "Day: " + str(GameState.current_day)
	money_earned_label.text = "Money Earned: "+ str(GameState.get_earned_today())
	current_money_label.text =  "Current Money: " + str(GameState.currentMoney) 
	show()


func on_next_day() -> void:
	if GameState.is_last_day():
		GameState.finish_run(true)
		return
	hide()
	EventBus.day_started.emit()
