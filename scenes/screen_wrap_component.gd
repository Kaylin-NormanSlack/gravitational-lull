extends Node
class_name ScreenWrapComponent

@export var enabled := true
@export var margin := 2.0   # small inset to prevent edge jitter
@export var camera_target: Node2D
@export var _wrap_cooldown := 1.0

var _body: CharacterBody2D

func _ready() -> void:
	_body = owner as CharacterBody2D
	if _body == null:
		push_warning("ScreenWrapComponent must be attached to a CharacterBody2D.")



func _physics_process(delta):
	if _wrap_cooldown > 0:
		_wrap_cooldown -= delta
		return
	
	_apply_wrap()

func _apply_wrap():
	if _body == null:
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	var cam = get_viewport().get_camera_2d()
	if cam == null:
		return
	
	var left = cam.global_position.x - viewport_size.x / 2
	var right = cam.global_position.x + viewport_size.x / 2
	
	var pos = _body.global_position
	
	if pos.x < left:
		_teleport_to(right - 4)
	elif pos.x > right:
		_teleport_to(left + 4)
		

func _teleport_to(new_x: float):
	_wrap_cooldown = 0.1
	var pos = _body.global_position
	pos.x = new_x
	
	# Clear velocity BEFORE move_and_slide next frame
	_body.velocity.x = 0
	
	# Important: clear floor snap & collision memory
	_body.set_floor_stop_on_slope_enabled(false)
	_body.global_position = pos
	_body.set_floor_stop_on_slope_enabled(true)
