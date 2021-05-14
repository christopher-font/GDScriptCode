extends Area2D

signal startMenu
signal exitMenu

var yesSelected = false;
var active = false

func _ready():
	visible = false
	updateDisplay()
	return

func _process(_delta):
	if active:
		changeSelection()
		if Input.is_action_just_released("ui_accept"):
			selection()
	elif Input.is_action_just_released("quit") and !active:
		active = true
		visible = true
		emit_signal("startMenu")
	return

func changeSelection():
	if Input.is_action_just_pressed("ui_left") and !yesSelected:
		yesSelected = true
		updateDisplay()
	elif Input.is_action_just_pressed("ui_right") and yesSelected:
		yesSelected = false
		updateDisplay()
	return

func selection():
	if yesSelected:
		get_tree().quit()
	else:
		active = false
		visible =  false
		emit_signal("exitMenu")
	return 

func updateDisplay():
	var selectedColor = Color(0.43,0.19,0.19,1)
	var defaultColor = Color(0.11,0.11,0.11,1)
	
	if yesSelected: 
		$Yes.color = selectedColor
		$No.color = defaultColor
	else: 
		$Yes.color = defaultColor
		$No.color = selectedColor
	return
