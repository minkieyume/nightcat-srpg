class_name PhaseController
extends LimboHSM

@export var level_handler:LevelHandler
@export var transition:Dictionary[StringName,LimboState]
var context:Dictionary:
	set(c):
		context = c
		emit_signal("context_changed")

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

func _setup():
	for phase in get_children():
		if phase is Phase or phase is PhaseController:
			phase.level_handler = level_handler

func _enter() -> void:
	pass

func _exit() -> void:
	emit_signal("cargo_send",context)

func _on_cargo_recieve(cargo:Dictionary):
	context = cargo

# 回合推进：重置所有角色AP，推进所有技能冷却
func advance_turn():
	# 重置所有角色AP
	for character in level_handler.get_character_list():
		if character.has_method("reset_ap"):
			character.reset_ap()
		# 推进技能冷却
		if character.has_node("ActionManager"):
			var am = character.get_node("ActionManager")
			if am.has_method("tick_cooldown"):
				am.tick_cooldown()
