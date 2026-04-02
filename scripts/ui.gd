extends CanvasLayer
class_name  UI

#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径


#关卡内ui
@export var mines_grid: MinesGrid
@export var game_state_manager: Node

#主要属性ui
@onready var mines_count_label = $PanelContainer/VBoxContainer/HBoxContainer/MinesCountPanel/MinesCountLabel
@onready var game_status_button = $PanelContainer/VBoxContainer/HBoxContainer/GameStatusButton
@onready var timer_count_label = $PanelContainer/VBoxContainer/HBoxContainer/TimerPanel/TimerCountLabel
@onready var hp_count_label = $PanelContainer/VBoxContainer/HBoxContainer/HPCountPanel/HPCountLabel
@onready var rounds_count_label = $PanelContainer/VBoxContainer/HBoxContainer/RoundsCountPanel/RoundsCountLabel
@onready var armor_count_label = $PanelContainer/VBoxContainer/HBoxContainer/ArmorCountPanel/ArmorCountLabel
@onready var money_count_label = $PanelContainer/VBoxContainer/HBoxContainer/MoneyPanel/MoneyCountLabel
@onready var combo_count_label = $PanelContainer/VBoxContainer/HBoxContainer/ComboCountPanel/ComboCountLabel
@onready var income_count_label = $PanelContainer/VBoxContainer/HBoxContainer/IncomePanel/IncomeCountLabel
@onready var bloodsucking_count_label = $PanelContainer/VBoxContainer/HBoxContainer/BloodSuckingPanel/BloodSuckingCountLabel
@onready var dig_treasure_label = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer/DigTreasureCountPanelContainer/HBoxContainer/DigTreasureLabel
@onready var mana_label = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer/ManaPanelContainer2/HBoxContainer/ManaLabel
@onready var exp_label = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer/EXPPanelContainer3/HBoxContainer/EXPLabel
@onready var posion_count_label = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer/PosionCountPanelContainer4/HBoxContainer/PosionCountLabel
@onready var posion_layers_label = $PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer/PosionLayersPanelContainer5/HBoxContainer/PosionLayersLabel





#左侧次要属性ui
@onready var interest_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/InterestPanelContainer/HBoxContainer/InterestLabel
@onready var level_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/LevelPanelContainer2/HBoxContainer/LevelLabel
@onready var dodge_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/DodgePanelContainer3/HBoxContainer/DodgeLabel
@onready var life_regeneration_panel_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/LifeRegenerationPanelContainer4/HBoxContainer/LifeRegenerationPanelLabel
@onready var consumptive_therapy_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/ConsumptiveTherapyPanelContainer5/HBoxContainer/ConsumptiveTherapyLabel
@onready var gain_experience_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/GainExperiencePanelContainer6/HBoxContainer/GainExperienceLabel
@onready var question_mark_grid_label = $LeftPanelContainer/ScrollContainer/VBoxContainer/QuestionMarkGridPanelContainer7/HBoxContainer/QuestionMarkGridLabel

#上方ui
@onready var UI_UP_PART_PANEL_CONTAINER = preload("res://Main/Small Components/ui_up_part_panel_container.tscn")

#主要属性ui数组
var total_up_ui_part_panel = []
var total_up_ui_text = []
var total_up_ui_label = []


#左侧ui
@onready var UI_LEFT_PART_PANEL_CONTAINER = preload("res://Main/Small Components/ui_left_part_panel_container.tscn")

#次要属性ui数组
var total_left_ui_part_panel = []
var total_left_ui_text = []
var total_left_ui_label = []

var game_lost_button_texture = preload("res://picture/face_dead.png")
var game_won_button_texture = preload("res://picture/face_win.png")
var game_smile_button_texture = preload("res://picture/smileface.png")


var game_status_flag = 2#游戏当前状态，0为游戏失败，1为游戏成功,2为正在进行
var game_rounds = 1#游戏当前轮数

#主要属性
func set_money_count(money_count):#设置金钱显示
	var money_count_string = str(money_count)
	#if money_count_string.length()<3:
		#money_count_string = money_count_string.lpad(3,"0")
	#
	money_count_label.text = money_count_string

func set_mine_count(mines_count:int):#设置雷数显示
	var mines_count_string = str(mines_count)
	if mines_count_string.length()<3:
		mines_count_string = mines_count_string.lpad(3,"0")
		
	mines_count_label.text = mines_count_string
	
func set_timer_count(timer_count:int):#设置时间显示
	var timer_string = str(timer_count)
	if timer_string.length()<3:
		timer_string = timer_string.lpad(3,"0")
	
	timer_count_label.text = timer_string
	
func set_HP_count(HP_count:int,HP_max:int):#设置生命值显示
	var HP_string = str(HP_count)
	var HP_max_string = str(HP_max)
	HP_string = HP_string+' / '+HP_max_string
	#if HP_string.length()<3:
		#HP_string = HP_string.lpad(3,"0")
	
	hp_count_label.text = HP_string

