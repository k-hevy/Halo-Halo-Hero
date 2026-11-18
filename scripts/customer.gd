class_name Customer
extends Area2D


@onready var order: Order
@onready var fill_style := StyleBoxFlat.new()
@onready var waitTimer : Timer = $WaitTimer
@onready var progressBar : ProgressBar = $ProgressBar
@export var waitTime : int


func _ready() -> void:
	progressBar.add_theme_stylebox_override("fill",fill_style)
	waitTimer.start()


func _process(_delta: float) -> void:
	progressBar.value = waitTimer.time_left / waitTime
	var ratio = waitTimer.time_left / waitTime
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
	EventBus.left_unserved.emit()


func remove() -> void:
	queue_free()
