extends Resource
class_name SaveData



const SAVE_PATH = "user://save"#存储文件夹路径
const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
@export var latest_save:SaveData = null #记录上个存档

#只有被@export过的数据会被save（）保存

##检查是否保存过
#static var ever_saved:bool:#记录是否有存档
	#get:
		#return latest_save != null
#static var latest_save:SaveData = null #记录上个存档
#玩家数值
@export var HP = 5 #生命值
@export var armor = 0#最大护甲
@export var initial_size = 5#地图初始大小
@export var mines_number = 3 #地图雷数
@export var income = 10 #收入，每回合过后增加的金钱是收入+雷数
@export var bloodsucking = 10#吸血，连续点开？格子不触雷后回复1点生命
@export var dig_treasure = 10#挖宝，连续点开？格子不触雷后获得1点钱
@export var interest = 10#利息，每回合结束，每有？的钱就给？钱
@export var rounds = 1#回合数
@export var money = 1000 #玩家的金钱,默认为50
@export var mana = 5 #魔法值，一般情况用于释放技能，包括自身，装备，天赋等
@export var exp = 0 #经验，用于升级，默认升级经验为10+等级*10
@export var level = 1#等级,默认情况每级+1生命与生命上线，+1收入
@export var max_hp = 5 #血量上限
@export var dodge = 0 #闪避：触发雷避免此次伤害的概率，默认为0
@export var life_regeneration = 0#生命再生：每局游戏结束恢复生命值，默认为0
@export var initial_rules_number = 8 #初始给的线索数，至少为0
@export var movement = 3#移动：决定在路线扫雷图上能连续走多少格不触发战斗，默认为3
@export var consumptive_therapy = 0#消耗性治疗：使用消耗品进行回复时加上这个数值，默认为0 
@export var gain_experience = 1#获得经验：获得经验会乘以这个数值，默认为1
@export var shop_price = 1#商店价格：买商店中的物品会乘以这个百分比，默认为1
@export var free_refresh = 2#免费刷新：在商店中免费刷新的次数，默认为2
@export var combo = 0 #连击
@export var each_round_curse_points = 3#每轮诅咒点：每轮获得的随机debuff需要至少满足的点数
@export var total_curse_points = 0#总诅咒点：累计获得的诅咒点之和
@export var poison_resistance = 10#毒抗性：默认为10，10表示如果中毒每层每10步扣1点血
@export var poisoning_layers = 0#中毒层数：默认为0，至少为0，每层会让毒发时扣1点血
@export var question_mark_grid = 1#问号格子：默认为1，至少为1，问号格是不提供线索的线索格
@export var black_grid = 1#黑色格：默认为1，至少为1，黑色格如果猜错会额外扣1点血
@export var poison_grid = 1#毒格：默认为0，至少为0，毒格如果猜错增加一层中毒
@export var treasure_grid = 1#宝藏格：默认为1，至少为0，宝藏格猜对了将给予奖励，奖励包括5金币，消耗品（消耗品还未完成）
#下面的还未生效
@export var red_thunder = 1#红雷：默认为1，至少为0，红雷猜错多扣一点血
@export var poison_thunder = 1#毒雷：默认为1，至少为0，毒雷猜错加一层毒
@export var confusing_grid = 0#迷惑格：默认为0，至少为0，迷惑格上下左右四个方向的线索将被锁定为问号，直到迷惑格被揭示
@export var bloodsucking_recovery = 1#吸血回复：默认为1，至少为1，触发吸血时回复的数值
@export var dig_treasure_money = 1#挖宝金钱：默认为1，至少为1，触发挖宝时给予的金钱
@export var total_steps = 0#总步数：每进行一次操作算一步，记录总步数
@export var treasure_grid_reward = 5#宝藏格奖励：宝藏格猜对获得金钱
@export var max_mana = 5#最大魔法：初始为5，魔法值不得超过最大魔法


#特殊规则
@export var Special_rules = 0#当前游戏使用的规则，0表示原版，1表示大误差，2表示小误差






#选择debuff界面情况
@export var random_debuff_shop_cells_number = 4 #随机debuff商店的格子数量，默认5个，满级6级，10个格子
@export var random_debuff_shop_save = []#本轮随机debuff商店的debuff存储
@export var random_debuff_shop_out_flag = false#是否已经自动抽取
@export var curse_point_required_remain = 0#剩余需要诅咒点
@export var random_debuff_shop_refresh_price = 10#刷新价格，默认为10，每次刷新加5
@export var random_debuff_shop_level = 1#随机debuff商店等级，默认1
@export var random_debuff_shop_upgrade_price = 50#升级价格，默认50，每级增加20
@export var random_debuff_shop_refresh_times = 2 #随机商店免费刷新次数
@export var extra_ran_deb_shop_refresh_times = 0 #随机商店不算免费刷新已经被额外刷了多少次，用于计算刷新价格

#玩家数组记录
@export var save_fixed_debuff:Array[int]=[]#存储固定debuff的数组，根据关卡特性固定产生
@export var save_random_debuff:Array[int]=[]#存储随机debuff的数组，每轮将随机抽取
@export var already_debuff={}#玩家已经拥有的debuff
@export var already_buff={}#玩家已经拥有的buff

#游戏状态
#关卡内情况
@export var cells_with_mines = []#存储哪些地块有雷
@export var cells_with_flags = []#存储哪些雷被标记了
@export var cells_already_with_rules = []#存储哪些地块已经被揭示线索了
@export var cells_checked_recursively = []
@export var flags_placed = 0#放置标记数
@export var is_game_finished = false
@export var game_run_flag = 0 #游戏处于什么状态，0表示新关卡，1表示正在排雷，2表示商店界面
@export var number_of_mines = 3#游戏中的雷数
@export var mines_count = 0 #记录已经解决了多少雷
@export var mines_already_open = []#存储哪些有雷的地块被错误地点开了
@export var current_armor = 0#当前这关的护甲
@export var columns = 5
@export var rows = 5
@export var poison_steps = 0#当前毒计步
@export var cells_with_special_rules = []#存储哪些地块是特殊线索
@export var cells_with_special_grid = []#存储哪些地块是特殊格
@export var cells_with_special_mines = []#存储哪些地块是特殊雷

#固定debuff商店内情况
@export var fixed_debuff_flag = false #记录是否已将本轮fixeddebuff加入


#饰品商店
@export var buff_shop_out_flag = false#是否已经自动抽取
@export var extra_buff_shop_refresh_times = 0 #buff商店不算免费刷新已经被额外刷了多少次，用于计算刷新价格
@export var buff_shop_refresh_times = 2 #buff商店免费刷新次数
@export var buff_shop_base_cells_number = 4#基础格子数
@export var buff_shop_level = 1#等级
@export var buff_shop_save = []#本轮buff商店的buff存储
@export var buff_shop_base_refresh_price = 10#基础刷新价格，默认为10，每次刷新加5
@export var buff_shop_upgrade_price = 50#基础升级价格，默认50




func save():#保存数据
	if not DirAccess.dir_exists_absolute(SAVE_PATH):#如果没有对应文件夹路径，创建路径
		DirAccess.make_dir_absolute(SAVE_PATH)
		pass
	
	var result = ResourceSaver.save(self,SAVE_FILE_PATH)#将self保存至SAVE_FILE_PATH，成功返回0
	#print("result=",result)
	if result == 19:#若出错，弹出报错窗口
		OS.alert("Failed to save\nError: %s" % error_string(result), "Error")
	
	latest_save = self
	pass


func load():
	latest_save = load(SAVE_FILE_PATH)
#static func load():
	#latest_save = load(SAVE_FILE_PATH)