func set_armor_count(armor:int):#设置护甲值显示
	var armor_string = str(armor)
	if armor_string.length()<3:
		armor_string = armor_string.lpad(3,"0")
	
	armor_count_label.text = armor_string

func set_rounds_count(rounds:int):#设置回合数显示
	var rounds_string = str(rounds)
	if rounds_string.length()<3:
		rounds_string = rounds_string.lpad(3,"0")
	
	rounds_count_label.text = rounds_string

func set_mana_count(mana:int):#设置魔法值显示
	var mana_string = str(mana)
	var max_mana_string = str(Playerdata.max_mana)
	var mana_count_string = mana_string+' / '+ max_mana_string
	mana_label.text = mana_count_string

func set_EXP_count():#设置经验值显示
	var EXP_count_string = str(Playerdata.exp)
	var EXP_upgrade_string = str(Playerdata.get_exp_upgrade())
	EXP_count_string = EXP_count_string+' / '+EXP_upgrade_string
	
	exp_label.text = EXP_count_string


func set_combo_count(combo:int):#设置连击数
	var combo_string = str(combo)
	if combo_string.length()<3:
		combo_string = combo_string.lpad(3,"0")
	
	combo_count_label.text = combo_string

func set_income_count(income:int):#设置收入
	var income_string = str(income)
	if income_string.length()<3:
		income_string = income_string.lpad(3,"0")
	
	income_count_label.text = income_string

func set_bloodsucking_count(bloodsucking_count:int,bloodsucking:int):#设置吸血值显示
	var bloodsucking_count_string = str(bloodsucking_count)
	var bloodsucking_string = str(bloodsucking)
	bloodsucking_count_string = bloodsucking_count_string+' / '+bloodsucking_string
	
	bloodsucking_count_label.text = bloodsucking_count_string

func set_dig_treasure_count(dig_treasure_count:int,dig_treasure:int):#设置挖宝值显示
	var dig_treasure_count_string = str(dig_treasure_count)
	var dig_treasure_string = str(dig_treasure)
	dig_treasure_count_string = dig_treasure_count_string+' / '+dig_treasure_string
	dig_treasure_label.text = dig_treasure_count_string

func set_poison_count():#设置中毒计数显示
	var poison_steps_string = str(Playerdata.poison_steps)
	var poison_resistance_string = str(Playerdata.poison_resistance)
	var poison_count_string = poison_steps_string+' / '+poison_resistance_string
	posion_count_label.text = poison_count_string
	
func set_poison_layers():#设置中毒层数显示
	var poison_layers_string = str(Playerdata.poisoning_layers)
	if poison_layers_string.length()<3:
		poison_layers_string = poison_layers_string.lpad(3,"0")
	posion_layers_label.text = poison_layers_string

#完成ui代码加载
func init_ui_up_part_total():#初始化ui上方主要属性汇总
	init_ui_up_part()
	show_ui_up_part()
	pass

func init_ui_up_part():#初始化上方主要属性ui
	#实例化子节点，分配子节点组件入对应数组，
	for i in Playerdata.up_ui_fields.size():
		var ui_up_pa_container = UI_UP_PART_PANEL_CONTAINER.instantiate()#实例化场景资源
		get_node("PanelContainer/VBoxContainer/ScrollContainer/HBoxContainer").add_child(ui_up_pa_container)
		total_up_ui_part_panel.append(ui_up_pa_container)
		total_up_ui_text.append(ui_up_pa_container.get_node("HBoxContainer/Text"))
		total_up_ui_label.append(ui_up_pa_container.get_node("HBoxContainer/Label"))
	pass

func show_ui_up_part():#展示上方主要属性ui
	#根据Player_values_fields分配数值和文字给对应节点
	for i in Playerdata.up_ui_fields.size():
		total_up_ui_text[i].text = Playerdata.up_ui_Playerdata_text[i]+":"
		total_up_ui_label[i].text = str(Playerdata.get(Playerdata.up_ui_fields[i]))
	pass




#左侧次要属性
func set_interest_count(interest:int):#设置利息
	var interest_string = str(interest)
	if interest_string.length()<3:
		interest_string = interest_string.lpad(3,"0")
	
	interest_label.text = interest_string

func set_level_count():#设置等级
	var level_string = str(Playerdata.level)
	if level_string.length()<3:
		level_string = level_string.lpad(3,"0")
	
	level_label.text = level_string

func set_dodge_count():#设置闪避
	var dodge_string = str(Playerdata.dodge)
	if dodge_string.length()<3:
		dodge_string = dodge_string.lpad(3,"0")
	
	dodge_label.text = dodge_string

