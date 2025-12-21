extends SpringArm3D

var mouse_sensitivity := 0.1
var reset_auto_camera_time := 1.0

var fire_truck: VehicleBody3D
var has_been_selected := false 

var tween: Tween
var offset_rotation_pos := Vector3(deg_to_rad(-23.0),deg_to_rad(180.0), 0.0)
var default_rotation_pos: Vector3
var is_manual_camera := false

@onready var reset_cam_timer: Timer = $ResetCamTimer


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_as_top_level(true)
	rotation = offset_rotation_pos


func _process(_delta: float) -> void:
	if not has_been_selected:
		fire_truck = assign_firetruck_variable()
	else:
		var update_rotation_pos := (Vector3(fire_truck.rotation.x,
									fire_truck.rotation.y,
									0.0)
									+ offset_rotation_pos
									)
		update_shortest_rotation_pos(update_rotation_pos)
		
	if not is_manual_camera:
			reset_to_default_position(0.5)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		is_manual_camera = true
		delete_existing_tween(tween)
		
		rotation_degrees.x -= event.relative.y * mouse_sensitivity
		rotation_degrees.x = clampf(rotation_degrees.x, -90.0, -10.0)
		
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		rotation_degrees.y = wrapf(rotation_degrees.y, 0.0, 360.0)
		
		reset_cam_timer.start(reset_auto_camera_time)
		
		
	# Debug tool to exit out of screen easily.
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func reset_to_default_position(duration) -> void:
	delete_existing_tween(tween)

	tween = create_tween()
	tween.tween_property(self, "rotation", default_rotation_pos, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_OUT)
	
	
func delete_existing_tween(_tween: Tween) -> void:
	if _tween and _tween.is_valid():
		_tween.kill()


func assign_firetruck_variable() -> VehicleBody3D:
	var parent := get_parent()
	
	if parent is VehicleBody3D:
		has_been_selected = true
		return parent
		
	return null


func update_shortest_rotation_pos(target_rotation_pos: Vector3) -> void:
	var current_rotation_y := rotation.y
	# Calculate shortest angle
	target_rotation_pos.y = (current_rotation_y
							+ fposmod(target_rotation_pos.y
							- current_rotation_y
							+ PI, TAU) - PI
							)
	
	default_rotation_pos = target_rotation_pos


func _on_reset_cam_timer_timeout() -> void:
	is_manual_camera = false
