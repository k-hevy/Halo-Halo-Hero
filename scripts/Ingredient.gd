class_name  Ingredient
extends Resource

enum Layer { MIX_IN, TOPPING }

@export var id: StringName
@export var display_name: String
@export var layer: Layer = Layer.MIX_IN
@export var color: Color = Color.WHITE
@export var price: float
