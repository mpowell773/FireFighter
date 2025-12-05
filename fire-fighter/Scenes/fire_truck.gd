extends VehicleBody3D

@onready var cam_arm: SpringArm3D = $CamArm
@onready var wheel_back_left: VehicleWheel3D = $WheelBackLeft
@onready var wheel_back_right: VehicleWheel3D = $WheelBackRight
@onready var wheel_front_left: VehicleWheel3D = $WheelFrontLeft
@onready var wheel_front_right: VehicleWheel3D = $WheelFrontRight

var max_RPM := 450.0
var max_torque := 300.0
var turn_speed := 3.0
var turn_amount := 0.3

var z_movement := 0.0
var turn_movement := 0.0


func _ready() -> void:
	cam_arm.rotate_y(PI)


func _physics_process(delta: float) -> void:
	cam_arm.position = position
	
	
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
