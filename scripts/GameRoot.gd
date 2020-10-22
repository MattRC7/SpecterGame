extends Node

var bonded_specters: Array = []
var player_total_life_force := 121

func initiate_battle(enemy: SpecterInstance) -> void:
	var root = get_tree().root
	var battle_scene: PackedScene = load("res://scenes/Battle.tscn")
	var battle = battle_scene.instance()
	var current_scene = get_tree().current_scene
	root.remove_child(current_scene)
	root.add_child(battle)
	get_tree().current_scene = battle
	battle.start_battle(enemy, compute_player_life_force())
	var battle_result: Dictionary = yield(battle, "exit_battle")
	if (battle_result.outcome == BattleConductor.BattleResult.BOND):
		add_bonded_specter(enemy)
	if (battle_result.outcome == BattleConductor.BattleResult.GAME_OVER):
		var new_scene: PackedScene = load(current_scene.filename)
		current_scene = new_scene.instance()
	root.remove_child(battle)
	battle.queue_free()
	root.add_child(current_scene)
	get_tree().current_scene = current_scene

func add_bonded_specter(specter: SpecterInstance) -> void:
	bonded_specters.append(specter)

func compute_player_life_force():
	var life_force = player_total_life_force
	for specter in bonded_specters:
		if specter is SpecterInstance:
			life_force -= specter.idle_life_force()
	return life_force
