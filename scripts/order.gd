class_name Order
extends Resource

@export var required: Array[Ingredient] = []
@export var payment: int = 20

func matches(bowl: Array[Ingredient] ) -> bool:
	# Creates an empty list then append all non-base ingredients
	var no_base:= bowl.filter(func(ingredient): return ingredient.layer != Ingredient.Layer.BASE) 
	if no_base.size() != required.size(): 
		return false
	var a := required.map(func(i): return i.id)
	var b := no_base.map(func(i): return i.id)
	a.sort()
	b.sort()
	return a == b

	
