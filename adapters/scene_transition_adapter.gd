extends BaseAdapter
class_name SceneTransitionAdapter

# --------------------------------------------------
# Defaults (Asymmetric by Design)
# --------------------------------------------------

const DEFAULT_FADE_OUT := 0.6
const DEFAULT_FADE_IN  := 0.35

# --------------------------------------------------
# Runtime References
# --------------------------------------------------

var _storm_root: Node
var _fade_overlay: Node

# --------------------------------------------------
# Initialization
# --------------------------------------------------

func initialize():
	preferred_bus_name = "SceneBus"
	listen_to_bus_named(preferred_bus_name)

	# Resolve infrastructure
	_storm_root = get_tree().get_root().find_child("StormRoot", true, false)

	if _storm_root:
		_fade_overlay = _storm_root.get_node_or_null("OverlayLayer/FadeOverLay")




func get_adapter_name() -> String:
	return "SceneTransitionAdapter"


func get_supported_events() -> Array[String]:
	return ["scene_change_requested"]


# --------------------------------------------------
# Event Handling
# --------------------------------------------------

func handle_event(event: Dictionary) -> void:
	if event.get("type") != "scene_change_requested":
		return

	var scene_path: String = event.get("scene", "")
	if scene_path == "":
		return

	# Resolve fade timings
	var fade_out_time := DEFAULT_FADE_OUT
	var fade_in_time  := DEFAULT_FADE_IN

	# Full override (symmetric)
	if event.has("duration"):
		var d := float(event["duration"])
		fade_out_time = d
		fade_in_time  = d
	else:
		# Asymmetric overrides
		if event.has("fade_out"):
			fade_out_time = float(event["fade_out"])
		if event.has("fade_in"):
			fade_in_time = float(event["fade_in"])

	await _perform_transition(scene_path, fade_out_time, fade_in_time)


# --------------------------------------------------
# Transition Orchestration
# --------------------------------------------------

func _perform_transition(path: String, fade_out_time: float, fade_in_time: float) -> void:

	_ensure_refs()

	# Fade Out (optional)
	if is_instance_valid(_fade_overlay) and fade_out_time > 0.0:
		print("Calling fade_out")
		await _fade_overlay.fade_out(fade_out_time)
	else:
		print("Fade out condition failed.")


	# Scene Swap
	if _storm_root:
		_storm_root.swap_scene(path)

	# Re-resolve in case anything changed
	_ensure_refs()

	# Fade In (optional)
	if is_instance_valid(_fade_overlay) and fade_in_time > 0.0:
		print("Calling fade_in")
		await _fade_overlay.fade_in(fade_in_time)
	else:
		print("Fade in condition failed.")


func _ensure_refs():

	if not is_instance_valid(_storm_root):
		_storm_root = get_tree().get_root().find_child("StormRoot", true, false)

	if _storm_root and not is_instance_valid(_fade_overlay):
		_fade_overlay = _storm_root.get_node_or_null("OverlayLayer/FadeOverlay")
