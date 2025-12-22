extends Node

var fire_truck_camera: Camera3D
var cannon_camera: Camera3D


func _unhandled_input(event: InputEvent) -> void:
	if cameras_are_ready():
		if event.is_action_pressed("switch_camera"):
			if fire_truck_camera.current == true:
				fire_truck_camera.current = false
				cannon_camera.current = true
			else:
				cannon_camera.current = false
				fire_truck_camera.current = true


func cameras_are_ready() -> bool:
	if fire_truck_camera is Camera3D and cannon_camera is Camera3D:
		return true
	return false


func _on_fire_truck_cam_readied(fire_truck_cam: Camera3D) -> void:
	fire_truck_camera = fire_truck_cam


func _on_cannon_camera_readied(water_cannon_camera: Camera3D) -> void:
	cannon_camera = water_cannon_camera
