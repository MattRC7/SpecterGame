extends Node

var battle_scene: PackedScene = preload("res://Battle.tscn")

func initiate_battle(enemy: SpecterResource, enemy_lf: int) -> void:
	var battle = battle_scene.instance()
	var current_scene = get_tree().current_scene
	get_tree().root.remove_child(current_scene)
	get_tree().root.add_child(battle)
	battle.start_battle(enemy, enemy_lf, 120)
	yield(battle, "exit_battle")
	battle.queue_free()
	get_tree().root.add_child(current_scene)
