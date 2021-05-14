extends Area2D

#Remember to connect the DialogueBox Node to the Trigger

signal talk(charcter, dialogue, wait, locTop)
signal stopPlayerMovement
signal playerMovableAndHideDialogueBox
signal setTextFast

export var randomTextfiles = false
export var loopFiles = false
export var textFile = ["res://Dialogue/Ex/ExText.txt", "res://Dialogue/Ex/ExText2.txt", "res://Dialogue/Ex/ExText3.txt"]

var currrentTextFile = 0
var lastIndex = 0

var changeDial = false
var entered = false
var currentlyWriting = false
var exitMenu = false
var changeFile = true

func _process(_delta):
	talk_or_not_talk()
	return

func _on_DialogueTrigger_body_entered(body):
	if body.get_name() == "Player":
		entered = true
	return

func _on_DialogueTrigger_body_exited(body):
	if body.get_name() == "Player":
		entered = false
	return

func talk_or_not_talk():
	if (Input.is_action_just_pressed("ui_accept") and entered and !(currentlyWriting) and lastIndex <= getFileMaxLine() and !exitMenu):
		if changeFile and randomTextfiles:
			getRandomTextfile()
			changeFile = false
		emit_signal("stopPlayerMovement")
		var dialogueArray = getLine()
		emit_signal("talk", str(dialogueArray[0]), replaceDialogue(str(dialogueArray[1])), str2var(dialogueArray[2]), trueOrFalse(dialogueArray[3]))
		increaseIndex()
	elif (Input.is_action_just_pressed("ui_accept") and entered and !(currentlyWriting) and lastIndex > getFileMaxLine()and !exitMenu):
		emit_signal("playerMovableAndHideDialogueBox")
		indexOrChange()
		changeFile = true
	elif (Input.is_action_just_pressed("ui_accept") and entered and currentlyWriting and !exitMenu):
		emit_signal("setTextFast")
	return

# Gets the lines from the file and then returns true 
func getLine():
	var result = []
	var f = File.new()
	
	
	f.open(str(textFile[currrentTextFile]), File.READ)
	while not f.eof_reached():
		var line = f.get_line()
		result.append(line)
	f.close()
	return lineToArray(result[lastIndex])

func lineToArray(line):
	var returnString = line.split(";", true)
	return returnString

func increaseIndex():
	lastIndex = lastIndex + 1
	return

# Determines if a string equlas to "true" and returns true, else it returns false
func trueOrFalse(strang):
	if (strang.to_lower() == "true"):
		return true
	return false

func _on_DialogueBox_stoppedWriting():
	currentlyWriting = false
	return

func _on_DialogueBox_currentlyWriting():
	currentlyWriting = true
	return

# (Might change to the next file or first file) and sets lastIndex to 0 
func indexOrChange():
	if (currrentTextFile == textFile.size() - 1 and loopFiles):
		currrentTextFile = 0
	elif (currrentTextFile < textFile.size() -1):
		currrentTextFile = currrentTextFile + 1
	lastIndex = 0
	return

# Replaces the ` characters with a new line (most players will not care either way)
func replaceDialogue(dialText):
	var tmp = ""
	for i in range (0, dialText.length()):
		if dialText[i] =='`':
			tmp += '\n'
		else:
			tmp += dialText[i]
	return str(tmp)

 # I am lazy and this function is used to find out how many max lines are in text file
func getFileMaxLine():
	var tmp = 0
	var f = File.new()
	f.open(str(textFile[currrentTextFile]), File.READ)
	while not f.eof_reached():
		f.get_line()
		tmp = tmp + 1
	f.close()
	return tmp-2

func _on_ExitMenu_startMenu():
	exitMenu = true
	return

func _on_ExitMenu_exitMenu():
	exitMenu = false
	return

func getRandomTextfile():
	var path = "res://Dialogue/" + get_parent().name + "/";
	var file = list_files_in_directory(path)
	
	path =  path + file
	
	textFile.clear()
	textFile.append(path)
	
	return

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
			
	dir.list_dir_end()
	
	var randFile  = randi() % files.size()
	
	return files[randFile]
