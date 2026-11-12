class_name Customer
extends Area2D

var order: Order

func setup(o: Order) -> void:
	order = o
	var names := o.required.map(func(i): return i.display_name)
	$Label.text = ", ".join(names)
