extends VehicleBody3D

var max_RPM := 450.0
var max_torque := 300.0
var turn_speed := 3.0
var turn_amount := 0.3

var z_movement := 0.0
var turn_movement := 0.0

var has_corrected_vehicle_tip := false

@onready var cam_arm: SpringArm3D = $CamArm
@onready var wheel_back_left: VehicleWheel3D = $WheelBackLeft
@onready var wheel_back_right: VehicleWheel3D = $WheelBackRight
@onready var wheel_front_left: VehicleWheel3D = $WheelFrontLeft
@onready var wheel_front_right: VehicleWheel3D = $WheelFrontRight
@onready var vehicle_tip_timer: Timer = $VehicleTipTimer


func _physics_process(delta: float) -> void:
	cam_arm.position = position
	
	if all_wheels_in_contact():
		pass
	correct_vehicle_tip()

	var RPM_left := absf(wheel_back_left.get_rpm())
	var RPM_right := absf(wheel_back_right.get_rpm())
	var RPM := (RPM_left + RPM_right) / 2.0
	
	var torque := z_movement * max_torque * (1.0 - RPM / max_RPM)
	
	engine_force = torque
	steering = lerp(steering, turn_movement * turn_amount, turn_speed * delta)
	
	if z_movement == 0:
		brake = 2


func _process(_delta: float) -> void:
	z_movement = Input.get_axis("accelerate", "brake") * -1.0
	turn_movement = Input.get_axis("steer_left", "steer_right") * -1.0


func correct_vehicle_tip() -> void:
	if absf(global_rotation_degrees.z) > 60.0 and not has_corrected_vehicle_tip:
		#axis_lock_angular_x = true
		#axis_lock_angular_y = true
		
		var correction_force := 2000.0
		if signf(global_rotation_degrees.z) == 1:
			var correction_torque := Vector3(0.0, 0.0, -1.0) * correction_force
			apply_torque_impulse(correction_torque * global_transform.basis)
			
		else:
			var correction_torque := Vector3(0.0, 0.0, 1.0) * correction_force
			apply_torque_impulse(correction_torque * global_basis)
		apply_impulse(Vector3.UP * 500.0)
		
		has_corrected_vehicle_tip = true
		vehicle_tip_timer.start()


func all_wheels_in_contact() -> bool:
	if wheel_back_left.is_in_contact()\
		and wheel_back_right.is_in_contact()\
		and wheel_front_left.is_in_contact()\
		and wheel_front_right.is_in_contact():
			return true
	return false


func _on_vehicle_tip_timer_timeout() -> void:
	has_corrected_vehicle_tip = false
