class_name BattleConductor
extends Node2D

signal execute_turn
signal end_battle
signal exit_battle

enum BattleResult {
	GAME_OVER,
	KILL,
	BOND
}

onready var dialog_box: DialogBox = get_node("GUILayer/DialogBox")

var enemy: Enemy
var player: Player
var player_lifebar: LifeBar
var enemy_lifebar: LifeBar
var specter_lifebar: LifeBar

func _ready():
	enemy = get_node("Enemy")
	player = get_node("Player")

	player_lifebar = get_node("GUILayer/PlayerLifeBar")
	enemy_lifebar = get_node("GUILayer/EnemyLifeBar")
	specter_lifebar = get_node("GUILayer/PlayerLifeBar/SpecterLifeBar")

	var err = self.connect("execute_turn", self, "_execute_turn")
	if err:
		get_tree().quit(err)
	err = self.connect("end_battle", self, "_end_battle")
	if err:
		get_tree().quit(err)

func start_battle(enemy_template: SpecterResource, enemy_lf: int, player_lf: int) -> void:
	enemy.reset(enemy_template, enemy_lf)
	player.reset(120, player_lf)
	player.specter.reset()

	player_lifebar.reset_bar(player.life_force)
	enemy_lifebar.reset_bar(enemy.life_force)
	specter_lifebar.reset_bar(
		player.specter.life_force,
		player.specter.life_force.maximum as float/player.life_force.maximum as float
	)
	
	if (!get_node("/root/GameRoot").bonded_specters.size()):
		var wait = dialog_box.say("You encounter a mysterious specter.", 2.0)
		if wait is GDScriptFunctionState: yield(wait, "completed")
	else:
		var wait = dialog_box.say("A hostile specter haunts you!")
		if wait is GDScriptFunctionState: yield(wait, "completed")
	
	self.emit_signal("execute_turn")

func _execute_turn():
	var wait
	var player_initial_state := player.get_state()
	var actions = _request_actions(player_initial_state)
	if actions is GDScriptFunctionState:
		actions = yield(actions, "completed")

	# Specter Action
	wait = _perform_specter_action(actions.specter)
	if wait is GDScriptFunctionState: yield(wait,"completed")

	if enemy.life_force.current == 0:
		enemy.queue_free()
		enemy_lifebar.reset_bar(LifeForce.new(0.0), 0.0)
		emit_signal("end_battle", true)
		return

	# Enemy  Action
	wait = _perform_enemy_action("ATTACK")
	if wait is GDScriptFunctionState: yield(wait,"completed")	

	if player.life_force.current == 0:
		player.queue_free()
		player_lifebar.reset_bar(LifeForce.new(0.0), 0.0)
		emit_signal("end_battle", false)
		return

	# Player  Action
	wait = _perform_player_action(actions.player)
	if wait is GDScriptFunctionState: 
		yield(wait,"completed")

	if player.life_force.current == 0:
		player.queue_free()
		player_lifebar.reset_bar(LifeForce.new(0.0), 0.0)
		emit_signal("end_battle", false)
		return

	if enemy.bonded == true:
		emit_signal("end_battle", true, true)
		return

	emit_signal("execute_turn")

func _end_battle(won: bool, bonded = false):
	var wait
	if won:
		if bonded:
			wait = dialog_box.say("You and the specter have become one.")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			emit_signal("exit_battle", {
				"outcome": BattleResult.BOND,
			})
		else:
			wait = dialog_box.say("The hostile specter fades away...")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			emit_signal("exit_battle", {
				"outcome": BattleResult.KILL,
			})
	else:
		wait = dialog_box.say("Your vision grows dark...")
		if wait is GDScriptFunctionState: yield(wait, "completed")
		emit_signal("exit_battle", {
			"outcome": BattleResult.GAME_OVER,
		})
		

