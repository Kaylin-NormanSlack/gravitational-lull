extends BaseAdapter
class_name InputAdapter


func initialize():
	preferred_bus_name = "InputBus"
	listen_to_bus_named(preferred_bus_name)
	#connect('input_pressed',handle_event)
	#connect('input_released',handle_event)

func get_adapter_name() -> String:
	return "InputAdapter"

func get_supported_events() -> Array[String]:
	return ["input_pressed", "input_released"]


func handle_event(event: Dictionary) -> void:
	match event.get("type", ""):
		"input_pressed":
			print(event.get("action") + " Pressed!")

		"input_released":
			print(event.get("action") + " Released!")
			pass
