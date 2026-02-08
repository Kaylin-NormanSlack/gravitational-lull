extends BaseAdapter
class_name SceneManagerAdapter

@export var scenes: Dictionary   # optional, future-proofing

func initialize() -> void:
	preferred_bus_name = "CameraBus"
	listen_to_bus_named(preferred_bus_name)

func get_adapter_name() -> String:
	return "SceneManagerAdapter"

func get_supported_events() -> Array[String]:
	return [
		"scene_change_request",
		"scene_reset_request"
	]

func handle_event(event: Dictionary) -> void:
	print("Handling Event!")
	match event.get("type", ""):
		"scene_change_request":
			_handle_scene_change(event)



func _handle_scene_change(event: Dictionary) -> void:
	var scene: String = event.get("scene", "")
	if scene == "":
		push_warning("[SceneManagerAdapter] No scene specified")
		return

	var fade_out: Dictionary = event.get("fade_out", {})
	var fade_in : Dictionary = event.get("fade_in", {})
	var general : Dictionary = event.get("general", {})

	# Construct options using plugin API
	var fade_out_opts = SceneManager.create_options(
		fade_out.get("speed", 1.0),
		fade_out.get("pattern", "fade"),
		fade_out.get("smoothness", 0.1),
		fade_out.get("inverted", false)
	)

	var fade_in_opts = SceneManager.create_options(
		fade_in.get("speed", 1.0),
		fade_in.get("pattern", "fade"),
		fade_in.get("smoothness", 0.1),
		fade_in.get("inverted", false)
	)

	var general_opts = SceneManager.create_general_options(
		
		general.get("color", Color.BLACK),
		general.get("timeout", 0.0),
		general.get("clickable", false),
		general.get("add_to_back", true)
	)

	SceneManager.validate_scene(scene)
	SceneManager.change_scene(scene, fade_out_opts, fade_in_opts, general_opts)
