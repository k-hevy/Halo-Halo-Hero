extends Node


@warning_ignore("unused_signal")
signal order_paid(amount : float) # Connected to GameState to change global money
@warning_ignore("unused_signal")
signal day_ended # Increments day
@warning_ignore("unused_signal")
signal money_changed(total : float) # Chanegs money label
@warning_ignore("unused_signal")
signal ice_used() # tells the blender the ice has been used


@warning_ignore("unused_signal")
signal order_served(order : Order, bowl : Array[Ingredient])
