class_name Counter
extends Node2D

var customer_scene := preload("res://scenes/customer.tscn")
var current_customer : Customer
var is_day_active := true

@onready var next_customer_timer : Timer = $NextCustomerTimer
@onready var day_timer : Timer = $DayTimer
@onready var bowl : Bowl = $Bowl
@onready var blender : Blender = $Blender 


func _ready() -> void:
	
	on_day_start()
	next_customer_timer.timeout.connect(spawn_customer)
	day_timer.timeout.connect(_on_day_end)
	
	EventBus.money_changed.connect(on_money_changed)
	EventBus.order_served.connect(on_order_served)
	EventBus.day_started.connect(on_day_start)
	EventBus.left_unserved.connect(on_left_un_served)
	
	on_money_changed(GameState.currentMoney)
	bowl.dropped_on_customer.connect(serve)


func _process(_delta: float) -> void:
	$TimeLabel.text = str(day_timer.time_left)


func spawn_customer() -> void:
	if not is_day_active:
		return
	current_customer = customer_scene.instantiate()
	current_customer.global_position = $CustomerSpot.global_position
	current_customer.setup(Order.generate_order(GameState.unlocked_ingredients, 1))
	$Customers.add_child(current_customer)


func on_left_un_served() -> void:
	print("UNSERVED")
	current_customer.remove()
	next_customer_timer.start(3)


func serve(customer: Customer) -> void:
	
	print(customer.order.required)
	print("LOL")
	print(bowl.contents)
	
	if bowl.contents.is_empty() || !bowl.has_base():
		return
	if customer.order.matches(bowl.contents):
		EventBus.order_paid.emit(customer.order.payment)
	EventBus.order_served.emit(customer.order, bowl.contents)
	bowl.reset()
	customer.queue_free()
	if customer == current_customer:
		current_customer.remove()
		next_customer_timer.start(3)


func on_money_changed(total: float) -> void:
	$MoneyLabel.text = "P%d" % total


func on_order_served(o: Order, b : Array[Ingredient]) -> void:
	if !o.matches(b):
		print("Order Wrong")
	else:
		print("Order Right: " + str(o.payment))


func _on_day_end() -> void: # End Day
	is_day_active = false
	EventBus.day_ended.emit()
	next_customer_timer.stop()
	for child in $Customers.get_children():
		child.queue_free()
	EventBus.day_ended.emit()


func on_day_start() -> void: # Start Day
	is_day_active = true
	GameState.unlock_for_day(GameState.current_day)
	
	next_customer_timer.start(2)
	day_timer.start(GameState.time_per_Day[--GameState.current_day])
	
	bowl.reset()
	blender.reset()