func _get_available_actions(menu: String, state: Dictionary) -> Array:
	var actions = []
	match menu:
		"PLAYER":
			if (!get_node("/root/GameRoot").bonded_specters.size()):
				return [{
					"key": "BOND",
					"text": "BOND",
					"description": "Bond the target specter to your soul."
				}]
			actions.append({
				"key": "REST",
				"text": "REST",
				"description": "Regenerate your life force."
			})
			if state.specter.awake:
				actions.append({
					"key": "FORTIFY",
					"text": "FORTIFY",
					"description": "Transfer life force to your specter."
				})
			else:
				actions.append({
					"key": "AWAKEN",
					"text": "AWAKEN",
					"description": "Call your specter to action."
				})
		"SPECTER":
			actions.append({
				"key": "ATTACK",
				"text": "ZAP",
				"description": "Attack the target specter with a jolt of energy."
			})
	return actions

func _request_actions(state: Dictionary):
	var specter_action = ""
	if (state.specter.awake):
		specter_action = dialog_box.get_player_choice(
			"What will your specter do?",
			_get_available_actions("SPECTER", state)
		)
		if specter_action is GDScriptFunctionState:
			specter_action = yield(specter_action, "completed")
	var player_action = dialog_box.get_player_choice(
		"What will you do?",
		_get_available_actions("PLAYER", state)
	)
	if player_action is GDScriptFunctionState:
		player_action = yield(player_action, "completed")
	return {
		"player": player_action,
		"specter": specter_action
	}

func _perform_specter_action(action: String):
	var wait
	match action:
		"ATTACK":
			wait = dialog_box.say("Your specter zaps the hostile specter!")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = player.specter.anim_attack()
			if wait is GDScriptFunctionState: yield(wait,"completed")
			
			var enemy_initial_state = enemy.get_state()
			enemy.receive_damage(10)

			if enemy_initial_state.life_force != enemy.life_force.current:
				wait = enemy.anim_take_damage()
				if wait is GDScriptFunctionState: yield(wait, "completed")
				wait = enemy_lifebar.update_bar(enemy.life_force.current)
				if wait is GDScriptFunctionState: yield(wait, "completed")
				wait = dialog_box.say("The hostile specter suffers damage.")
				if wait is GDScriptFunctionState: yield(wait, "completed")

