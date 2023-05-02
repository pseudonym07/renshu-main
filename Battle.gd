#Script gains accesss to all the properties and functions of the Control Node.
extends Control


#Variables for stat values the for player and call @export for stats from BaseEnemy to be used.
@export var enemy : Resource = null


var currentPlayerHP = 0
var currentPlayerSP = 0
var currentEnemyHP = 0


#List that store strings to be used for skill menu animation
var skillsMenu = ["BuffATK", "BuffDEF", "Heal"]
var isDefending = false
var playerATKBuff = false
var playerDEFBuff = false
var healAMT = 0


# Function is called after the Control node and its children have been first added to the SceneTree (Manages the game loop via a hierarchy of nodes.)
#Sets health for the player(State) and enemy along with initializing randomization stats and obtaining Control node's children to be used.
func _ready():
	setHealth($MonsterHPContainer, enemy.health, enemy.health)
	setHealth($ActionsPanel/Bars/HealthPercent, State.currentHP, State.maxHP)
	setMagic($ActionsPanel/Bars/MagicPercent, State.currentSP, State.maxSP)
	
	randomize()
	
	currentPlayerHP = State.currentHP
	currentPlayerSP = State.currentSP
	currentEnemyHP = enemy.health
	
	get_children()
	
	
#Function is called every frame. Randomizes the player's damage, enemy damage, and the amount of health the heal skills restores.
func _process(delta):
	
	enemy.damage = randi_range(50, 75)
	State.damage = randi_range(20, 35)
	healAMT = randi_range(25, 55)


#Function handles input for the player to exit with their escape key.
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_ESCAPE:
			get_tree().quit()


#Function sets the health for entities within the game enviroment.
func setHealth(progressBar, health, maxHP):
	progressBar.value = health
	progressBar.max_value = maxHP
	progressBar.get_node("Health Label").text = "%d/%d" % [health, maxHP]


#Function sets the magic for the player.
func setMagic(progressBar, magic, maxSP):
	progressBar.value = magic
	progressBar.max_value = maxSP
	progressBar.get_node("MagicLabel").text = "%d/%d" % [magic, maxSP]


#Function that uses a string parameter to set the system message that I'd like to use for any use.
func putSysText(text):
	$SystemText.text = text


#Function for the enemy's turn. If-statements for weather or not the player is defending and if they use their buffs.
func enemyTurn():
	putSysText("The Sketch Dragon lashes about!")
	await get_tree().create_timer(1.5).timeout

	if isDefending == true:
		isDefending = false
		$AnimPlayer.play("defend")
		await $AnimPlayer.animation_finished
		putSysText("You braced for the attack sucessfully!")
		await get_tree().create_timer(1.5).timeout
	else:
		if playerDEFBuff == true:
			
			$AnimPlayer.play("screen_shake")
			await $AnimPlayer.animation_finished
			currentPlayerHP = max(0, currentPlayerHP - (enemy.damage - 25))
			setHealth($ActionsPanel/Bars/HealthPercent, currentPlayerHP, State.maxHP)
			putSysText("The Sketch Dragon did " + " " + str(enemy.damage - 25 ) + " damage!")
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


#Function is called when the attack button is pressed.
#It takes into account wether or not the player buffs their attack and formats the system message, damage calculation, damage animation accordingly.
func _on_attack_button_pressed():
	putSysText("You swing your mighty blade!")
	await get_tree().create_timer(1).timeout
	$AnimPlayer.play("enemy_damaged")
	await $AnimPlayer.animation_finished
	
	if playerATKBuff == true:
		
		currentEnemyHP = max(0, currentEnemyHP - (State.damage *2))
		setHealth($MonsterHPContainer, currentEnemyHP, enemy.health)
		putSysText("You did " + " " + str(State.damage * 2) + " damage!")
		await get_tree().create_timer(1.5).timeout 
	else:
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


#Function is called when the defend button is pressed. Does system formatting and action animation accordingly.
func _on_defend_button_pressed():
	isDefending = true
	putSysText("You yield steady for an attack!")
	await get_tree().create_timer(1.5).timeout
	$AnimPlayer.play("defend")
	await $AnimPlayer.animation_finished
	enemyTurn()


#Function is called when the skill button is pressed. This function is responsible for the animation of the skill menu appearing.
func _on_skill_button_pressed():
	var skillPanel = get_node("SkillsMenu")
	skillPanel.show()
	for skill in skillsMenu:
		if skill == skillsMenu[0]:
			var skill1 = get_node("SkillsMenu/Skill 1")
			await get_tree().create_timer(.25).timeout
			skill1.show()
		elif skill == skillsMenu[1]:
			var skill2 = get_node("SkillsMenu/Skill 2")
			await get_tree().create_timer(.25).timeout
			skill2.show()
		elif skill == skillsMenu[2]:
			var skill3 = get_node("SkillsMenu/Skill 3")
			await get_tree().create_timer(.25).timeout
			skill3.show()


#Function is called when Skill Button 1 (Spirit Riser) is pressed.
#This function is responsible for buffing the player's attack stat.
func _on_skill_1_pressed():
	var skillPanel = get_node("SkillsMenu")
	playerATKBuff = true
	skillPanel.hide()
	await get_tree().create_timer(.5).timeout
	putSysText("You raised your attack!(-40SP)")
	await get_tree().create_timer(1.5).timeout 
	currentPlayerSP = max(0, currentPlayerSP - 40)
	setMagic($ActionsPanel/Bars/MagicPercent, currentPlayerSP, State.maxSP)
	enemyTurn()	


#Function is called when Skill Button 1 (Soul Riser) is pressed.
#This function is responsible for buffing the player's defense stat.
func _on_skill_2_pressed():
	var skillPanel = get_node("SkillsMenu")
	playerDEFBuff = true
	skillPanel.hide()
	await get_tree().create_timer(.5).timeout
	putSysText("You raised your defense!(-60SP)")
	await get_tree().create_timer(1.5).timeout
	currentPlayerSP = max(0, currentPlayerSP - 60)
	setMagic($ActionsPanel/Bars/MagicPercent, currentPlayerSP, State.maxSP)
	enemyTurn()


#Function is called when Skill Button 1 (Spirit Riser) is pressed.
#This function is responsible for healing the player..
func _on_skill_3_pressed():
	var skillPanel = get_node("SkillsMenu")
	currentPlayerHP = max(0, currentPlayerHP + healAMT)
	skillPanel.hide()
	await get_tree().create_timer(.5).timeout
	putSysText("You raised restored your health for " + str(healAMT) + "HP!(-25SP)")
	setHealth($ActionsPanel/Bars/HealthPercent, currentPlayerHP, State.maxHP)
	await get_tree().create_timer(1.5).timeout
	currentPlayerSP = max(0, currentPlayerSP - 25)
	setMagic($ActionsPanel/Bars/MagicPercent, currentPlayerSP, State.maxSP)
	enemyTurn()
	
