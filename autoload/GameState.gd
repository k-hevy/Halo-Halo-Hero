extends Node

var currentMoney: float = 100
var money_at_start_day: float = 0
var current_day: int = 1
var unlocked_ingredients: Array[Ingredient] = []

const time_per_Day = [120, 120, 140, 140, 180] 
const mix_in_per_day = [2, 2, 3, 3, 3]
const DAY_UNLOCKS := {
	1: {
		"new_ingredients": [
			preload("res://resources/ingredients/raw_ice.tres"),
			preload("res://resources/ingredients/shaved_ice.tres"),
			preload("res://resources/ingredients/milk.tres"),
			preload("res://resources/ingredients/mix-ins/gulaman.tres"),
			preload("res://resources/ingredients/mix-ins/saba.tres"),
			preload("res://resources/ingredients/mix-ins/langka.tres"),
			preload("res://resources/ingredients/toppings/leche_flan.tres"),
		],
		"customer_slots": 1,
	},
	2: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/macapuno.tres"),
			preload("res://resources/ingredients/toppings/ube.tres"),
		],
		"customer_slots": 1,
	},
	3: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/nata.tres"),
		],
		"customer_slots": 2,
	},
	4: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/kaong.tres"),
			preload("res://resources/ingredients/toppings/cheese.tres"),
		],
		"customer_slots": 2,
	},
	5: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/munggo.tres"),
			preload("res://resources/ingredients/mix-ins/garbanzos.tres"),
		],
		"customer_slots": 3,
	},
}


func _ready() -> void:
	EventBus.order_paid.connect(add_money)
	EventBus.day_ended.connect(end_day)
	EventBus.day_started.connect(start_day)
	unlock_for_day(1)


func add_money(amount: float) -> void:
	currentMoney += amount
	EventBus.money_changed.emit(currentMoney)


func end_day() -> void:
	get_tree().paused = true
	print("Day Ended")
	# 1. Freeze player movement / inputs
	# 2. Open the "Results / Summary" UI screen
	# 3. Save game data to disk


func start_day() -> void:
	get_tree().paused = false
	current_day += 1
	money_at_start_day = currentMoney
	get_tree().reload_current_scene()


func get_earned_today() -> float:
	return currentMoney - money_at_start_day


func unlock_for_day(day : int) -> void:
	
	if day > 5 or day < 1:
		print("Game Ended")
		return

	for ing in DAY_UNLOCKS[day]["new_ingredients"]:
		if ing in unlocked_ingredients:
			print("Ingredient already exists")
			continue
		
		unlocked_ingredients.append(ing)


func is_unlocked(ingredient : Ingredient) -> bool:
	return ingredient in unlocked_ingredients
