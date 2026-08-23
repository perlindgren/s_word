class_name StartMenu extends Node2D

@onready var exit_button = $ExitButton
@onready var start_button = $StartButton
@onready var master = $Master
@onready var quick = $Quick

@onready var clock : Clock = $Clock

func _ready() -> void:
	set_state()
	

func _on_texture_button_pressed() -> void:
	print("exit")
	get_tree().quit()

func _on_start_button_pressed() -> void:
	Signals.main_menu_start.emit()

func _on_exit_button_pressed() -> void:
	print("exit")
	get_tree().quit()

func _on_master_button_pressed() -> void:
	print("master")
	GameState.master_sword_mode = true
	set_state()

func _on_quick_button_pressed() -> void:
	print("quick")
	GameState.master_sword_mode = false
	set_state()
	
func _process(_delta) -> void:
	var local_time_dict = Time.get_datetime_dict_from_system()
	var s = local_time_dict.hour * 3600 + local_time_dict.minute * 60 + local_time_dict.second
	if GameState.master_sword_mode:
		clock.s = s
	else:
		clock.s = s * 60

func set_state() -> void:
	if GameState.master_sword_mode:
		master.modulate = Color.WHITE
		quick.modulate = Color(1,1,1, 0.25)
	else:
		quick.modulate = Color.WHITE
		master.modulate = Color(1,1,1, 0.25)
