extends Control

@export var grid_drawer:GridDrawer

@onready var background:ColorRect = $Background

func _ready() -> void:
	grab_focus()

func show_background() -> void:
	background.visible = true

func hide_background() -> void:
	background.visible = false
