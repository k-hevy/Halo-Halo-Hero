extends Node2D

var customer_scene:= preload("res://scenes/customer.tscn")
var current_customer: Customer

var orders: Array[Order] = [
	preload("res://resources/orders/order_easy.tres"),
	preload("res://resources/orders/order_medium.tres"),
	preload("res://resources/orders/order_hard.tres"),
]


func _ready() -> void:
	$NextCustomerTimer.timeout.connect(spawn_customer)
	EventBus.money_changed.connect(on_money_changed)
	EventBus.order_served.connect(on_order_served)
	on_money_changed(GameState.money)
	$Bowl.dropped_on_customer.connect(serve)
	spawn_customer()


func spawn_customer() -> void:
	current_customer = customer_scene.instantiate()
	current_customer.global_position = $CustomerSpot.global_position
	current_customer.setup(orders.pick_random())
	$Customers.add_child(current_customer)


func serve(customer: Customer) -> void:
	if $Bowl.contents.is_empty() || !$Bowl.has_base():
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


func on_order_served(order: Order, bowl : Array[Ingredient]) -> void:
	if !order.matches(bowl):
		print("Order Wrong")
	else:
		print("Order Right: " + str(order.payment))
