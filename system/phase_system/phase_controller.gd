class_name PhaseController
extends LimboHSM

@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary

signal cargo_send(cargo:Dictionary)

func _ready() -> void:
	for phase in get_children():
		if phase is Phase or phase is PhaseController:
			for event in phase.transition.keys():
				var target = phase.transition[event]
				phase.cargo_send.connect(target._on_cargo_recieve)
				add_transition(phase,target,event)
	initialize(self)
	set_active(true)

func _enter() -> void:
	pass

func _exit() -> void:
	emit_signal("cargo_send",context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo
