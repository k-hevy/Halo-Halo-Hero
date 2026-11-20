class_name Counter
extends Node2D

@export var customer_scene : PackedScene
@export var customer_spots : Array[Marker2D] = []
var customers : Array[Customer] = []

@onready var next_customer_timer : Timer = $NextCustomerTimer
@onready var day_timer : Timer = $DayTimer
@onready var bowl : Bowl = $Bowl
@onready var blender : Blender = $Blender 
@onready var health_bar : ProgressBar = $HealthBar
@onready var fill_style := StyleBoxFlat.new()
@onready var dialogue_box : DialogueBox = $DialogueBox


func _ready() -> void:

	customers.resize(3)
	customer_spots.resize(3)
	
	next_customer_timer.timeout.connect(spawn_customer)
	day_timer.timeout.connect(_on_day_end)
	
	EventBus.money_changed.connect(on_money_changed)
	EventBus.left_unserved.connect(on_left_un_served)
	EventBus.health_changed.connect(on_health_changed)
	EventBus.game_over.connect(on_game_over)
	dialogue_box.finished.connect(start_timers)
	
	on_money_changed(GameState.currentMoney)
	bowl.dropped_on_customer.connect(serve)
	
	health_bar.max_value = 1.0
	health_bar.step = 0.01
	health_bar.add_theme_stylebox_override("fill", fill_style)
	
	setup_day()


func _process(_delta: float) -> void:
	$TimeLabel.text = str(day_timer.time_left)


func start_timers() -> void:
	day_timer.start(GameState.time_per_Day[GameState.current_day -1])
	next_customer_timer.start(2)


func _on_day_end() -> void: # End Day
	EventBus.day_ended.emit()
	next_customer_timer.stop()
	for child in customers:
		free_slot(child)


func setup_day() -> void: # Start Day
	bowl.reset()
	blender.reset()
	GameState.health = GameState.max_health
	on_health_changed(GameState.health, GameState.max_health)
	
	var intro: Array[String] = []
	intro.assign(GameState.DAY_UNLOCKS[GameState.current_day].get("intro_dialogue", []))
	dialogue_box.start(intro)


func spawn_customer() -> void:
	
	if not GameState.is_day_active:
		return
	
	var slot : int = find_free_slot()
	if slot == -1:
		print("No available spaces")
		return

	var new_customer : Customer = customer_scene.instantiate()
	customers[slot] = new_customer
	new_customer.slot_index = slot
	new_customer.global_position = customer_spots[slot].global_position
	new_customer.setup(Order.generate_order(GameState.unlocked_ingredients, GameState.current_day))
	$Customers.add_child(new_customer)
	try_start_spawn_timer()


func find_free_slot() -> int:
	var available_slots : int = GameState.DAY_UNLOCKS[GameState.current_day]["customer_slots"]
	for i in range(0, available_slots):
		if customers[i] == null:
			return i
	return -1


func try_start_spawn_timer() -> void:
	if not GameState.is_day_active:
		return
	if find_free_slot() != -1 and next_customer_timer.is_stopped():
		next_customer_timer.start(GameState.spawn_delay_per_day[GameState.current_day -1])


func on_left_un_served(customer : Customer) -> void:
	free_slot(customer)


func serve(customer: Customer) -> void:
	if bowl.contents.is_empty() || !bowl.has_base():
		return
	if customer.order.matches(bowl.contents):
		EventBus.order_paid.emit(customer.order.payment)
	else:
		EventBus.left_unserved.emit(customer)
	EventBus.order_served.emit(customer)
	bowl.reset()
	free_slot(customer)
	try_start_spawn_timer()


func free_slot(customer : Customer) -> void:
	if customer == null:
		return
	customers[customer.slot_index] = null
	customer.remove()
	try_start_spawn_timer()


func on_money_changed(total: float) -> void:
	$MoneyLabel.text = "P%d" % total


func on_health_changed(current_health : int, max_health : int) -> void:
	
	var ratio : float = float(current_health) / float(max_health)
	health_bar.value = ratio
	
	if ratio > 0.5:
		fill_style.bg_color = Color.GREEN
	elif ratio > 0.25:
		fill_style.bg_color = Color.ORANGE
	else:
		fill_style.bg_color = Color.RED


func on_game_over() -> void:
	GameState.is_day_active = false
	day_timer.stop()
	next_customer_timer.stop()
	for c in customers:
		free_slot(c)
	GameState.finish_run(false)
