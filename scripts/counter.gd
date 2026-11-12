extends Node2D

@export var customer_scene:= preload("res://scenes/customer.tscn")
@export var current_customer: Customer

var orders: Array[Order] = [
	preload("res://resources/orders/order_easy.tres"),
	preload("res://resources/orders/order_medium.tres"),
	preload("res://resources/orders/order_hard.tres"),
]


func _ready() -> void:
	$NextCustomerTimer.timeout.connect(spawn_customer)
	EventBus.money_changed.connect(on_money_changed)
	on_money_changed(GameState.money)
	$Bowl.dropped_on_customer.connect(serve)
	$ServeButton.hide()
	spawn_customer()


func spawn_customer() -> void:
	current_customer = customer_scene.instantiate()
	current_customer.global_position = $CustomerSpot.global_position
	current_customer.setup(orders.pick_random())
	add_child(current_customer)


func _on_serve_button_pressed() -> void:
	if current_customer == null or $Bowl.contents.is_empty():
		return
	var order := current_customer.order
	if order.matches($Bowl.contents):
		EventBus.order_paid.emit(order.payment)
	EventBus.order_served.emit(order, $Bowl.contents)


func serve(customer: Customer) -> void:
	if $Bowl.contents.is_empty():
		return
	if customer.order.matches($Bowl.contents):
		EventBus.order_paid.emit(customer.order.payment)
	EventBus.order_served.emit(customer.order, $Bowl.contents)
	$Bowl.clear()
	customer.queue_free()
	if customer == current_customer:
		current_customer == null
		$NextCustomerTimer.start()


func on_money_changed(total: int) -> void:
	$MoneyLabel.text = "P%d" % total
