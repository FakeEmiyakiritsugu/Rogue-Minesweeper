extends Node
#看起来是将UI和TileMap联系起来的脚本
@export var mines_grid: MinesGrid
@export var ui:UI
@onready var timer = $Timer

var time_elapsed = 0

func _ready():
	#主要属性
	mines_grid.game_lost.connect(on_game_lost)
	mines_grid.game_won.connect(on_game_won)
	mines_grid.flag_plus.connect(on_flag_plus)
	mines_grid.flag_minus.connect(on_flag_minus)
	mines_grid.lose_hp.connect(on_lose_hp)
	mines_grid.lose_armor.connect(on_armor_lose)
	mines_grid.sig_combo_change.connect(on_combo_change)
	mines_grid.sig_blood_sucking_change.connect(on_bloodsucking_change)
	mines_grid.sig_dig_treasure_change.connect(on_dig_treasure_change)
	mines_grid.sig_money_change.connect(on_money_change)
	mines_grid.sig_exp_change.connect(on_exp_change)
	mines_grid.sig_poison_steps_change.connect(on_poison_change)
	mines_grid.sig_poison_layers_change.connect(on_poison_layers_change)
	mines_grid.sig_up_ui_change.connect(on_up_ui_change)
	
	
	#主要属性
	ui.set_mine_count(Playerdata.number_of_mines-Playerdata.flags_placed)#初始化ui雷数显示
	#print("gamestateminesgrid生命值为%d" %mines_grid.HP)
	ui.set_HP_count(Playerdata.HP,Playerdata.max_hp)#初始化ui生命值显示
	ui.set_armor_count(Playerdata.armor)#初始化护甲值
	ui.set_money_count(Playerdata.money)#初始化金钱
	ui.set_rounds_count(Playerdata.rounds)#初始化回合数
	ui.set_combo_count(Playerdata.combo)#初始化连击数
	ui.set_income_count(Playerdata.income)#初始化收入
	ui.set_bloodsucking_count(0,Playerdata.bloodsucking)#初始化吸血计数
	ui.set_dig_treasure_count(0,Playerdata.dig_treasure)#初始化挖宝计数
	ui.set_mana_count(Playerdata.mana)#初始化魔法值
	ui.set_EXP_count()#初始化经验值
	ui.set_level_count()#初始化等级
	ui.set_poison_count()#初始化中毒计数
	ui.set_poison_layers()#初始化中毒层数
	ui.init_ui_up_part_total()#初始化上方主要属性
	
	#左侧次要属性
	mines_grid.sig_level_change.connect(on_level_change)
	
	#左侧次要属性
	ui.set_interest_count(Playerdata.interest)#初始化利息
	ui.set_dodge_count()#初始化闪避
	ui.set_life_regeneration_count()#初始化生命再生
	ui.set_consumptive_therapy_count()#初始化消耗性治疗
	ui.set_gain_experience_count()#初始化获得经验
	ui.set_question_mark_grid()#初始化问号格
	ui.init_ui_left_part_total()#初始化次要属性
	

#主要属性
func _on_timer_timeout():
	time_elapsed += 1
	#print(time_elapsed)
	ui.set_timer_count(time_elapsed)
	
func on_game_won(rounds:int):
	timer.stop()
	ui.game_win(rounds)

	
func on_game_lost():
	timer.stop()
	ui.game_lost()
	
func on_flag_plus(flag_count:int):#用于修改ui的雷数
	ui.set_mine_count(Playerdata.number_of_mines - flag_count)
	#print("雷标记个数：%d",flag_count)

func on_flag_minus(flag_count:int):#用于修改ui的雷数
	ui.set_mine_count(Playerdata.number_of_mines - flag_count)
	#print("雷标记个数：%d",flag_count)

func on_lose_hp(Hp:int,HP_max:int):
	ui.set_HP_count(Hp,HP_max)
	#print("ui生命值变换")

func on_exp_change():#用于修改经验值
	ui.set_EXP_count()

func on_money_change(money:int):#用于修改金钱
	ui.set_money_count(money)
	#print("ui生命值变换")

func on_combo_change(combo:int):#用于修改连击数
	ui.set_combo_count(combo)



func on_bloodsucking_change(bloodsucking_count:int,bloodsucking:int):#用于修改吸血计数
	ui.set_bloodsucking_count(bloodsucking_count,bloodsucking)

func on_dig_treasure_change(dig_treasure_count:int,dig_treasure:int):#用于修改挖宝计数
	ui.set_dig_treasure_count(dig_treasure_count,dig_treasure)


func on_poison_change():#用于修改中毒计数
	ui.set_poison_count()
	
func on_poison_layers_change():#用于修改中毒层数
	ui.set_poison_layers()

func test():
	print("testgamestatemanager")

func timer_restart():#重新启动计时器
	timer.start()

func on_armor_lose(armor:int):
	ui.set_armor_count(armor)
	
func on_up_ui_change():#上方主要ui改变
	ui.show_ui_up_part()
	
#左侧次要属性
func on_level_change():#用于修改等级
	ui.set_level_count()
