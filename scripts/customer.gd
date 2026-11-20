class_name Customer
extends Area2D


@onready var order: Order
@onready var slot_index : int
@onready var fill_style := StyleBoxFlat.new()
@onready var waitTimer : Timer = $WaitTimer
@onready var progressBar : ProgressBar = $ProgressBar


func _ready() -> void:
	waitTimer.start(GameState.wait_time_per_day[GameState.current_day - 1])
	progressBar.add_theme_stylebox_override("fill",fill_style)
	waitTimer.start()


func _process(_delta: float) -> void:
	var ratio := waitTimer.time_left / waitTimer.wait_time
	progressBar.value = ratio
	if ratio > 0.5:
		fill_style.bg_color = Color.GREEN
	elif ratio > 0.25:
		fill_style.bg_color = Color.ORANGE
	else:
		fill_style.bg_color = Color.RED


func setup(o: Order) -> void:
	order = o 
	var names := o.required.map(func(i): return i.display_name)
	$Label.text = ", ".join(names)


func _on_wait_timer_timeout() -> void:
	EventBus.left_unserved.emit(self)


func remove() -> void:
	queue_free()
