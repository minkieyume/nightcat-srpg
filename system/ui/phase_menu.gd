class_name PhaseMenu
extends Control

@export var phase:MenuPhase

func _ready():
	if is_instance_valid(phase):
		phase.entered.connect(_phase_enter)
		phase.exited.connect(_phase_exit)

func _phase_enter() -> void:
	visible = true
	grab_focus()

func _phase_exit() -> void:
	visible = false
	release_focus()
