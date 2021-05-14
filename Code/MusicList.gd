extends Node2D

var selection = 0
var active = false
var exitMenuActive = false
var lastSelected = -1

export var musicList = ["res://Music/Firage-Kobold_Bandit_Camp.wav",
"res://Music/01_Zipp_-_Pour_Quoi_Royale.wav",
"res://Music/03_Astat_-_Daily_Dozen.wav",
"res://Music/Girl_Talk-All_Day.wav",
"res://Music/Firage-Happy_Puppycore.wav",
"res://Music/ToscaniniBeethoven5.wav",
"res://Music/RValkyries.wav",
"res://Music/01ReliableSource.wav"
]

func _ready():
	startupSelection()
	updateSelection()
	visible = false
	changeDeflMusic()
	randomize()
	return

func _process(_delta):
	if active and !exitMenuActive:
		selectionChange()
		if Input.is_action_just_pressed("ui_accept"):
			changeDeflMusic()
			pass
	return

func selectionChange():
	var maxSelection = 7
	var minSelection = 0
	
	if Input.is_action_just_pressed("ui_down") and not (selection + 2 > maxSelection):
		selection = selection + 2
		updateDisplay(selection - 2)
	elif Input.is_action_just_pressed("ui_right") and not (selection + 1 > maxSelection):
		selection = selection + 1
		updateDisplay(selection - 1)
	elif Input.is_action_just_pressed("ui_left") and not (selection - 1 < minSelection):
		selection = selection - 1
		updateDisplay(selection + 1)
	elif Input.is_action_just_pressed("ui_up") and not (selection - 2 < minSelection):
		selection = selection - 2
		updateDisplay(selection + 2)
	return

func updateDisplay(previousSelection):
	updatePreviousSelection(previousSelection)
	return updateSelection()

func updatePreviousSelection(pSelect):
	var defaultColor = Color(0.8,0.8,0.8,1)
	match pSelect:
		0:
			$Label0.modulate = defaultColor
		1:
			$Label1.modulate = defaultColor
		2:
			$Label2.modulate = defaultColor
		3:
			$Label3.modulate = defaultColor
		4:
			$Label4.modulate = defaultColor
		5:
			$Label5.modulate = defaultColor
		6:
			$Label6.modulate = defaultColor
		7:
			$Label7.modulate = defaultColor
	return

func updateSelection():
	var selectedColor = Color(1.2,1.2,1.2,1)
	match selection:
		0:
			$Label0.modulate = selectedColor
		1:
			$Label1.modulate = selectedColor
		2:
			$Label2.modulate = selectedColor
		3:
			$Label3.modulate = selectedColor
		4:
			$Label4.modulate = selectedColor
		5:
			$Label5.modulate = selectedColor
		6:
			$Label6.modulate = selectedColor
		7:
			$Label7.modulate = selectedColor
	return

func _on_MenuTrigger_startMenu():
	visible = true
	active = true
	return

func _on_MenuTrigger_endMenu():
	visible = false
	active = false
	return

func _on_ExitMenu_exitMenu():
	exitMenuActive = false 
	return

func _on_ExitMenu_startMenu():
	exitMenuActive = true
	return

func changeDeflMusic():
	if selection != lastSelected:
		$Defl.stop()
		$Defl.stream = load(musicList[selection])
		$Defl.play()
		lastSelected = selection
	return

func startupSelection():
	var selectedColor = Color(0.8,0.8,0.8,1)
	$Label0.modulate = selectedColor
	$Label1.modulate = selectedColor
	$Label2.modulate = selectedColor
	$Label3.modulate = selectedColor
	$Label4.modulate = selectedColor
	$Label5.modulate = selectedColor
	$Label6.modulate = selectedColor
	$Label7.modulate = selectedColor
	return 
