extends Area2D

signal getCameraPos
signal currentlyWriting
signal stoppedWriting

var stopTexOut = false
var setLoc = false
var exitMenuOn = false

func _ready():
	notVisible()
	return

func notVisible():
	$Polygon2D.visible = false
	$Text.visible = false
	$Name.visible = false
	return

func Visible():
	$Polygon2D.visible = true
	$Text.visible = true
	$Name.visible = true
	return

func _on_DialogueTrigger_talk(character, dialogue, wait, locTop):
	setLoc = locTop
	
	wait = float(wait) /float(10)
	
	changeFont(character)
	
	emit_signal("getCameraPos")
	emit_signal("currentlyWriting")
	
	clear_text()
	if (!isVisible()):
		Visible()
	textOut(character, dialogue, wait)
	return

func textOut(character, dialText, wait):
	var timer
	
	$Name.text = character
	$Text.text = dialText
	$Text.visible_characters = 0
	
	for i in range(0, dialText.length() ):
		if stopTexOut:
			stopTexOut = false
			return
		if !dialText[i].match(" "):
			$Text.visible_characters = i
			timer = Timer.new()
			timer.set_wait_time(wait)
			timer.set_one_shot(true)
			self.add_child(timer)
			timer.start()
			yield(timer, "timeout")
			timer.queue_free()
		
		while exitMenuOn:
			$Text.visible_characters = i
			timer = Timer.new()
			timer.set_wait_time(wait)
			timer.set_one_shot(true)
			self.add_child(timer)
			timer.start()
			yield(timer, "timeout")
			timer.queue_free()
		
	$Text.visible_characters = -1
	emit_signal("stoppedWriting")
	return

func fast_set_text():
	stopTexOut = true
	$Text.visible_characters = -1
	emit_signal("stoppedWriting")
	return

func clear_text():
	$Text.text = ""
	$Name.text = ""
	return

func setTop(cameraY):
	position.y = cameraY - 75
	return

func setBottom(cameraY):
	position.y = cameraY + 275
	return

func isVisible():
	if $Polygon2D.visible == true:
		return true
	return false

func _on_Camera_location(cameraX, cameraY):
	position.x = cameraX - 32
	
	if(setLoc):
		setTop(cameraY) 
	else:
		setBottom(cameraY)
	
	setLoc = false
	return

func _on_DialogueTrigger_playerMovableAndHideDialogueBox():
	notVisible()
	return

func _on_DialogueTrigger_setTextFast():
	fast_set_text()
	return

#Fonts and Fonts
func changeFont(character):
	var characterList = ["Misty", "Skele", "Emwkins", "Teatle", "You"]
	
	if $Name.text == character:
		return 
	
	if character == characterList[0]:
		setFont("res://Fonts/Feltpen.ttf", 30)
	elif character == characterList[1]:
		setFont("res://Fonts/Avara.ttf", 40)
	elif character == characterList[2]:
		setFont("res://Fonts/Ravali.ttf", 50)
	elif character == characterList[3]:
		setFont("res://Fonts/d-puntillas-D-to-tiptoe.ttf", 30)
	else:
		setFont("res://Fonts/Cave-Story.ttf", 60)
	return

func setFont(fontPath, size):
	var dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load(fontPath)
	dynamic_font.size = size
	$Text.set("custom_fonts/normal_font", dynamic_font)
	$Name.set("custom_fonts/normal_font", dynamic_font)
	return

func _on_ExitMenu_startMenu():
	exitMenuOn = true
	return

func _on_ExitMenu_exitMenu():
	exitMenuOn = false
	return
