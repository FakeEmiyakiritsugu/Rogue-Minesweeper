extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_button_pressed():
	DirAccess.remove_absolute(Playerdata.SAVE_FILE_PATH)  # 删除旧存档文件
	SceneChanger.change_scene("res://Main/start_interface.tscn")#跳转到商店界面
