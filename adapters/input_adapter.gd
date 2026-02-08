extends BaseAdapter
class_name InputAdapter

"""
InputAdapter responsibilities:
- Listen to raw input events on InputBus
- Track held input state
- Emit semantic input signals (movement, jump)
"""

# --------------------------------------------------
# Configuration
# --------------------------------------------------

var input_bus_name := "InputBus"

# --------------------------------------------------
# Input state
# --------------------------------------------------

var _held: Dictionary = {} # action -> bool

# --------------------------------------------------
# Lifecycle
# --------------------------------------------------

func initialize() -> void:
	preferred_bus_name = input_bus_name
	listen_to_bus_named(preferred_bus_name)


# --------------------------------------------------
# Adapter identity
# --------------------------------------------------

func get_adapter_name() -> String:
	return "InputAdapter"

func get_supported_events() -> Array[String]:
	return [
		"input_pressed",
		"input_released"
	]

# --------------------------------------------------
# Raw input handling
# --------------------------------------------------

func handle_event(event: Dictionary) -> void:
	var action = event.get("action", "")
	if action.is_empty():
		return

	match event.get("type", ""):
		"input_pressed":
			_held[action] = true
			_handle_press(action)

		"input_released":
			_held[action] = false
			_handle_release(action)

# --------------------------------------------------
# Semantic shaping
# --------------------------------------------------

func _handle_press(action: String) -> void:
	if action == "ui_accept":
		_emit_jump()

	_update_move_axis()

func _handle_release(_action: String) -> void:
	_update_move_axis()

func _update_move_axis() -> void:
	var left = _held.get("move_left", false)
	var right = _held.get("move_right", false)

	var axis := 0.0
	if left and not right:
		axis = -1.0
	elif right and not left:
		axis = 1.0

	bus.emit_event({
		"type": "move_axis",
		"x": axis
	})

# --------------------------------------------------
# Semantic emission
# --------------------------------------------------

func _emit_jump() -> void:
	bus.emit_event({
		"type": "jump_pressed"
	})
