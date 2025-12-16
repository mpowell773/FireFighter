extends Node3D

@export var water_drop_scene: PackedScene
@export var impulse_strength := 25.0

@onready var cannon_exit: Marker3D = $CannonExit


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("shoot_cannon"):
		var water_drop = water_drop_scene.instantiate()
		add_child(water_drop)
		set_deferred(str(water_drop.global_position), cannon_exit.position)
		water_drop.apply_impulse(get_forward_direction() * impulse_strength)


func get_forward_direction() -> Vector3:
	return cannon_exit.global_transform.basis.z 
