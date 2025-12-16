extends RigidBody3D


func _process(_delta: float) -> void:
	await get_tree().create_timer(1.5).timeout
	queue_free()
