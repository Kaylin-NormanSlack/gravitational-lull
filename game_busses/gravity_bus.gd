extends BaseEventBus
class_name GravityBus

# --------------------------------------------------
# Gravity Intent Signals
# --------------------------------------------------

##  { vector_direction: "UP" or "up"} VECTOR2.UP, VECTOR2.DOWN, etc.
signal gravity_changed(payload)

signal gravity_enabled(payload) # { enabled: bool }