func set_life_regeneration_count():#设置生命再生
	var life_regeneration_string = str(Playerdata.dodge)
	if life_regeneration_string.length()<3:
		life_regeneration_string = life_regeneration_string.lpad(3,"0")
	
	life_regeneration_panel_label.text = life_regeneration_string

func set_consumptive_therapy_count():#设置消耗性治疗
	var consumptive_therapy_string = str(Playerdata.consumptive_therapy)
	if consumptive_therapy_string.length()<3:
		consumptive_therapy_string = consumptive_therapy_string.lpad(3,"0")
	
	consumptive_therapy_label.text = consumptive_therapy_string


func set_gain_experience_count():#设置获得经验
	var gain_experience_string = str(Playerdata.gain_experience)
	if gain_experience_string.length()<3:
		gain_experience_string = gain_experience_string.lpad(3,"0")
	
	gain_experience_label.text = gain_experience_string
	
	
func set_question_mark_grid():#设置问号格
	var question_mark_grid_string = str(Playerdata.question_mark_grid)
	if question_mark_grid_string.length()<3:
		question_mark_grid_string = question_mark_grid_string.lpad(3,"0")
	
	question_mark_grid_label.text = question_mark_grid_string

#完成ui代码加载
func init_ui_left_part_total():#初始化ui左侧次要属性汇总
	init_ui_left_part()
	show_ui_left_part()
	pass

func init_ui_left_part():#初始化左侧次要属性ui
	#实例化子节点，分配子节点组件入对应数组，
	for i in Playerdata.left_ui_fields.size():
		var ui_le_pa_container = UI_LEFT_PART_PANEL_CONTAINER.instantiate()#实例化场景资源
		get_node("LeftPanelContainer/ScrollContainer/VBoxContainer").add_child(ui_le_pa_container)
		total_left_ui_part_panel.append(ui_le_pa_container)
		total_left_ui_text.append(ui_le_pa_container.get_node("HBoxContainer/Text"))
		total_left_ui_label.append(ui_le_pa_container.get_node("HBoxContainer/Label"))
	pass

func show_ui_left_part():#展示左侧次要属性ui
	#根据Player_values_fields分配数值和文字给对应节点
	for i in Playerdata.left_ui_fields.size():
		total_left_ui_text[i].text = Playerdata.left_ui_Playerdata_text[i]+":"
		total_left_ui_label[i].text = str(Playerdata.get(Playerdata.left_ui_fields[i]))
	pass
	









#其他
func _on_game_status_button_pressed():#点击表情
	#get_tree().reload_current_scene()
	if game_status_flag==0:#若失败，返回主菜单
		#删除失败存档
		DirAccess.remove_absolute(Playerdata.SAVE_FILE_PATH)  # 删除旧存档文件
		#print("1")
		#回到标题界面
		SceneChanger.change_scene("res://Main/start_interface.tscn")
	elif game_status_flag==1:#若胜利，点击进入下一局
		SceneChanger.change_scene("res://Main/shop_ui.tscn")
	elif game_status_flag==2:#若正在进行，无反应
		return
		#print("下一关")
		#mines_grid.create_new_map()
		#print("ganme_rounds=",game_rounds)
		#var game_rounds_string = str(game_rounds)
		#
		#if game_rounds_string.length()<3:
			#game_rounds_string = game_rounds_string.lpad(3,"0")
		#
		#rounds_count_label.text = game_rounds_string
		#
		#set_armor_count(mines_grid.armor)
		#set_mine_count(mines_grid.mines_number)
		##get_tree().reload_current_scene()
		#print("rounds_count_label.text=",rounds_count_label.text)
		#game_status_flag = 0
		#mines_grid.is_game_finished = false
		#game_status_button.texture_normal = game_smile_button_texture
		##game_state_manager.test()#明明可以调用却不补全
		#game_state_manager.time_elapsed = 0
		#game_state_manager.timer_restart()
		##雷数需要重置，时间也需要重置，修改完后注释此段文字
	pass # Replace with function body.





func game_lost():#失败表情设置
	game_status_button.texture_normal = game_lost_button_texture
	game_status_flag = 0
	
func game_win(rounds:int):#胜利表情设置
	game_status_button.texture_normal = game_won_button_texture
	game_rounds = rounds
	game_status_flag = 1



func _on_exit_button_pressed():#保存存档并返回主界面
	if game_status_flag==0:#若失败，返回主菜单
		#删除失败存档
		DirAccess.remove_absolute(Playerdata.SAVE_FILE_PATH)  # 删除旧存档文件
		#print("1")
		#回到标题界面
		SceneChanger.change_scene("res://Main/start_interface.tscn")
	elif game_status_flag==1:#若胜利，点击进入下一局
		SceneChanger.change_scene("res://Main/shop_ui.tscn")
	elif game_status_flag==2:#若正在进行，无反应
		mines_grid.savedata()#存档
		SceneChanger.change_scene("res://Main/start_interface.tscn")
	pass # Replace with function body.

