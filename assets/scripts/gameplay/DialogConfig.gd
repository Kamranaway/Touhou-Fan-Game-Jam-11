@tool
extends Node

"""
DialogConfig.gd

Used to configure dialog boxes via the inspector.
"""

@export var lower_margin := 50.0
@export var dialog_text_margin_offset_x := 14.0
@export var dialog_text_margin_offset_y := 2.0
@export var dialog_margin_x := 1500.0
@export var dialog_margin_y := 250.0

@export var dialog_font : Resource
@export var actor_name_font : Resource

@export var theme_color := Color.WHITE
@export var font_color := Color.WHITE
@export var font_size := 60


func _get_tool_buttons() -> Array:
	return [update_settings]


func update_settings():
	$"../DialogRig/LowerMargin".custom_minimum_size.y = lower_margin
	$"../DialogRig/MarginContainer/DialogMargin".set("theme_override_constants/margin_left", dialog_text_margin_offset_x)
	$"../DialogRig/MarginContainer/DialogMargin".set("theme_override_constants/margin_right", dialog_text_margin_offset_x)
	$"../DialogRig/MarginContainer/DialogMargin".set("theme_override_constants/margin_top", dialog_text_margin_offset_y)
	$"../DialogRig/MarginContainer/DialogMargin".set("theme_override_constants/margin_bottom", dialog_text_margin_offset_y)
	$"../DialogRig/MarginContainer".custom_minimum_size.x = dialog_margin_x
	$"../DialogRig/MarginContainer".custom_minimum_size.y = dialog_margin_y
	$"../DialogRig/ActorName".set("theme_override_colors/font_outline_color", Color.from_hsv(theme_color.h, theme_color.s + 0.4, theme_color.v - 0.4, 1.0))
	$"../DialogRig/MarginContainer/DialogBox".modulate = theme_color
	$"../DialogRig/MarginContainer/DialogMargin/DialogText".set("theme_override_colors/font_outline_color", Color.from_hsv(theme_color.h, theme_color.s + 0.4, theme_color.v - 0.4, 1.0))
	$"../DialogRig/MarginContainer/DialogMargin/DialogText".set("theme_override_colors/default_color", font_color)
	$"../DialogRig/MarginContainer/DialogMargin/DialogText".set("theme_override_font_sizes/normal_font_size", font_size)
	$"../DialogRig/MarginContainer/DialogMargin/DialogText".set("theme_override_fonts/normal_font", dialog_font)
	$"../DialogRig/ActorName".set("theme_override_fonts/font", actor_name_font)
