extends Node

#添加的任何信息需要同时添加到本脚本的load，save，以及achieve脚本的信息
#实际游戏里的玩家数值初始化都是先从achieve_process创建的存档文件中读取的
#
#玩家的所有信息，全局脚本

const SAVE_PATH = "user://save"#存储文件夹路径
const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
var latest_save:SaveData = null #记录上个存档






#玩家数值
var HP = 5 #生命值
var armor = 0#最大护甲
var initial_size = 5#地图初始大小
var mines_number = 3 #地图雷数
var income = 10 #每回合过后增加的金钱是收入+雷数
var bloodsucking = 10#连续点开？格子不触雷后回复1点生命
var dig_treasure = 10#连续点开？格子不触雷后获得1点钱
var interest = 10#每回合结束，每有？的钱就给？钱
var rounds = 1#回合数
var money = 50 #玩家的金钱
var mana = 0 #魔法值
var exp = 0 #用于升级，默认升级经验为10+等级*10
var level = 1#等级,默认情况每级+1生命与生命上线，+1收入
var max_hp = 5 #血量上限：默认根据等级，为5+等级
var dodge = 0 #闪避：触发雷避免此次伤害的概率，默认为0
var life_regeneration = 0#生命再生：每局游戏结束恢复生命值，默认为0
var initial_rules_number = 8 #初始给的线索数，至少为0
var movement = 3#移动：决定在路线扫雷图上能连续走多少格不触发战斗，默认为3
var consumptive_therapy = 0#消耗性治疗：使用消耗品进行回复时加上这个数值，默认为0
var gain_experience = 1#获得经验：获得经验会乘以这个数值，默认为1
var shop_price = 1#商店价格：买商店中的物品会乘以这个百分比，默认为1
var free_refresh = 2#免费刷新：在商店中免费刷新的次数，默认为2
var combo = 0 #连击
var each_round_curse_points = 5#每轮诅咒点：每轮获得的随机debuff需要至少满足的点数
var total_curse_points = 0#总诅咒点：累计获得的诅咒点之和
var poison_resistance = 10#毒抗性：默认为10，10表示如果中毒每层每10步扣1点血
var poisoning_layers = 0#中毒层数：默认为0，至少为0，每层会让毒发时扣1点血
var question_mark_grid = 1#问号格子：默认为1，至少为1，问号格是不提供线索的线索格
var black_grid = 1#黑色格：默认为1，至少为1，黑色格如果猜错会额外扣1点血
var poison_grid = 0#毒格：默认为0，至少为0，毒格如果猜错增加一层中毒
var treasure_grid = 1#宝藏格：默认为1，至少为0，宝藏格猜对了将给予奖励，奖励包括金币，消耗品
var red_thunder = 0#红雷：默认为0，至少为0，红雷猜错多扣一点血
var poison_thunder = 0#毒雷：默认为0，至少为0，毒雷猜错加一层毒
var confusing_grid = 0#迷惑格：默认为0，至少为0，迷惑格上下左右四个方向的线索将被锁定为问号，直到迷惑格被揭示
var bloodsucking_recovery = 1#吸血回复：默认为1，至少为1，触发吸血时回复的数值
var dig_treasure_money = 1#挖宝金钱：默认为1，至少为1，触发挖宝时给予的金钱
var total_steps = 0#总步数：每进行一次操作算一步，记录总步数
var treasure_grid_reward = 5#宝藏格奖励：宝藏格猜对获得金钱
var max_mana = 5#最大魔法：初始为5，魔法值不得超过最大魔法

#特殊规则
var Special_rules = 0#当前游戏使用的规则，0表示原版，1表示大误差，2表示小误差




#选择debuff界面情况
var random_debuff_shop_cells_number = 6 #随机debuff商店的格子数量，默认6个
var random_debuff_shop_save = []#本轮随机debuff商店的debuff存储
var random_debuff_shop_out_flag = false#是否已经自动抽取
var curse_point_required_remain = 0#剩余需要诅咒点
var random_debuff_shop_refresh_price = 10#刷新价格，默认为10，每次刷新加5
var random_debuff_shop_level = 1#随机debuff商店等级，默认1
var random_debuff_shop_upgrade_price = 50#升级价格，默认50，每级增加20
var random_debuff_shop_refresh_times = 2 #随机商店免费刷新次数
var extra_ran_deb_shop_refresh_times = 0 #随机商店不算免费刷新已经被额外刷了多少次，用于计算刷新价格


