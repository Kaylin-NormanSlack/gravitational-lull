extends Node2D
class_name CameraTarget
	
@export var enabled = true

var _velocity = 80.0
var _world_bus : BaseEventBus

func _ready():
	_resolve_bus()

func _physics_process(delta):
	position.y -= floor(_velocity * delta)
		
	

func _resolve_bus():
	if GlobalBusManager.has_bus("WorldBus"):
		_world_bus = GlobalBusManager.get_bus("WorldBus")
	_connect_signals()
		
func _connect_signals() -> void:
	if not _world_bus.event_emitted.is_connected(_on_event):
		_world_bus.event_emitted.connect(_on_event)
		
func _on_event(event: Dictionary) -> void:
	match event.get("type", ""):
		"world_velocity_changed":
			var new_velocity = event.get("velocity")
			_velocity = new_velocity
