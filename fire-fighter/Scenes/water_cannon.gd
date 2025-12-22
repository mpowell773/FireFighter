extends Node3D

signal cannon_camera_readied(cannon_camera: Camera3D)

@export var water_drop_scene: PackedScene
@export var impulse_strength := 25.0

var has_water_initialized := false
var water_projectiles_manager: Node3D = null

@onready var cannon_exit: Marker3D = $CannonMesh/CannonExit
@onready var cannon_cam: Camera3D = $CameraOffset/SpringArm3D/CannonCam


func _ready() -> void:
	cannon_camera_readied.emit(cannon_cam)


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot_cannon"):
		if water_projectiles_manager:
			var water_drop = water_drop_scene.instantiate() as RigidBody3D
			water_projectiles_manager.add_child(water_drop)
			water_drop.position = cannon_exit.global_position
			water_drop.apply_impulse(get_forward_direction() * impulse_strength)


func _process(_delta: float) -> void:
	if not has_water_initialized:
		assign_water_project_manager()


func get_forward_direction() -> Vector3:
	return cannon_exit.global_transform.basis.z 
	

func assign_water_project_manager() -> void:
	water_projectiles_manager = get_tree().get_first_node_in_group("water_projectile")
	if is_instance_valid(water_projectiles_manager):
		has_water_initialized = true