#玩家数组记录
var save_fixed_debuff:Array[int]=[]#存储固定debuff的数组，根据关卡特性固定产生
var save_random_debuff:Array[int]=[]#存储随机debuff的数组，每轮将随机抽取
var already_debuff={}#玩家已经拥有的debuff
var already_buff={}#玩家已经拥有的buff

#游戏状态
var cells_with_mines = []#存储哪些地块有雷
var cells_with_flags = []#存储哪些雷被标记了
var cells_already_with_rules = []#在游戏一开始，存储哪些地块已经被揭示线索了
var cells_checked_recursively = []#存储哪些地块已经被揭示线索了，用于记录来自动地显示0周围的线索
var flags_placed = 0#放置标记数
var is_game_finished = false
var game_run_flag = 0 #游戏处于什么状态，0表示新关卡，1表示正在排雷，2表示商店界面，3表示在关卡buff选择
var mines_count = 0 #记录已经解决了多少雷
var mines_already_open = []#存储哪些有雷的地块被错误地点开了
var current_armor = 0#当前这关的护甲
var columns = 5#列#20250719注意我把行列搞反了，所以这里标的是反的
var rows = 5#行
var number_of_mines = 3#游戏内雷数
var poison_steps = 0#当前毒计步
var cells_with_special_rules = []#存储哪些地块是特殊线索
var cells_with_special_grid = []#存储哪些地块是特殊格
var cells_with_special_mines = []#存储哪些地块是特殊雷



#商店内情况
var fixed_debuff_flag = false #记录是否已将本轮fixeddebuff加入

#饰品商店
var buff_shop_out_flag = false#是否已经自动抽取
var extra_buff_shop_refresh_times = 0 #buff商店不算免费刷新已经被额外刷了多少次，用于计算刷新价格
var buff_shop_refresh_times = 2 #buff商店免费刷新次数
var buff_shop_base_cells_number = 4#基础格子数
var buff_shop_level = 1#等级
var buff_shop_save = []#本轮buff商店的buff存储
var buff_shop_base_refresh_price = 10#基础刷新价格，默认为10，每次刷新加5
var buff_shop_upgrade_price = 50#升级价格，默认50，每级增加20

#用于save和load的数组
var Player_values_fields = [
	"HP","armor","initial_size","mines_number","income","bloodsucking","dig_treasure",
	"interest","rounds","money","mana","exp","level","max_hp","dodge",
	"life_regeneration","initial_rules_number","movement","consumptive_therapy",
	"gain_experience","shop_price","free_refresh","combo",
	"each_round_curse_points","total_curse_points","poison_resistance","poisoning_layers",
	"question_mark_grid","black_grid","poison_grid","treasure_grid","red_thunder",
	"poison_thunder","confusing_grid","bloodsucking_recovery","dig_treasure_money",
	"total_steps","treasure_grid_reward","max_mana",
]#玩家数值

var level_page_fields = [
	"current_armor",
]

var choose_debuff_page_fields = [
	"random_debuff_shop_cells_number",
	"random_debuff_shop_out_flag","random_debuff_shop_save","curse_point_required_remain",
	"random_debuff_shop_refresh_price","random_debuff_shop_level","random_debuff_shop_upgrade_price",
	"random_debuff_shop_refresh_times","extra_ran_deb_shop_refresh_times"
]#选择debuff界面情况
var Player_debuff_array_fields =[
	"save_fixed_debuff",
	"save_random_debuff","already_debuff","already_buff",
]#玩家数组记录
var game_state_fields = [
	"cells_with_mines","cells_with_flags",
	"cells_already_with_rules","cells_checked_recursively","flags_placed",
	"is_game_finished","game_run_flag","number_of_mines","mines_count",
	"mines_already_open","current_armor","columns","rows","number_of_mines",
	"poison_steps","cells_with_special_rules", "cells_with_special_grid",
	"cells_with_special_mines",
]#游戏状态
var store_situation_fields = [
	"fixed_debuff_flag",
]#商店内情况

var buff_shop_fields = [
	"buff_shop_out_flag","extra_buff_shop_refresh_times","buff_shop_refresh_times",
	"buff_shop_base_cells_number","buff_shop_level","buff_shop_save","buff_shop_base_refresh_price",
	"buff_shop_upgrade_price",
]#buff商店情况




