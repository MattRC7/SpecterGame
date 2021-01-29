extends Node2D

export var plant_life_capacity := 10
export var plant_water_capacity := 5
export var plant_water_draw := 1.0
export var plant_energy_draw := 1.0
export var plant_growth_rate := 1.0

func plant_seed() -> Plant:
	var plant_res: PackedScene = load('res://Plant.tscn');
	var new_plant: Plant = plant_res.instance();
	new_plant.water = RollingInt.new(plant_water_capacity)
	new_plant.life = RollingInt.new(plant_life_capacity)
	new_plant.energy_draw = plant_energy_draw;
	new_plant.water_draw = plant_water_draw;
	new_plant.growth_rate = plant_growth_rate;
	return new_plant;
