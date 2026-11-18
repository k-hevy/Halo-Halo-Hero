class_name Order
extends Resource

@export var required: Array[Ingredient] = []
@export var payment: float = 20

func matches(bowl: Array[Ingredient] ) -> bool: # Creates an empty list then append all non-base ingredients
	if bowl.size() != required.size(): 
		return false
	var a := required.map(func(i): return i.id)
	var b := bowl.map(func(i): return i.id)
	a.sort()
	b.sort()
	return a == b


static func generate_order(ingredients_needed : Array[Ingredient], mix_in_no : int) -> Order:
	
	var milk_ice : Array[Ingredient]
	for ing in GameState.unlocked_ingredients:
		if ing.layer == Ingredient.Layer.DRIZZLE or ing.layer == Ingredient.Layer.BASE:
			milk_ice.append(ing)
	
	var mix_ins : Array[Ingredient]
	for ing in GameState.unlocked_ingredients:
		if ing.layer == Ingredient.Layer.MIX_IN:
			mix_ins.append(ing)
	mix_ins.shuffle()
	var mix_in_needed := mix_ins.slice(0, mix_in_no)
	
	var toppings : Array[Ingredient]
	for ing in GameState.unlocked_ingredients:
		if ing.layer == Ingredient.Layer.TOPPING:
			toppings.append(ing)
	toppings.shuffle()
	var topping_needed := toppings.slice(0, 1)
	
	ingredients_needed = milk_ice + mix_in_needed + topping_needed
	
	var price : float = 0
	for ing in ingredients_needed:
		price += ing.price
	
	var new_order : Order = Order.new()
	new_order.required = ingredients_needed
	new_order.payment = price
	
	return new_order
