extends Node

var bonded_specters: Array = []
var player_life_force := 120

func initiate_battle(enemy: SpecterResource, enemy_lf: int) -> void:
	var battle_scene: PackedScene = load("res://Battle.tscn")
	var battle = battle_scene.instance()
	var current_scene = get_tree().current_scene
	get_tree().root.remove_child(current_scene)
	get_tree().root.add_child(battle)
	get_tree().current_scene = battle
	battle.start_battle(enemy, enemy_lf, 120)
	var battle_result: Dictionary = yield(battle, "exit_battle")
	if (battle_result.outcome == BattleConductor.BattleResult.BOND):
		bonded_specters.append({
			"resource": enemy
		})
	if (battle_result.outcome == BattleConductor.BattleResult.GAME_OVER):
		var new_scene: PackedScene = load(current_scene.filename)
		current_scene = new_scene.instance()
	get_tree().root.remove_child(battle)
	battle.queue_free()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
