extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#var save_data = SaveData.new()
	#save_data.HP = 666
	#save_data.rounds = 999
	#save_data.number_of_mines = 20241125
	#save_data.save()
	#var newSAVE = load("user://save/save_data.tres")
	#print("ever_saved=",SaveData.ever_saved)
	var test = Playerdata.get("HP")
	print(test)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
