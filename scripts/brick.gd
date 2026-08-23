class_name Brick extends Area2D

@export var move_speed: Vector2 = Vector2(10.0, 5)
@export var rotation_speed: float = 0.01

var is_dragging: bool = false
var old_rotation: float 
var click_offset: Vector2 = Vector2.ZERO
var char : String

@onready var main : Main = get_node("..")
@onready var walls_top: Area2D = get_node("../Walls/Top")
@onready var walls_left: Area2D = get_node("../Walls/Left")
@onready var walls_right: Area2D = get_node("../Walls/Left")
@onready var walls_bottom: Area2D = get_node("../Walls/Left")

@onready var starting_position: Vector2 = global_position
# Keeps track of the slot this item currently lives in
var current_slot: Area2D = null

func _physics_process(delta: float) -> void:
	if is_dragging:
		global_position = get_global_mouse_position() - click_offset
	else:
		#print("self ", self)
		if current_slot == null:
			#await get_tree().process_frame
			var overlapping_areas = get_overlapping_areas()
			for area in overlapping_areas:
				if area.is_in_group("bricks_and_borders"):
					# print(self, "collision with ", area)
					match area:
						[walls_top, walls_bottom]:
							move_speed.y = -move_speed.y
						[walls_left, walls_right]:
							move_speed.x = -move_speed.x
						_: 
							move_speed = -move_speed
					rotation_speed = clampf(-rotation_speed * 1.1, -main.brick_max_rotation_speed, main.brick_max_rotation_speed) 
					position += 2 * move_speed * delta
					
					break # only collide in one direction
			# print("collision resolved for ", self)
			position += move_speed * delta
			rotation += rotation_speed * delta
		else:
			rotation = 0.0
			
func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT: 
				is_dragging = true
				click_offset = get_global_mouse_position() - global_position
				starting_position = global_position
				# Temporarily lift item layer so it renders above other slots/items
				z_index = 10 
			MOUSE_BUTTON_RIGHT:
				print("flip")
				var label = get_node("Label")
				var tween = create_tween()
				await tween.tween_property(self, "scale", Vector2(0.0, -1.0), 0.25).finished
				label.visible = not label.visible
				tween = create_tween()
				tween.tween_property(self, "scale", Vector2.ONE, 0.25)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if not event.pressed and is_dragging:
			is_dragging = false
			z_index = 0 # Reset layer depth
			attempt_drop()

func attempt_drop() -> void:
	var overlapping_areas = get_overlapping_areas()
	print("attempt_drop", overlapping_areas)
	var target_slot: Area2D = null
	
	for area in overlapping_areas:
		if area.is_in_group("slots"):
			target_slot = area
			print("slot: in slot")
			break
			
	if target_slot:
		if target_slot.current_item == null:
			# Clear old slot, occupy new slot.
			if current_slot:
				current_slot.current_item = null
			
			snap_to_slot(target_slot)
		
		elif target_slot.current_item == self:
			# Dropped back into its own slot. Just snap back.
			snap_to_slot(target_slot)
			
		else:
			# Slot is occupied. Trigger the swap!
			var existing_item = target_slot.current_item
			
			if current_slot:
				# Swap: Send the occupant to this item's previous slot
				current_slot.current_item = existing_item
				existing_item.snap_to_slot(current_slot)
			else:
				# If this item came from outside the slot system, return occupant to starting position
				existing_item.return_to_position(starting_position)
				existing_item.current_slot = null
				existing_item.rotation = existing_item.old_rotation
			
			snap_to_slot(target_slot)
	else:
		print("drop at arbitrary position, current slot", current_slot, ", position ", position)
		var rect = Rect2(main.brick_area_pos, main.brick_area_size)
		print("rect ", rect)
		
		if rect.has_point(position):
			print(" has point")
			if current_slot:
				current_slot.current_item = null
			current_slot = null
			rotation = old_rotation
		else:
			# Dropped in empty space, slide back home
			return_to_position(starting_position)

func snap_to_slot(slot: Area2D) -> void:
	print("snap_to_slot ", slot.index)
	current_slot = slot
	rotation = 0.0
	slot.current_item = self
	global_position = slot.global_position
	starting_position = global_position
	Signals.dropped.emit(slot.index, char)

func return_to_position(pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", pos, 0.15).set_trans(Tween.TRANS_SINE)
