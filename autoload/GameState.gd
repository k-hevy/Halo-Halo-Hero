extends Node

var currentMoney: float = 100
var money_at_start_day: float = currentMoney
var current_day: int = 1
var unlocked_ingredients: Array[Ingredient] = []
var is_day_active := true
var max_health : int = 100
var health : int = 100
var run_won := false

const time_per_Day = [60, 75, 90, 90, 105]
const wait_time_per_day = [40, 35, 30, 28, 25]
const spawn_delay_per_day = [3, 4, 5, 5, 6]

const order_damage : int = 10
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
		"intro_dialogue" : [
			"Day 1: Welcome to your new Halo-Halo stand!",
			"Layer ice, milk, mix-ins, and toppings to match each order.",
			"Click to open for business!"
		]
	},
	2: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/macapuno.tres"),
			preload("res://resources/ingredients/toppings/ube.tres"),
		],
		"customer_slots": 1,
		"intro_dialogue" : [
			"Apo here is some macapuno and Ube",
			"Its from our family",
			"Click to open for business!"
		]
	},
	3: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/nata.tres"),
		],
		"customer_slots": 2,
		"intro_dialogue" : [
			"Day 3: Welcome to your new Halo-Halo stand!",
			"Here is some nata",
			"Click to open for business!"
		]
	},
	4: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/kaong.tres"),
			preload("res://resources/ingredients/toppings/cheese.tres"),
		],
		"customer_slots": 2,
		"intro_dialogue" : [
			"Day 5: Welcome to your new Halo-Halo stand!",
			"Here is some kaong and cheese",
			"Click to open for business!"
		]
	},
	5: {
		"new_ingredients": [
			preload("res://resources/ingredients/mix-ins/munggo.tres"),
			preload("res://resources/ingredients/mix-ins/garbanzos.tres"),
		],
		"customer_slots": 3,
		"intro_dialogue" : [
			"Day 5: Welcome to your new Halo-Halo stand!",
			"Its your last day",
			"Click to open for business!"
		]
	},
}


func _ready() -> void:
	#begin_next_Day()
	unlock_for_day(current_day)
	EventBus.order_paid.connect(add_money)
	EventBus.day_ended.connect(end_day)
	EventBus.day_started.connect(begin_next_Day)
	EventBus.left_unserved.connect(lose_health)


func add_money(amount: float) -> void:
	currentMoney += amount
	EventBus.money_changed.emit(currentMoney)


func lose_health(_customer : Customer) -> void:
	if not is_day_active:
		return
	health = max(health - order_damage, 0)
	EventBus.health_changed.emit(health, max_health)
	if health == 0:
		EventBus.game_over.emit()


func end_day() -> void:
	is_day_active = false
	get_tree().paused = true


func begin_next_Day() -> void:
	current_day += 1
	unlock_for_day(current_day)
	money_at_start_day = currentMoney
	is_day_active = true
	get_tree().paused = false
	get_tree().reload_current_scene()


func reset() -> void:
	currentMoney = 100
	money_at_start_day = currentMoney
	current_day = 1
	health = max_health
	is_day_active = true
	unlocked_ingredients.clear()
	unlock_for_day(1)


func get_earned_today() -> float:
	return currentMoney - money_at_start_day


func unlock_for_day(day : int) -> void:
	
	if not DAY_UNLOCKS.has(day):
		print("Game Ended")
		return

	for ing in DAY_UNLOCKS[day]["new_ingredients"]:
		if ing in unlocked_ingredients:
			print("Ingredient already exists")
			continue
		
		unlocked_ingredients.append(ing)


func is_unlocked(ingredient : Ingredient) -> bool:
	return ingredient in unlocked_ingredients


func is_last_day() -> bool:
	return current_day > DAY_UNLOCKS.size()


func finish_run(won: bool) -> void:
	run_won = won
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/end_scene.tscn")
