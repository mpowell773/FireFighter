extends VehicleBody3D

signal fire_truck_cam_readied(fire_truck_cam: Camera3D)
signal cannon_camera_readied(water_cannon_camera: Camera3D)

var max_RPM := 450.0
var max_torque := 300.0
var turn_speed := 3.0
var turn_amount := 0.3

var z_movement := 0.0
var turn_movement := 0.0

var has_corrected_vehicle_tip := false

@onready var cam_arm: SpringArm3D = $FireTruckCam
@onready var wheel_back_left: VehicleWheel3D = $WheelBackLeft
@onready var wheel_back_right: VehicleWheel3D = $WheelBackRight
@onready var wheel_front_left: VehicleWheel3D = $WheelFrontLeft
@onready var wheel_front_right: VehicleWheel3D = $WheelFrontRight
@onready var vehicle_tip_timer: Timer = $VehicleTipTimer


func _physics_process(delta: float) -> void:	
	correct_vehicle_tip()
	compute_vehicle_forces(delta)


func _process(_delta: float) -> void:
	z_movement = Input.get_axis("accelerate", "brake") * -1.0
	turn_movement = Input.get_axis("steer_left", "steer_right") * -1.0
	
	cam_arm.position = position


func compute_vehicle_forces(delta: float) -> void:
	var RPM_left := absf(wheel_back_left.get_rpm())
	var RPM_right := absf(wheel_back_right.get_rpm())
	var RPM := (RPM_left + RPM_right) / 2.0
	
	var torque := z_movement * max_torque * (1.0 - RPM / max_RPM)
	
	engine_force = torque
	steering = lerp(steering, turn_movement * turn_amount, turn_speed * delta)
	
	if z_movement == 0:
		brake = 2


func correct_vehicle_tip() -> void:
	if absf(global_rotation_degrees.z) > 25.0:
		var correction_force := 1750.0
		if signf(global_rotation_degrees.z) == 1:
			apply_torque(-basis.z * correction_force)
		else:
			apply_torque(basis.z * correction_force)

# Currently not in use.
func all_wheels_in_contact() -> bool:
	if wheel_back_left.is_in_contact()\
		and wheel_back_right.is_in_contact()\
		and wheel_front_left.is_in_contact()\
		and wheel_front_right.is_in_contact():
			return true
	return false


func _on_fire_truck_cam_readied(fire_truck_cam: Camera3D) -> void:
	fire_truck_cam_readied.emit(fire_truck_cam)


func _on_water_cannon_camera_readied(cannon_camera: Camera3D) -> void:
	cannon_camera_readied.emit(cannon_camera)
