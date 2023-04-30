extends Control

signal system_seen

@export var enemy : Resource = null

var currentPlayerHP = 0
var currentPlayerSP = 0
var currentEnemyHP = 0
var isDefending = false


func _ready():
	setHealth($MonsterHPContainer, enemy.health, enemy.health)
	setHealth($ActionsPanel/Bars/HealthPercent, State.currentHP, State.maxHP)
	setMagic($ActionsPanel/Bars/MagicPercent, State.currentSP, State.maxSP)
	
	currentPlayerHP = State.currentHP
	currentPlayerSP = State.currentSP
	currentEnemyHP = enemy.health
	
	randomize()
	enemy.damage = randi_range(20, 35)
	
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()



func setHealth(progressBar, health, maxHP):
	progressBar.value = health
	progressBar.max_value = maxHP
	progressBar.get_node("Health Label").text = "%d/%d" % [health, maxHP]



func setMagic(progressBar, magic, maxSP):
	progressBar.value = magic
	progressBar.max_value = maxSP
	progressBar.get_node("MagicLabel").text = "%d/%d" % [magic, maxSP]







func putSysText(text):
	$SystemText.text = text


func enemyTurn():
	putSysText("The Sketch Dragon lashes about!")
	await get_tree().create_timer(1.5).timeout

	if isDefending:
		isDefending = false
		$AnimPlayer.play("defend")
		await $AnimPlayer.animation_finished
		putSysText("You braced for the attack sucessfully!")
		await get_tree().create_timer(1.5).timeout
	else:
		$AnimPlayer.play("screen_shake")
		await $AnimPlayer.animation_finished
		currentPlayerHP = max(0, currentPlayerHP - enemy.damage)
		setHealth($ActionsPanel/Bars/HealthPercent, currentPlayerHP, State.maxHP)
		putSysText("The Sketch Dragon did " + " " + str(enemy.damage) + " damage!")
		

		if currentPlayerHP == 0:
			putSysText("HP hit zero! You've been knocked out!")
			await get_tree().create_timer(2).timeout
			get_tree().change_scene_to_file("res://GameOver.tscn")

func _on_skill_button_pressed():
	putSysText("You used your fight-flight skill! (-4OSP)")
	currentPlayerSP = max(0, currentPlayerSP - 40)
	setMagic($ActionsPanel/Bars/MagicPercent, currentPlayerSP, State.maxSP)
	await get_tree().create_timer(1.55).timeout
	
	putSysText("You got away! " + "Try again next time.")
	await get_tree().create_timer(1.65).timeout
	get_tree().quit()


func _on_attack_button_pressed():
	putSysText("You swing your mighty blade!")
	await get_tree().create_timer(1).timeout
	$AnimPlayer.play("enemy_damaged")
	await $AnimPlayer.animation_finished
	currentEnemyHP = max(0, currentEnemyHP - State.damage)
	setHealth($MonsterHPContainer, currentEnemyHP, enemy.health)
	putSysText("You did " + " " + str(State.damage) + " damage!")
	await get_tree().create_timer(1.5).timeout	 
	
	if currentEnemyHP == 0:
		$AnimPlayer.play("enemy_death")
		await $AnimPlayer.animation_finished
		putSysText("You've defeated The Sketch Dragon!")
		await get_tree().create_timer(1.5).timeout
		get_tree().change_scene_to_file("res://VictoryScn.tscn")
	else:
		enemyTurn()


func _on_defend_button_pressed():
	isDefending = true
	putSysText("You yield steady for an attack!")
	await get_tree().create_timer(1.5).timeout
	$AnimPlayer.play("defend")
	await $AnimPlayer.animation_finished
	enemyTurn()
