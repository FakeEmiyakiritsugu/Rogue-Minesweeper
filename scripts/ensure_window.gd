extends Control

#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():#点击确认按钮
	
	DirAccess.remove_absolute(Playerdata.SAVE_FILE_PATH)  # 删除旧存档文件
	#创建新存档
	var save_data = SaveData.new()
	save_data.game_run_flag=2
	#save_data.save_fixed_debuff.append(0)#增加默认的雷数加一
	#print(save_data.mines_number)
	save_data.save()
	#print(Playerdata.mines_number)
	Playerdata.loadsave_data()
	#print(Playerdata.mines_number)
	#SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
	SceneChanger.change_scene("res://Main/shop_ui.tscn")#跳转到商店界面
	pass # Replace with function body.


func _on_button_2_pressed():#点击取消按钮
	queue_free()#删除节点
	pass # Replace with function body.
