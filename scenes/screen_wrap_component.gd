extends Node
class_name ScreenWrapComponent

@export var world_width := 1280.0

var _body: CharacterBody2D

func _ready():
	_body = owner as CharacterBody2D

func _physics_process(_delta):
	if not _body:
		return
	
	var half_width = world_width / 2.0
	var pos = _body.global_position
	
	if pos.x < -half_width:
		pos.x += world_width
	elif pos.x > half_width:
		pos.x -= world_width
	
	_body.global_position = pos
	_body.velocity.x = 0
	_body.reset_physics_interpolation()
