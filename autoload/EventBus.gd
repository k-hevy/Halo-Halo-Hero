extends Node


@warning_ignore("unused_signal")
signal order_paid(amount : float) # Connected to GameState to change global money
@warning_ignore("unused_signal")
signal money_changed(total : float) # Chanegs money label
@warning_ignore("unused_signal")
signal health_changed(current : int, max : int)
@warning_ignore("unused_signal")
signal game_over


@warning_ignore("unused_signal")
signal order_served(customer : Customer) # unused
@warning_ignore("unused_signal")
signal left_unserved(customer : Customer)
@warning_ignore("unused_signal")



@warning_ignore("unused_signal")
signal day_ended # Increments day
@warning_ignore("unused_signal")
signal day_started # Increments day
