extends RigidBody3D

#----
# Much of this script derives from the KidsCanCode arcade tut
#----

@onready var car_mesh: Node3D = $CarMesh
@onready var body_mesh: MeshInstance3D = $CarMesh/body
@onready var wheel_left: MeshInstance3D = $"CarMesh/wheel-front-left"
@onready var wheel_right: MeshInstance3D = $"CarMesh/wheel-front-right"
@onready var ground_ray: RayCast3D = $CarMesh/RayCast3D

var sphere_offset := Vector3.DOWN
var acceleration := 35.0
# Turn amount in degrees
var steering := 18.0
var turn_speed := 4.0
# Below this speed value, car won't turn
var turn_stop_limit := 0.75

var speed_input := 0.0
var turn_input := 0.0


func _physics_process(_delta: float) -> void:
	car_mesh.position = position + sphere_offset
	if ground_ray.is_colliding():
		apply_central_force(car_mesh.global_transform.basis.z * speed_input)
	

func _process(_delta: float) -> void:
	if not ground_ray.is_colliding():
		print("in air")
		return
	speed_input = Input.get_axis("brake", "accelerate") * acceleration
	turn_input = Input.get_axis("steer_left", "steer_right") * deg_to_rad(steering)
	wheel_right.rotation.y = turn_input
	wheel_left.rotation.y = turn_input
