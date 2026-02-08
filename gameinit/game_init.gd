extends Node

func _ready():
	GlobalBusManager.register_bus("CameraBus", BaseEventBus.new())
	GlobalBusManager.register_bus("UIBus", BaseEventBus.new())
	GlobalBusManager.register_bus("GameBus", BaseEventBus.new())
	GlobalBusManager.register_bus("GravityBus", GravityBus.new())
	GlobalBusManager.register_bus("InputBus", InputBus.new())
	GlobalBusManager.register_bus("AudioBus", BaseEventBus.new())

	GlobalAdapterRegistry.adapter_folder = "res://adapters/"
	GlobalAdapterRegistry.reload()

	InputPoller.initialize()

	for adapter in GlobalAdapterRegistry.get_all():
			adapter.initialize()
	GlobalBusManager.mark_ready()
	
	GlobalBusManager.get_bus("CameraBus").emit_event({
		"type": "scene_change_request",
		"scene": "TemplateScene",
		"fade_out": {"speed": 0.0},
		"fade_in": {"speed": 0.5}
	})