#用于人物属性的文字
var Player_values_text = [
	"生命值","最大护甲","地图初始大小","地图雷数","收入","吸血","挖宝","利息","回合数","金钱","魔法值",
	"经验","等级","血量上限","闪避","生命再生","初始线索数","移动","消耗性治疗","获得经验","商店价格","免费刷新",
	"连击","每轮诅咒点","总诅咒点","毒抗性","中毒层数","问号格子","黑色格","毒格","宝藏格","红雷",
	"毒雷","迷惑格","吸血回复","挖宝金钱","总步数","宝藏格奖励","最大魔法值",
]

#用于ui的部分
#文字
#上方ui
var up_ui_Playerdata_text = [
	"步数",
]
#左侧ui
var left_ui_Playerdata_text =[
	"黑色格数量","毒格数量","宝藏格数量","宝藏格奖励","红雷数量","毒雷数量","迷惑格数量",
	"吸血回复","挖宝奖励",
]

#字母
#上方ui
var up_ui_fields = [
	"total_steps",
]
#左侧ui
var left_ui_fields = [
	"black_grid","poison_thunder","treasure_grid","treasure_grid_reward",
	"red_thunder","poison_thunder","confusing_grid","bloodsucking_recovery",
	"dig_treasure_money",
]


# Called when the node enters the scene tree for the first time.
func _ready():

	#if FileAccess.file_exists(SAVE_FILE_PATH):#如果有存档
		#loadsave_data()
	#print(save_fixed_debuff)
	pass # Replace with function body.


func loadsave_data():#加载存档
	#加载存档数据
	latest_save = ResourceLoader.load("user://save/save_data.tres", "", 0)#终于解决了，0是忽视缓存
	
	
	for field in Player_values_fields:
		Playerdata.set(field,latest_save.get(field))
	for field in choose_debuff_page_fields:
		Playerdata.set(field,latest_save.get(field))
	for field in Player_debuff_array_fields:
		Playerdata.set(field,latest_save.get(field))
	for field in game_state_fields:
		Playerdata.set(field,latest_save.get(field))
	for field in store_situation_fields:
		Playerdata.set(field,latest_save.get(field))
	for field in buff_shop_fields:
		Playerdata.set(field,latest_save.get(field))
	#print("lastest_save.mines_number=",latest_save.mines_number)
	##玩家数值
	#Playerdata.HP = latest_save.HP #生命值
	#Playerdata.armor = latest_save.armor#最大护甲
	#Playerdata.current_armor = latest_save.current_armor#当前这关的护甲
	#Playerdata.initial_size = latest_save.initial_size#地图初始大小
	#Playerdata.rounds = latest_save.rounds#回合数
	#Playerdata.initial_rules_number = latest_save.initial_rules_number #初始给的线索数
	#mines_number = latest_save.mines_number #地图雷数
	#Playerdata.Special_rules = latest_save.Special_rules #特殊规则
	#Playerdata.money = latest_save.money #玩家的金钱
	#Playerdata.income = latest_save.income
	#Playerdata.bloodsucking = latest_save.bloodsucking
	#Playerdata.dig_treasure = latest_save.dig_treasure
	#Playerdata.interest = latest_save.interest
	#Playerdata.max_hp = latest_save.max_hp #血量上限
	#Playerdata.combo = latest_save.combo #连击
	#mana = latest_save.mana#魔法值
	#exp = latest_save.exp #用于升级，默认升级经验为10+等级*10
	##print("save_data.HP为%d" %save_data.HP)
	#
	##选择debuff界面情况
	#random_debuff_shop_cells_number = latest_save.random_debuff_shop_cells_number #随机debuff商店的格子数量，默认6个
	#random_debuff_shop_save = latest_save.random_debuff_shop_save#本轮随机debuff商店的debuff存储
	#random_debuff_shop_out_flag = latest_save.random_debuff_shop_out_flag#是否已经自动抽取
	#
	##玩家debuff数组
	#save_fixed_debuff = latest_save.save_fixed_debuff
	#save_random_debuff = latest_save.save_random_debuff
	#already_debuff = latest_save.already_debuff
	#
	##游戏状态
	#Playerdata.cells_with_mines = latest_save.cells_with_mines
	#Playerdata.cells_with_flags = latest_save.cells_with_flags
	#Playerdata.cells_already_with_rules = latest_save.cells_already_with_rules
	#Playerdata.cells_checked_recursively = latest_save.cells_checked_recursively
	#Playerdata.flags_placed = latest_save.flags_placed
	#Playerdata.is_game_finished = latest_save.is_game_finished
	#Playerdata.game_run_flag = latest_save.game_run_flag
	#Playerdata.number_of_mines = latest_save.number_of_mines
	#Playerdata.mines_count = latest_save.mines_count
	#Playerdata.mines_already_open = latest_save.mines_already_open
	#
	##商店内情况
	#fixed_debuff_flag = latest_save.fixed_debuff_flag
	#
	##选择debuff内情况
	#random_debuff_shop_cells_number = latest_save.random_debuff_shop_cells_number
	
	
