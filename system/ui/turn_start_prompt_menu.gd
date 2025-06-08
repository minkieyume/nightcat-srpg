# TurnStartPrompt UI for displaying phase prompt
extends Control

signal prompt_finished

@export var prompt_text: String = "新回合开始"
@onready var label = $Label

func _ready():
	label.text = prompt_text
	visible = false

func show_prompt(text: String = ""):
	if text != "":
		label.text = text
	visible = true
	await get_tree().create_timer(1.0).timeout
	visible = false
	# 发送提示完成信号
	prompt_finished.emit()

func send_prompt_finished():
	# 备用方法，现在使用信号
	prompt_finished.emit()
