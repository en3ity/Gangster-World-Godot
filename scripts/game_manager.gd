
extends Node

var finished = false

func _process(_delta):
	if finished:
		return

	if get_tree().get_nodes_in_group("enemies").is_empty():
		finished = true
		show_ending()

func show_ending():
	var layer = CanvasLayer.new()
	get_tree().current_scene.add_child(layer)

	var background = ColorRect.new()
	background.color = Color(0, 0, 0, 0.85)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	layer.add_child(background)

	var title = Label.new()
	title.text = "MISSION ACCOMPLISHED!\nBRAINROT ELIMINATED"
	title.add_theme_font_size_override("font_size", 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.add_child(title)

	print("MISSION COMPLETE!")