func save():
	var save_data = load("user://save/save_data.tres")
	#将存档数据输入
	save_data.latest_save = self #记录上个存档为自身这里好像有问题？？？
	#print(save_data.latest_save)
	for field in Player_values_fields:
		save_data.set(field,Playerdata.get(field))
	for field in choose_debuff_page_fields:
		save_data.set(field,Playerdata.get(field))
	for field in Player_debuff_array_fields:
		save_data.set(field,Playerdata.get(field))
	for field in game_state_fields:
		save_data.set(field,Playerdata.get(field))
	for field in store_situation_fields:
		save_data.set(field,Playerdata.get(field))
	for field in buff_shop_fields:
		save_data.set(field,Playerdata.get(field))
	##玩家数值
	#save_data.HP = Playerdata.HP #生命值
	#save_data.armor = Playerdata.armor#最大护甲
	#save_data.current_armor = Playerdata.current_armor#当前这关的护甲
	#save_data.initial_size = Playerdata.initial_size#地图初始大小
	#save_data.rounds = Playerdata.rounds#回合数
	#save_data.initial_rules_number = Playerdata.initial_rules_number #初始给的线索数
	#save_data.mines_number = Playerdata.mines_number #地图雷数
	#save_data.money = Playerdata.money #玩家的金钱
	#save_data.Special_rules = Playerdata.Special_rules#特殊规则
	##print("savedata1HP为%d" %save_data.HP)
	#save_data.income = Playerdata.income
	#save_data.bloodsucking = Playerdata.bloodsucking
	#save_data.dig_treasure = Playerdata.dig_treasure
	#save_data.interest = Playerdata.interest
	#save_data.max_hp = Playerdata.max_hp #血量上限
	#save_data.combo = Playerdata.combo #连击
	#save_data.mana = mana#魔法值
	#save_data.exp = exp #用于升级，默认升级经验为10+等级*10
	#
	##print("save_data.HP为%d" %save_data.HP)
	#
	##选择debuff界面情况
	#save_data.random_debuff_shop_cells_number = random_debuff_shop_cells_number #随机debuff商店的格子数量，默认6个
	#save_data.random_debuff_shop_save = random_debuff_shop_save#本轮随机debuff商店的debuff存储
	#save_data.random_debuff_shop_out_flag = random_debuff_shop_out_flag#是否已经自动抽取
	#
	#
	##玩家debuff数组
	#save_data.save_fixed_debuff = save_fixed_debuff#存储固定debuff的数组，根据关卡特性固定产生
	#save_data.save_random_debuff = save_random_debuff#存储随机debuff的数组，每轮将随机抽取
	#save_data.already_debuff= already_debuff#玩家已经拥有的debuff
	#
	#
	##游戏状态
	#save_data.cells_with_mines = Playerdata.cells_with_mines
	#save_data.cells_with_flags = Playerdata.cells_with_flags
	#save_data.cells_already_with_rules = Playerdata.cells_already_with_rules
	#save_data.cells_checked_recursively = Playerdata.cells_checked_recursively
	#save_data.flags_placed = Playerdata.flags_placed
	#save_data.is_game_finished = Playerdata.is_game_finished
	#save_data.game_run_flag = Playerdata.game_run_flag
	#save_data.number_of_mines = Playerdata.number_of_mines
	#save_data.mines_count = Playerdata.mines_count
	#save_data.mines_already_open = Playerdata.mines_already_open
	#
	##商店内情况
	#save_data.fixed_debuff_flag = fixed_debuff_flag
	#
	save_data.save()#用新存档覆盖旧存档

func get_dig_treasure():#获得挖宝计数
	return dig_treasure

func get_exp_upgrade():#获得升级所需经验
	return 0+level*10
	

func get_buff_price(i:int):#获得buff的金钱
	var price = int(LoadSource.buff_dic[i]["price"])*shop_price
	print(shop_price)
	print(price)
	return price

func get_treasure_reward():#获得宝藏格奖励
	return treasure_grid_reward
	
func get_bloodsucking_recovery_reward():#获得吸血奖励
	return bloodsucking_recovery
	
func get_dig_treasure_money():#获得挖宝奖励
	return dig_treasure_money
#func _process(delta):
	#print(save_fixed_debuff)
