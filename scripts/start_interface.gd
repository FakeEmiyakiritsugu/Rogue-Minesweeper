extends Node

#游戏开始界面
#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
var latest_save:SaveData = null #记录上个存档

@onready var dialog_scene = preload("res://Main/ensure_window.tscn")#预加载弹出窗口




func _ready():
	#print(Playerdata.SAVE_FILE_PATH)
	#print(Playerdata.HP)
	#Playerdata.HP=Playerdata.HP+1
	#print(Playerdata.HP)
	#var save_data = load("user://save/save_data.tres")
	#if save_data is SaveData:
		#print("temp 是 SaveData 类")
	#else:
		#print("temp 不是 SaveData 类")
	pass

func _on_start_button_pressed():
	#latest_save = load(Playerdata.SAVE_FILE_PATH)
	if FileAccess.file_exists(Playerdata.SAVE_FILE_PATH):#如果已经存在存档，就跳窗口显示
		show_dialog()
	else:
		#创建新存档
		var save_data = SaveData.new()
		save_data.game_run_flag=2
		#save_data.save_fixed_debuff.append(0)#增加默认的雷数加一
		save_data.save()
		Playerdata.loadsave_data()
		#SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
		SceneChanger.change_scene("res://Main/shop_ui.tscn")#跳转到商店界面
	
	
	
	pass # Replace with function body.


func _on_end_button_pressed():#关闭游戏
	get_tree().quit()
	pass # Replace with function body.


func _on_continue_button_pressed():#继续上个存档
	#SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
	if not FileAccess.file_exists(Playerdata.SAVE_FILE_PATH):#如果没有对应文件
		OS.alert("您还没有存档！\n请开始新游戏", "错误")
		return
	else:
		Playerdata.loadsave_data()
	#latest_save = load(SAVE_FILE_PATH)
	#print(latest_save.game_run_flag)
	if Playerdata.game_run_flag==2:
		SceneChanger.change_scene("res://Main/shop_ui.tscn")#跳转到商店界面
	elif Playerdata.game_run_flag==1:
		SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
	elif Playerdata.game_run_flag==3:
		SceneChanger.change_scene("res://Main/choose_debuff_ui.tscn")#跳转到选择debuff界面
	pass # Replace with function body.


func show_dialog():
	var dialog = dialog_scene.instantiate()#实例化场景资源
	add_child(dialog)
	
