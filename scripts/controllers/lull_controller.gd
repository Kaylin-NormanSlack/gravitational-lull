extends Node
class_name LullController

## -----------------------------
## Configuration
## -----------------------------

@export var enabled := true

@export var base_world_speed := 80.0
@export var base_gravity_strength := 980.0

@export var transition_time := 1.0
@export var pause_at_zero := 0.4

@export var auto_cycle := false
@export var cycle_interval := 8.0

## -----------------------------
## Runtime State
## -----------------------------

var _camera_bus : BaseEventBus
var _gravity_bus : BaseEventBus

var _direction := -1
var _current_world_speed := 80.0
var _time := 0.0
var _is_transitioning := false

## -----------------------------
## Lifecycle
## -----------------------------

func _ready():
	if not enabled:
		return

	_resolve_buses()
	await(_resolve_buses())

func _physics_process(delta):
	if not enabled:
		return
	

	if auto_cycle and not _is_transitioning:
		print("transitioning...!")
		_time += delta
		if _time >= cycle_interval:
			_time = 0.0
			reverse_world()

## -----------------------------
## Bus Resolution
## -----------------------------

func _resolve_buses():
	if GlobalBusManager.has_bus("CameraBus"):
		_camera_bus = GlobalBusManager.get_bus("CameraBus")

	if GlobalBusManager.has_bus("GravityBus"):
		_gravity_bus = GlobalBusManager.get_bus("GravityBus")

## -----------------------------
## Public Control
## -----------------------------

func reverse_world():
	if _is_transitioning:
		return

	_is_transitioning = true

	var target_speed := -_current_world_speed
	var target_gravity_direction := -_direction

	# Step 1 — Slow to zero
	_emit_camera_velocity(0.0, transition_time * 0.5)
	_emit_gravity(base_gravity_strength, _direction, transition_time * 0.5)

	await get_tree().create_timer(transition_time * 0.5).timeout

	# Optional pause at stillness
	if pause_at_zero > 0.0:
		await get_tree().create_timer(pause_at_zero).timeout

	# Step 2 — Reverse
	_direction *= -1
	_current_world_speed = abs(base_world_speed) * _direction

	_emit_camera_velocity(_current_world_speed, transition_time * 0.5)
	_emit_gravity(base_gravity_strength, _direction, transition_time * 0.5)

	await get_tree().create_timer(transition_time * 0.5).timeout

	_is_transitioning = false
	print("Transition Complete~!")

## -----------------------------
## Event Emission
## -----------------------------

func _emit_camera_velocity(speed: float, duration: float):
	if _camera_bus == null:
		return

	_camera_bus.emit_event({
		"type":"camera_velocity_changed",
		"velocity": base_world_speed
	})
	

func _emit_gravity(strength: float, direction: float, duration: float):
	if _gravity_bus == null:
		return

	_gravity_bus.emit_event({
		"type": "gravity_changed",
		"strength": strength,
		"direction": direction,
		"transition_time": duration
	})
