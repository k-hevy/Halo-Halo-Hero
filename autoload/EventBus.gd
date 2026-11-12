extends Node

@warning_ignore("unused_signal")
signal order_served(order : Order, bowl : Array[Ingredient])
@warning_ignore("unused_signal")
signal order_paid(amount : float)
@warning_ignore("unused_signal")
signal day_ended
@warning_ignore("unused_signal")
signal money_changed(total : float)
