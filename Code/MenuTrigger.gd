extends Area2D

signal startMenu
signal endMenu

var entered = false
var exitMenu = false
var active = false

func _process(_delta):
	if Input.is_action_just_released("ui_accept") and entered and !exitMenu:
		emit_signal("startMenu")
		active = true
	elif Input.is_action_just_released("ui_end") and !exitMenu:
		emit_signal("endMenu")
		active = false
	return

func _on_Area2D_body_exited(body):
	if body.get_name() == "Player":
		entered = false
	return

func _on_MenuTrigger_body_entered(body):
	if body.get_name() == "Player":
		entered = true
	return

func _on_ExitMenu_exitMenu():
	exitMenu = false
	if active:
		var timer
		timer = Timer.new()
		timer.set_wait_time(0.02)
		timer.set_one_shot(true)
		self.add_child(timer)
		timer.start()
		yield(timer, "timeout")
		timer.queue_free()
		emit_signal("startMenu")
	return

func _on_ExitMenu_startMenu():
	exitMenu = true
	return
