extends Camera2D

signal location(x, y)

func _on_DialogueBox_getCameraPos():
	var cameraLoc = get_camera_screen_center()
	var x = cameraLoc.x
	var y = cameraLoc.y
	emit_signal("location", x, y)
	return 
