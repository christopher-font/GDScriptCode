extends KinematicBody2D

var stopMovement = false
const SPEED = 200

var movedir = Vector2(0,0)

func _process(_delta):
	if!stopMovement:
		control_loop()
		movement_loop()
	if Input.is_action_just_pressed("changeFullscreen"):
		changeScreenSize()
	return

func changeScreenSize():
	OS.window_fullscreen = !OS.window_fullscreen
	return

func control_loop():
	var left = Input.is_action_pressed("ui_left")
	var right = Input.is_action_pressed("ui_right")
	var down = Input.is_action_pressed("ui_down")
	var up = Input.is_action_pressed("ui_up")
	
	movedir.x = int(right) - int(left)
	movedir.y = int(down) - int(up)
	return

func movement_loop():
	var totalSpeed = 0
	totalSpeed = runing()
	var motion = movedir.normalized() * totalSpeed
	
	if motion == Vector2(0,0) and ($AnimatedSprite.get_frame() == 10 or 28) and $AnimatedSprite.animation == "Walking":
		$AnimatedSprite.play("Standing")
	else:
		if (motion.x < 0 or motion.y < 0) and $AnimatedSprite.animation == "Standing":
			$AnimatedSprite.play("Walking", false)
			$AnimatedSprite.set_frame(21)
		elif ((motion.x > 0 or motion.y > 0) and $AnimatedSprite.animation == "Standing"):
			$AnimatedSprite.play("Walking", true)
	# warning-ignore:return_value_discarded
	move_and_slide(motion, Vector2(0,0))
	return

func runTimerStart():
	if $RunTimer.is_stopped():
		$RunTimer.start()
	return

func runing():
	var tempSpeed = SPEED
	if Input.is_action_just_pressed("ui_shift"):
		runTimerStart()
	elif Input.is_action_pressed("ui_shift"):
		tempSpeed += SPEED * (($RunTimer.wait_time - $RunTimer.time_left)/$RunTimer.wait_time)
	elif !Input.is_action_just_released("ui_shift"):
		runTimerStop()
	return tempSpeed

func runTimerStop():
	var wTime = 2.5
	$RunTimer.stop()
	$RunTimer.wait_time = wTime
	return

func _on_ExitMenu_startMenu():
	return stopMovementNow()

func _on_ExitMenu_exitMenu():
	stopMovement = false
	return

func _on_DialogueTrigger_stopPlayerMovement():
	return stopMovementNow()

func _on_DialogueTrigger_playerMovableAndHideDialogueBox():
	stopMovement = false
	return

func _on_MenuTrigger_startMenu():
	return stopMovementNow()

func _on_MenuTrigger_endMenu():
	stopMovement = false
	return

func stopMovementNow():
	$AnimatedSprite.play("Standing")
	stopMovement = true
	return
