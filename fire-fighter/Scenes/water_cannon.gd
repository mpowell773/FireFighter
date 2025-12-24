extends Node3D

signal cannon_camera_readied(cannon_camera: Camera3D)

@export var water_drop_scene: PackedScene
@export var impulse_strength := 25.0

var rotation_strength := 1.5
var vertical_minimum_angle := deg_to_rad(-29.7)
var vertical_maximum_angle := deg_to_rad(17.3)

var has_water_initialized := false
var water_projectiles_manager: Node3D = null

@onready var connector_mesh: MeshInstance3D = $ConnectorMesh
@onready var cannon_mesh: MeshInstance3D = $ConnectorMesh/CannonMesh
@onready var cannon_exit: Marker3D = $ConnectorMesh/CannonMesh/CannonExit
@onready var cannon_cam: Camera3D = $ConnectorMesh/CannonMesh/CameraOffset/SpringArm3D/CannonCam


func _ready() -> void:
	cannon_camera_readied.emit(cannon_cam)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot_cannon"):
		if water_projectiles_manager:
			var water_drop = water_drop_scene.instantiate() as RigidBody3D
			water_projectiles_manager.add_child(water_drop)
			water_drop.position = cannon_exit.global_position
			water_drop.apply_impulse(get_forward_direction() * impulse_strength)


func _process(delta: float) -> void:
	if not has_water_initialized:
		assign_water_project_manager()
	
	# Rotate cannon left and right
	var x_input := Input.get_axis("cannon_left", "cannon_right")
	var new_x_coord := connector_mesh.rotation.y - x_input * delta * rotation_strength 
	connector_mesh.rotation.y = clampf(new_x_coord, -PI * 0.25, PI * 0.25)
	
	# Rotate cannon up and down
	var y_input := Input.get_axis("cannon_down", "cannon_up")
	var new_y_coord := cannon_mesh.rotation.x - y_input * delta * rotation_strength 
	cannon_mesh.rotation.x = clampf(new_y_coord, vertical_minimum_angle, vertical_maximum_angle)


func get_forward_direction() -> Vector3:
	return cannon_exit.global_transform.basis.z 


func assign_water_project_manager() -> void:
	water_projectiles_manager = get_tree().get_first_node_in_group("water_projectile")
	if is_instance_valid(water_projectiles_manager):
		has_water_initialized = true
