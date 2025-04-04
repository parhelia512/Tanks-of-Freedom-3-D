extends Control


signal help_requested(tip: String)
signal clear_help_requested()


@onready var audio = $"/root/SimpleAudioLibrary"
@onready var settings = $"/root/Settings"

@onready var label = $"label"
@onready var button = $"toggle"
@onready var button_label = $"toggle/label"

@export var unavailable = false
@export var option_name = ""
@export var option_key = ""
@export var help_tip = ""
@export var available_values = ["first", "second"]

func _ready():
	self.label.set_text(self.option_name)
	self._read_setting()
	self.button.set_disabled(self.unavailable)

func _read_setting():
	var value = self.settings.get_option(self.option_key)

	for known_value in self.available_values:
		if value == known_value:
			if known_value is String:
				self.button_label.set_text(known_value)
			else:
				self.button_label.set_text(str(known_value))
			return

	self.button_label.set_text("???")
	self.button.set_disabled(true)

func _on_toggle_button_pressed():
	var value = self.settings.get_option(self.option_key)

	var index = self.available_values.find(value)

	if index < 0:
		return

	if (index + 1) < self.available_values.size():
		value = self.available_values[index + 1]
	else:
		value = self.available_values[0]

	self.settings.set_option(self.option_key, value)
	self.audio.play("menu_click")
	self._read_setting()


func _show_help():
	if self.help_tip != "":
		help_requested.emit(help_tip)
	else:
		self._clear_help()

func _clear_help():
	clear_help_requested.emit()

