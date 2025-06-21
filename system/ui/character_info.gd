extends Control

@onready var ap_label = $APLabel

func set_ap(current:int, max:int):
	ap_label.text = "AP: %d / %d" % [current, max]