func _perform_enemy_action(action: String):
	var wait
	if (!get_node("/root/GameRoot").bonded_specters.size()):
		wait = dialog_box.say("The specter appears to be fading away.")
		if wait is GDScriptFunctionState: yield(wait, "completed")
		return

	match action:
		"ATTACK":
			wait = dialog_box.say("The hostile specter strikes you!")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = enemy.anim_attack()
			if wait is GDScriptFunctionState: yield(wait,"completed")

			var player_initial_state = player.get_state()
			var specter_initial_state = player_initial_state.specter

			var damage_remaining = 12
			if player.specter.awake:
				player.specter.receive_damage(damage_remaining)
				damage_remaining = damage_remaining - (specter_initial_state.life_force - player.specter.life_force.current)
			if (damage_remaining > 0):
				player.receive_damage(damage_remaining*2)
			
			var specter_damage_delta = player.specter.life_force.current != specter_initial_state.life_force
			var player_damage_delta = player.life_force.current != player_initial_state.life_force
			if (player_damage_delta || specter_damage_delta):
				wait = player.anim_take_damage()
				if wait is GDScriptFunctionState: yield(wait, "completed")
			if (specter_damage_delta):
				wait = specter_lifebar.update_bar(player.specter.life_force.current)
				if wait is GDScriptFunctionState: yield(wait, "completed")
				wait = dialog_box.say("Your specter suffers damage.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				if specter_initial_state.awake && !player.specter.awake:
					wait = player.specter.anim_retreat()
					if wait is GDScriptFunctionState: yield(wait, "completed")
					specter_lifebar.reset_bar(LifeForce.new(0,0), 0.0)
					wait = dialog_box.say("Your specter retreats.")
					if wait is GDScriptFunctionState: yield(wait, "completed")
			if (player_damage_delta):
				wait = player_lifebar.update_bar(player.life_force.current)
				if wait is GDScriptFunctionState: yield(wait, "completed")
				wait = dialog_box.say("You suffer damage.")
				if wait is GDScriptFunctionState: yield(wait, "completed")

func _perform_player_action(action):
	var wait
	match action:
		"BOND":
			wait = dialog_box.say("Your open your soul to the specter.")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = enemy.anim_bond()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			enemy_lifebar.reset_bar(LifeForce.new(0,0), 0.0)
			enemy.bonded = true
			wait = dialog_box.say("Bonding successful!")
			
		"REST":
			if wait is GDScriptFunctionState: yield(wait, "completed")

			wait = dialog_box.say("You rest for a moment.")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			if player.life_force.is_maxed():
				wait = dialog_box.say("Your life force is already at full capacity.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				return
			
			wait = player.anim_rest()
			if wait is GDScriptFunctionState: yield(wait,"completed")

			var player_initial_state = player.get_state()
			player.receive_healing(20)

			if (player_initial_state.life_force != player.life_force.current):
				wait = player_lifebar.update_bar(player.life_force.current)
				if wait is GDScriptFunctionState: yield(wait,"completed")
				wait = dialog_box.say("You replenish some of your life force.")
				if wait is GDScriptFunctionState: yield(wait, "completed")


		"FORTIFY":
			wait = dialog_box.say("You transfer part of your life force to your specter.")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			if (player.life_force.current == 1):
				wait = dialog_box.say("You do not have enough life force to fortify your specter.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				return

			if player.specter.life_force.is_maxed():
				wait = dialog_box.say("Your specter's life force is already at full capacity.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				return
			if (!player.specter.awake):
				wait = dialog_box.say("Your specter is not awake.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				return

			wait = player.anim_fortify()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			wait = player.specter.anim_fortify()
			if wait is GDScriptFunctionState: yield(wait, "completed")
			
			var player_initial_state = player.get_state()
			player.specter.receive_healing(player.life_force.current - 1)
			var delta = player.specter.life_force.current - player_initial_state.specter.life_force
			if (delta > 0):
				player.receive_damage(delta)
				wait = [
					player_lifebar.update_bar(player.life_force.current),
					specter_lifebar.update_bar(player.specter.life_force.current)
				]
				if wait[0] is GDScriptFunctionState: yield(wait[0], "completed")
				if wait[1] is GDScriptFunctionState && wait[1].is_valid(): yield(wait[1], "completed")
				wait = dialog_box.say("Your specter's life force is replenished.")
				if wait is GDScriptFunctionState: yield(wait, "completed")

		"AWAKEN":
			wait = dialog_box.say("You call forth a specter.")
			if wait is GDScriptFunctionState: yield(wait, "completed")
			if (player.life_force.current == 1):
				wait = dialog_box.say("You do not have enough life force to awaken your specter.")
				if wait is GDScriptFunctionState: yield(wait, "completed")
				return

			var player_initial_state = player.get_state()
			if (!player_initial_state.specter.awake):
				player.specter.reset(40, player.life_force.current - 1, true)
				var delta = player.specter.life_force.current - player_initial_state.specter.life_force
				if (delta > 0):
					player.receive_damage(delta)
					wait = player.anim_fortify()
					if wait is GDScriptFunctionState: yield(wait, "completed")
					wait = player_lifebar.update_bar(player.life_force.current)
					if wait is GDScriptFunctionState: yield(wait, "completed")

					specter_lifebar.reset_bar(
						LifeForce.new(player.specter.life_force.maximum),
						player.specter.life_force.maximum as float/player.life_force.maximum as float
					)
					wait = player.specter.anim_awaken()
					if wait is GDScriptFunctionState: yield(wait, "completed")
					wait = specter_lifebar.update_bar(player.specter.life_force.current)
					if wait is GDScriptFunctionState: yield(wait, "completed")
					wait = dialog_box.say("Your specter awakens!")
					if wait is GDScriptFunctionState: yield(wait, "completed")

