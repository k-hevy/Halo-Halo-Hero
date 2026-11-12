extends Node

var money: float = 100
var day: int = 1
var unlocked_ingredients: Array[Ingredient] = []


func _ready() -> void:
	EventBus.order_paid.connect(add_money)


func add_money(amount: float) -> void:
	money += amount
	EventBus.money_changed.emit(money)


func end_day() -> void:
	day += 1
	EventBus.day_ended.emit()
