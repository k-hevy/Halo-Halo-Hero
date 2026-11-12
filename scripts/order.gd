class_name Order
extends Resource

@export var required: Array[Ingredient] = []
@export var payment: int = 20

func matches(bowl: Array[Ingredient] ) -> bool:
	if bowl.size() != required.size(): 
		return false
	var a := required.map(func(i): return i.id)
	var b := bowl.map(func(i): return i.id)
	a.sort()
	b.sort()
	return a == b
