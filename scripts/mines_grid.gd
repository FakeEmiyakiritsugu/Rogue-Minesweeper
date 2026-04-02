extends TileMap

#关卡内地图相关

class_name MinesGrid

signal flag_plus(number_of_flags)
signal flag_minus(number_of_flags)
signal game_lost
signal game_won(rounds)#游戏胜利，传送回合数的信息
signal lose_hp(hp,hp_max)#失去生命值的信号
signal lose_armor(armor)#失去护甲的信号
signal sig_combo_change(combo_number)#连击增加
signal sig_blood_sucking_change(Remaining_steps,bloodsucking)#吸血连击累计
signal sig_dig_treasure_change(Remaining_steps,dig_treasure)#挖宝连击累计
signal sig_money_change(money)#金钱改变
signal sig_exp_change#经验改变
signal sig_level_change#等级改变
signal sig_poison_steps_change#中毒计数改变
signal sig_poison_layers_change#中毒层数改变
signal sig_up_ui_change#上方主要属性改变



#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径

#预加载窗口
@onready var TIPS_CONTROL = preload("res://Main/tips_control.tscn")

const CELLS = {
	"1": Vector2i(0,0),
	"2": Vector2i(4,0),
	"3": Vector2i(8,0),
	"4": Vector2i(12,0),
	"5": Vector2i(0,4),
	"6": Vector2i(4,4),
	"7": Vector2i(8,4),
	"8": Vector2i(12,4),
	"9": Vector2i(0,8),
	"0": Vector2i(4,8),
	"mine": Vector2i(8,8),
	"red_mine": Vector2i(12,8),
	"flag": Vector2i(0,12),
	"DEFAULT": Vector2i(4,12),
}#词典
const SPECIAL_RULES_CELLS = {
	"？": Vector2i(0,0),
	"Gold": Vector2i(1,0),
	
}#特殊线索词典
const SPECIAL_GRID_CELLS = {
	"black": Vector2i(0,0),
	"poison": Vector2i(1,0),
	"treasure": Vector2i(2,0),
	"confuse": Vector2i(3,0),
	"carnivorous_grass": Vector2i(0,1),
	
}#特殊格词典
const SPECIAL_MINE_CELLS = {
	"poison": Vector2i(0,0),
	"red": Vector2i(1,0),

	
}#特殊格词典



#地图生成相关参数信息
const Tile_SET_ID = 0#使用的TileMap的图层位置
const SPECIAL_RULES_TILE_SET_ID = 1#使用的特殊线索TileMap的图层位置
const SPECIAL_GRID_TILE_SET_ID = 2#使用的特殊格TileMap的图层位置
const SPECIAL_MINE_TILE_SET_ID = 3#使用的特殊雷TileMap的图层位置
const DEFAULT_LAYER = 0#默认图层



# Called when the node enters the scene tree for the first time.
func _ready():
	#clear_layer((DEFAULT_LAYER))
	
	#for i in rows:#创建地图
		#for j in columns:
			##var cell_coord = Vector2(4*(i-rows/2),4*(j-columns/2))
			#var cell_coord = Vector2((i-rows/2),(j-columns/2))
			#set_tile_cell(cell_coord,"DEFAULT")
			#pass
	#place_mines()#测试放置雷
	#place_space()#放置初始的空格线索
	##set_tile_cell(Vector2(0,0),"DEFAULT")
	#pass # Replace with function body.
	
	#loadsave_data()
	Playerdata.loadsave_data()#加载数据
	if Playerdata.game_run_flag == 0:#新关卡
		create_new_map()
		Playerdata.game_run_flag = 1
	elif Playerdata.game_run_flag == 1:#正在排雷
		load_old_map()
		Playerdata.game_run_flag = 1
		pass
	else:#商店
		pass
	
	
	
	
	Playerdata.save()

func loadsave_data():#加载存档
	#加载存档数据
	var save_data = load("user://save/save_data.tres")
	#玩家数值
	Playerdata.HP = save_data.HP #生命值
	Playerdata.armor = save_data.armor#最大护甲
	Playerdata.current_armor = save_data.current_armor#当前这关的护甲
	Playerdata.initial_size = save_data.initial_size#地图初始大小
	Playerdata.rounds = save_data.rounds#回合数
	Playerdata.initial_rules_number = save_data.initial_rules_number #初始给的线索数
	Playerdata.mines_number = save_data.mines_number #地图雷数
	Playerdata.Special_rules = save_data.Special_rules #特殊规则
	Playerdata.money = save_data.money #玩家的金钱
	Playerdata.income = save_data.income
	Playerdata.bloodsucking = save_data.bloodsucking
	Playerdata.dig_treasure = save_data.dig_treasure
	Playerdata.interest = save_data.interest
	Playerdata.max_hp = save_data.max_hp #血量上限
	Playerdata.combo = save_data.combo #连击
	#print("save_data.HP为%d" %save_data.HP)
	
	#游戏状态
	Playerdata.cells_with_mines = save_data.cells_with_mines
	Playerdata.cells_with_flags = save_data.cells_with_flags
	Playerdata.cells_already_with_rules = save_data.cells_already_with_rules
	Playerdata.cells_checked_recursively = save_data.cells_checked_recursively
	Playerdata.flags_placed = save_data.flags_placed
	Playerdata.is_game_finished = save_data.is_game_finished
	Playerdata.game_run_flag = save_data.game_run_flag
	Playerdata.number_of_mines = save_data.number_of_mines
	Playerdata.mines_count = save_data.mines_count
	Playerdata.mines_already_open = save_data.mines_already_open

func load_old_map():#读取之前的地图
	for i in Playerdata.rows:#创建地图
		for j in Playerdata.columns:
			#var cell_coord = Vector2(4*(i-rows/2),4*(j-columns/2))
			var cell_coord = Vector2((i-Playerdata.rows/2),(j-Playerdata.columns/2))
			set_tile_cell(cell_coord,"DEFAULT")
	
	for cell in Playerdata.cells_with_mines:#在对应位置放上雷
		erase_cell(DEFAULT_LAYER,cell)
		set_cell(DEFAULT_LAYER,cell,Tile_SET_ID,CELLS.DEFAULT,1)
		
	place_special_grid()#放置特殊格
	
	#放置线索,不触发combo
	for cell in Playerdata.cells_already_with_rules:
		handle_cells(cell,0)
	for cell in Playerdata.cells_checked_recursively:
		handle_cells(cell,0)
		
	#放置标记
	for cell in Playerdata.cells_with_flags:
		#if cells_with_mines.any(func (cellt):return cellt.x ==  cell.x && cellt.y == cell.y):
			#set_cell(DEFAULT_LAYER,cell,Tile_SET_ID,CELLS.flag,1)
		#else :
			#set_tile_cell(cell,"flag")
		set_cell(DEFAULT_LAYER,cell,Tile_SET_ID,CELLS.flag,1)
	#有bug，点出来的雷会被放置成flag
	
	#放置已被点出的雷
	for cell in Playerdata.mines_already_open:
		#set_tile_cell(cell,"mine")
		set_mine_tile_cell(cell)#设置雷图案

func initial_level():#初始化新一关的参数
	

	#游戏状态
	Playerdata.columns = Playerdata.initial_size
	Playerdata.rows = Playerdata.initial_size
	Playerdata.current_armor = Playerdata.armor
	Playerdata.cells_with_mines.clear()
	Playerdata.cells_with_flags.clear()
	Playerdata.cells_already_with_rules.clear()
	Playerdata.cells_checked_recursively.clear()
	Playerdata.is_game_finished = false
	Playerdata.mines_already_open.clear()
	Playerdata.flags_placed = 0
	Playerdata.mines_count = 0
	Playerdata.mines_already_open.clear()
	Playerdata.number_of_mines = Playerdata.mines_number
	Playerdata.poison_steps = 0
	Playerdata.cells_with_special_rules.clear()
	Playerdata.cells_with_special_grid.clear()
	Playerdata.cells_with_special_mines.clear()
	
	
	init_debuff_effect_before_create_map()##在生成地图前产生效果的debuff
	#系统检测到雷数过多3*（雷数+揭示格子数量）>2*总格子数,系统会自动增加地图大小1
	while 3*(Playerdata.number_of_mines+Playerdata.initial_rules_number)>2*(Playerdata.columns*Playerdata.rows):
		Playerdata.columns+=1
		Playerdata.rows+=1
		
		
	

func init_debuff_effect_before_create_map():#在生成地图前就产生效果的debuff
	for id in Playerdata.already_debuff:#遍历已有的所有debuff
		if id==2:#不定雷
			var mines_randi
			for i in range(Playerdata.already_debuff[id]):
				mines_randi = randi_range(-20,20)
				#print(mines_randi)
				Playerdata.number_of_mines += mines_randi
				if Playerdata.number_of_mines<1:
					Playerdata.number_of_mines = 1
		else:
			pass
	pass


func create_new_map():#开始新的一关
	initial_level()#重新修正参数
	for i in Playerdata.rows:#创建地图
		for j in Playerdata.columns:
			#var cell_coord = Vector2(4*(i-rows/2),4*(j-columns/2))
			var cell_coord = Vector2((i-Playerdata.rows/2),(j-Playerdata.columns/2))
			set_tile_cell(cell_coord,"DEFAULT")
	
	place_mines()#测试放置雷
	initial_special_mine()#初始化特殊雷
	
	initial_special_grid()#初始化特殊格
	place_special_grid()#放置初始的特殊格
	
	initial_special_clue()#初始化特殊线索
	
	extra_initial()#特殊的初始化
	place_space()#放置初始的空格线索
	start_buff_effect()#初始化时的buff作用
	

func start_buff_effect():#初始化时的buff作用
	var open_treasure = 0
	for id in Playerdata.already_buff:
		if id == 6:
			open_treasure = Playerdata.already_buff[id]
	for i in range(Playerdata.rows):#遍历
		for j in range(Playerdata.columns):
			if Playerdata.cells_with_special_grid[i][j] == "treasure" and open_treasure>0:
				open_treasure -= 1
				handle_cells(from_ij_to_cell_coord(i,j),0)
	pass

func from_ij_to_cell_coord(i:int,j:int):#将ij转换为tilemap中的坐标
	return Vector2((j-Playerdata.rows/2),(i-Playerdata.columns/2))

func extra_initial():#特殊的初始化，没地方放的部分
	for i in range(Playerdata.rows):#遍历
		for j in range(Playerdata.columns):
			var cell_coord = from_ij_to_cell_coord(i,j)
			#检查雷
			#检查格
			if Playerdata.cells_with_special_grid[i][j] == "confuse":#检查confuse格
				if i-1>=0 and Playerdata.cells_with_special_rules[i-1][j]==" ":
					Playerdata.cells_with_special_rules[i-1][j] = "?"
				if i+1<Playerdata.rows and Playerdata.cells_with_special_rules[i+1][j]==" ":
					Playerdata.cells_with_special_rules[i+1][j] = "?"
				if j-1>=0 and Playerdata.cells_with_special_rules[i][j-1]==" ":
					Playerdata.cells_with_special_rules[i][j-1] = "?"
				if j+1<Playerdata.columns and Playerdata.cells_with_special_rules[i][j+1]==" ":
					Playerdata.cells_with_special_rules[i][j+1] = "?"
			#检查线索
			
	pass
func get_ij(cell_coord:Vector2i):#从cell_coord获得i与j
	#var ij = Vector2i(cell_coord.x+Playerdata.rows/2,cell_coord.y+Playerdata.columns/2)
	var ij = Vector2i(cell_coord.y+Playerdata.columns/2,cell_coord.x+Playerdata.rows/2)
	return ij
	


func initial_special_clue():#初始化特殊线索
	for i in range(Playerdata.rows):#初始化特殊线索的网格
		var rowi = []
		for j in range(Playerdata.columns):
			var cell_coord = from_ij_to_cell_coord(i,j)
			if Playerdata.cells_with_mines.has(cell_coord):
				rowi.append("0")#如果有雷标记0
			else :
				rowi.append(" ")#如果无雷标记空格
		Playerdata.cells_with_special_rules.append(rowi)
	
	#我需要一个随机不重复的二维坐标数组
	var special_clue_random_array = get_unique_randoms(Playerdata.rows,Playerdata.columns)
	place_mark_in_clue_array(Playerdata.question_mark_grid,special_clue_random_array,Playerdata.cells_with_special_rules,"?")
	
	
	
	pass


func place_mark_in_grid_array(rangenumber:int,random_array:Array,mark_array:Array, mark:String ):#在特殊格数组里做标记
	#rangenumber遍历数量，special_clue_random_array随机二维数组，mark_array标记数组，mark标记
	var ij
	for i in range(rangenumber):
		#if mark_array[ij.x][ij.y]!= "0":
			#mark_array[ij.x][ij.y] = mark
		ij = random_array.pop_back()
		#cell_coord = Vector2((ij.i-Playerdata.rows/2),(ij.j-Playerdata.columns/2))
		#if mark_array[ij.x][ij.y]!= "0":
			#mark_array[ij.x][ij.y] = mark
		mark_array[ij.x][ij.y] = mark
		pass
	pass
	
func place_mark_in_clue_array(rangenumber:int,random_array:Array,mark_array:Array, mark:String ):#在特殊线索数组里做标记
	#rangenumber遍历数量，special_clue_random_array随机二维数组，mark_array标记数组，mark标记
	var ij
	for i in range(rangenumber):
		ij = random_array.pop_back()
		#cell_coord = Vector2((ij.i-Playerdata.rows/2),(ij.j-Playerdata.columns/2))
		if mark_array[ij.x][ij.y] == " ":
			mark_array[ij.x][ij.y] = mark
		pass
	pass

func get_unique_randoms(row: int, column:int) -> Array:
	#生成随机不重复的二维坐标数组
	#
	#参数:
		#width: 坐标范围的宽度 (x坐标从0到width-1)
		#height: 坐标范围的高度 (y坐标从0到height-1)
		#count: 需要生成的坐标数量
	var nums = []
	
	# 1. 生成 0..count-1 的数字列表
	for r in range(row):
		for c in range(column):
			nums.append(Vector2i(r,c))
	
	randomize()  # 初始化全局随机种子
	nums.shuffle()  # 使用指定的随机数生成器打乱数组

	return nums




func initial_special_mine():#初始化特殊雷
	for i in range(Playerdata.rows):#初始化特殊雷的网格
		var rowi = []
		for j in range(Playerdata.columns):
			rowi.append(" ")#标记无特殊效果
		Playerdata.cells_with_special_mines.append(rowi)
	
	#我需要一个随机不重复的二维坐标数组,这里可以直接用雷的存储数组
	# 浅拷贝：复制数组本身，但内部元素仍为引用（适合简单类型如Vector2）
	var special_gird_random_array = Playerdata.cells_with_mines.duplicate()
	place_mark_in_special_mine_array(Playerdata.red_thunder,special_gird_random_array,Playerdata.cells_with_special_mines,"red")#红雷
	place_mark_in_special_mine_array(Playerdata.poison_thunder,special_gird_random_array,Playerdata.cells_with_special_mines,"poison")#毒雷
	
	
	pass

func place_mark_in_special_mine_array(rangenumber:int,random_array:Array,mark_array:Array, mark:String ):#在特殊雷数组里做标记
	#rangenumber遍历数量，special_clue_random_array随机二维数组，mark_array标记数组，mark标记
	var ij
	for i in range(rangenumber):
		if random_array.size()>0:#没有位置就跳过
			ij = get_ij(random_array.pop_back())
			mark_array[ij.x][ij.y] = mark
		pass
	pass


func initial_special_grid():#初始化特殊格
	for i in range(Playerdata.rows):#初始化特殊线索的网格
		var rowi = []
		for j in range(Playerdata.columns):
			rowi.append(" ")#标记普通格
		Playerdata.cells_with_special_grid.append(rowi)
	
	#我需要一个随机不重复的二维坐标数组
	var special_gird_random_array = get_unique_randoms(Playerdata.rows,Playerdata.columns)
	place_mark_in_grid_array(Playerdata.black_grid,special_gird_random_array,Playerdata.cells_with_special_grid,"black")#黑色格
	place_mark_in_grid_array(Playerdata.poison_grid,special_gird_random_array,Playerdata.cells_with_special_grid,"poison")#毒格
	place_mark_in_grid_array(Playerdata.treasure_grid,special_gird_random_array,Playerdata.cells_with_special_grid,"treasure")#宝藏格
	place_mark_in_grid_array(Playerdata.confusing_grid,special_gird_random_array,Playerdata.cells_with_special_grid,"confuse")#迷惑格
	if Playerdata.already_buff.has(13):
		place_mark_in_grid_array(Playerdata.already_buff[13],special_gird_random_array,Playerdata.cells_with_special_grid,"carnivorous_grass")#食腐草格
	
	pass

func place_special_grid():#放置特殊格
	var cell
	var has_mine_flag
	for i in range(Playerdata.rows):
		for j in range(Playerdata.columns):
			cell = from_ij_to_cell_coord(i,j)
			if Playerdata.cells_with_mines.has(cell):#是否有雷
				has_mine_flag = 1
			else:
				has_mine_flag = 0
			if Playerdata.cells_with_special_grid[i][j] == "black":#放置黑色格
				set_special_grid_cell(i,j,"black",cell,has_mine_flag)#放置黑色格
			elif Playerdata.cells_with_special_grid[i][j] == "poison":#放置毒格
				set_special_grid_cell(i,j,"poison",cell,has_mine_flag)
			elif Playerdata.cells_with_special_grid[i][j] == "treasure":#放置宝藏格
				set_special_grid_cell(i,j,"treasure",cell,has_mine_flag)
			elif Playerdata.cells_with_special_grid[i][j] == "confuse":#迷惑格
				set_special_grid_cell(i,j,"confuse",cell,has_mine_flag)
			elif Playerdata.cells_with_special_grid[i][j] == "carnivorous_grass":#食腐草格
				set_special_grid_cell(i,j,"carnivorous_grass",cell,has_mine_flag)
			#if Playerdata.cells_with_special_grid[i][j] == "black":#放置黑色格
				#erase_cell(DEFAULT_LAYER,cell)
				#set_cell(DEFAULT_LAYER,cell,SPECIAL_GRID_TILE_SET_ID,SPECIAL_GRID_CELLS.black,has_mine_flag)
	pass

func set_special_grid_cell(i:int,j:int,grid_type:String,cell_coord:Vector2i,has_mine_flag):#place_special_grid函数中放置对应格的封装
	erase_cell(DEFAULT_LAYER,cell_coord)
	set_cell(DEFAULT_LAYER,cell_coord,SPECIAL_GRID_TILE_SET_ID,SPECIAL_GRID_CELLS[grid_type],has_mine_flag)
	pass
	

func place_space():#初始揭示空格线索
	
	for i in Playerdata.initial_rules_number:
		var cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows-Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns-Playerdata.columns/2-1))
		while Playerdata.cells_with_mines.has(cell_coordinate) or Playerdata.cells_already_with_rules.has(cell_coordinate):
			cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows-Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns-Playerdata.columns/2-1))
		
		Playerdata.cells_already_with_rules.append(cell_coordinate)
	for cell in Playerdata.cells_already_with_rules:
		detect_special_grids(1,cell)#放线索前首先判定是否是特殊格
		handle_cells(cell, 0)
	
	
	#Playerdata.combo=Playerdata.combo-Playerdata.cells_already_with_rules.size()#防止揭示初始线索导致连击数变化
	#sig_combo_change.emit(Playerdata.combo)
	pass

func add_combo():#增加连击数
	Playerdata.combo+=1
	sig_combo_change.emit(Playerdata.combo)
	#吸血
	if Playerdata.combo%Playerdata.bloodsucking==0:#吸血
		add_HP(Playerdata.get_bloodsucking_recovery_reward())
		#if Playerdata.HP+Playerdata.get_bloodsucking_recovery_reward()<=Playerdata.max_hp:
			#Playerdata.HP += Playerdata.get_bloodsucking_recovery_reward()
		#else:
			#Playerdata.HP = Playerdata.max_hp
		#lose_hp.emit(Playerdata.HP,Playerdata.max_hp)
	sig_blood_sucking_change.emit(Playerdata.combo%Playerdata.bloodsucking,Playerdata.bloodsucking)
	#挖宝
	if Playerdata.combo%Playerdata.get_dig_treasure()==0:
		Playerdata.money += Playerdata.get_dig_treasure_money()
		sig_money_change.emit(Playerdata.money)
	sig_dig_treasure_change.emit(Playerdata.combo%Playerdata.get_dig_treasure(),Playerdata.get_dig_treasure())

func add_exp(number:int):#增加经验值
	Playerdata.exp += number*Playerdata.gain_experience
	while Playerdata.exp >= Playerdata.get_exp_upgrade():
		Playerdata.exp -= Playerdata.get_exp_upgrade()
		Playerdata.level += 1
		sig_level_change.emit()
	
	sig_exp_change.emit()
	pass

func _input(event:InputEvent):#点击触发事件
	if Playerdata.is_game_finished:
		return
		
	if !(event is InputEventMouseButton)||!event.pressed:
		return
	var clicked_cell_coord = local_to_map(get_local_mouse_position())#获得鼠标点击的单元格在tilemap中的坐标

	if event.button_index == 1:
		on_cell_clicked(clicked_cell_coord)
		#print("clicked_cell_coord=",clicked_cell_coord)#先列再行
	elif event.button_index == 2:
		#print("Place Flag ")
		place_flag(clicked_cell_coord)
		
		
func place_flag(cell_coord:Vector2i):#放置雷标记
	var tile_data = get_cell_tile_data(DEFAULT_LAYER,cell_coord)
	var atlast_coordinates = get_cell_atlas_coords(DEFAULT_LAYER,cell_coord)
	var cell_source_id = get_cell_source_id(DEFAULT_LAYER,cell_coord)
	var is_empty_cell = atlast_coordinates == Vector2i(4,12) and cell_source_id == 0
	var is_flag_cell = atlast_coordinates == Vector2i(0,12) and cell_source_id == 0
	#if !is_empty_cell and !is_flag_cell:
		##print("无效标记")
		#return
	
	var is_has_mine = tile_data.get_custom_data("has_mine")
	
	if is_flag_cell:
		#if is_has_mine:#若有雷设置有雷的地块，
			#set_cell(DEFAULT_LAYER,cell_coord,Tile_SET_ID,CELLS.DEFAULT,1)
		#else:
			#set_tile_cell(cell_coord,"DEFAULT")
		#cells_with_flags.erase(cell_coord)
		#mines_count -=1
		#flag_minus.emit(mines_count)
		
		return
	elif is_empty_cell or get_cell_source_id(DEFAULT_LAYER,cell_coord) == 2:
		#if Playerdata.mines_count == Playerdata.number_of_mines:
			#return
		
		
		
		if is_has_mine:#若有雷设置有雷的flag
			detect_special_grids(1,cell_coord)#检测特殊格
			Playerdata.mines_count+=1
			flag_plus.emit(Playerdata.mines_count)
			set_cell(DEFAULT_LAYER,cell_coord,Tile_SET_ID,CELLS.flag,1)
			Playerdata.cells_with_flags.append(cell_coord)
			add_combo()
			add_exp(1)
			steps_change(1)
		else:
			#若无雷扣血并展示格子内容
			Playerdata.cells_checked_recursively.append(cell_coord)
			detect_special_grids(0,cell_coord)#检测特殊格
			harm(1)
			if Playerdata.HP==0:
				lose(cell_coord)
				return
			handle_cells(cell_coord)
			steps_change(1)
		#点到错误的雷也会导向这里，需要一个系统性的修改
		#print("nmd")
		
	
	#var count = 0
	#for flag_cell in cells_with_flags:#计算标记正确的雷的数量
		#for mine_cell in cells_with_mines:
			#if flag_cell.x == mine_cell.x and flag_cell.y == mine_cell.y:
				#count+=1
				
	if Playerdata.mines_count == Playerdata.cells_with_mines.size():#判断是否胜利
		win()
	
func win():#胜利
	Playerdata.is_game_finished = true
	#print("test1")
	for i in Playerdata.rows:
		for j in Playerdata.columns:
			#print("test2")
			var cell_coord = Vector2((i-Playerdata.rows/2),(j-Playerdata.columns/2))
			handle_cells(cell_coord,0)
			#var title_data = get_cell_tile_data(DEFAULT_LAYER,cell_coord)
			#var cell_has_mine = title_data.get_custom_data("has_mine")
			##print("cell_has_mine=%d",cell_has_mine)
			#if cell_has_mine:
				#continue
			#var mine_count = get_surrounding_cells_mine_count(cell_coord)
			#set_tile_cell(cell_coord,"%d" % mine_count)
			#print("显示成功")
			
	#胜利结算
	Playerdata.rounds=Playerdata.rounds+1#回合数加一
	Playerdata.game_run_flag=2#页面位置flag
	Playerdata.money = Playerdata.money+Playerdata.income+Playerdata.number_of_mines#结算金钱
	Playerdata.fixed_debuff_flag = false#固定debuffflag刷新
	Playerdata.save_fixed_debuff.clear()#清空固定debuff存储数组
	Playerdata.random_debuff_shop_save.clear()#清空随机debuff存储
	Playerdata.random_debuff_shop_out_flag = false#随机debuffflag刷新
	Playerdata.money += floor(Playerdata.money/Playerdata.interest)#增加利息
	#Playerdata.HP += Playerdata.life_regeneration#增加每回合生命回复
	add_HP(Playerdata.life_regeneration)#增加每回合生命回复
	Playerdata.poisoning_layers = 0#清空毒层数
	Playerdata.poison_steps = 0 #清空毒步数
	Playerdata.total_steps = 0 #清空总步数
	
	
	end_buff_effect()
	
	
	
	
	if Playerdata.HP>Playerdata.max_hp:
		Playerdata.HP=Playerdata.max_hp
	
	
	lose_hp.emit(Playerdata.HP,Playerdata.max_hp)
	if Playerdata.HP <= 0:
		lose_noparamter()
		return
	#保存存档
	savedata()
	game_won.emit(Playerdata.rounds)


func end_buff_effect():#结算触发的buff
	for id in Playerdata.already_buff:
		if id == 2:
			Playerdata.money += 20 * Playerdata.already_buff[id]
		
	pass
func harm(harmnumber:int):#受到伤害
	#判定是否闪避伤害
	var dodge_randi = randi_range(0,100)
	if dodge_randi<Playerdata.dodge:
		return
	
	
	#受到伤害
	
	Playerdata.combo=0#连击置零
	sig_combo_change.emit(Playerdata.combo)#连击ui
	sig_blood_sucking_change.emit(0,Playerdata.bloodsucking)#吸血ui
	
	
	if Playerdata.current_armor>0 and Playerdata.current_armor>=harmnumber:#若护甲不为0,失去护甲
		Playerdata.current_armor=Playerdata.current_armor-harmnumber
		lose_armor.emit(Playerdata.current_armor)
	elif Playerdata.current_armor>0 and Playerdata.current_armor<harmnumber :#若有护甲但护甲不够抵扣
		Playerdata.HP=Playerdata.HP+Playerdata.current_armor-harmnumber
		Playerdata.current_armor=0
		lose_armor.emit(Playerdata.current_armor)
		lose_hp.emit(Playerdata.HP,Playerdata.max_hp)
	elif Playerdata.current_armor==0 :#没有护甲
		Playerdata.HP=Playerdata.HP-harmnumber
		lose_hp.emit(Playerdata.HP,Playerdata.max_hp)
		pass
	else:
		print("护甲血量出现问题！")
	
	

	pass
	
func detect_special_grids(answer, cell_coord:Vector2i):#检测特殊格，0为猜错，1为猜对
	var ij = get_ij(cell_coord)
	if Playerdata.cells_with_special_grid[ij.x][ij.y] == "black":#黑色格
		if answer == 0:
			harm(1)
	elif Playerdata.cells_with_special_grid[ij.x][ij.y] == "poison":#毒格
		if answer == 0:
			Playerdata.poisoning_layers += 1
			sig_poison_layers_change.emit()
	elif Playerdata.cells_with_special_grid[ij.x][ij.y] == "treasure":#宝藏格
		if answer == 1:
			Playerdata.money += Playerdata.get_treasure_reward()
			sig_money_change.emit(Playerdata.money)
	elif Playerdata.cells_with_special_grid[ij.x][ij.y] == "confuse":#迷惑格
		if answer==1:
			var cell_coord_test
			if ij.x-1>=0 and Playerdata.cells_with_special_rules[ij.x-1][ij.y]=="?":
				Playerdata.cells_with_special_rules[ij.x-1][ij.y] = " "
				cell_coord_test = cell_coord+Vector2i(0,-1)
				handle_cells(cell_coord_test, 0)
			if ij.x+1<Playerdata.rows and Playerdata.cells_with_special_rules[ij.x+1][ij.y]=="?":
				Playerdata.cells_with_special_rules[ij.x+1][ij.y] = " "
				cell_coord_test = cell_coord+Vector2i(0,1)
				handle_cells(cell_coord_test, 0)
			if ij.y-1>=0 and Playerdata.cells_with_special_rules[ij.x][ij.y-1]=="?":
				Playerdata.cells_with_special_rules[ij.x][ij.y-1] = " "
				cell_coord_test = cell_coord+Vector2i(-1,0)
				handle_cells(cell_coord_test, 0)
			if ij.y+1<Playerdata.columns and Playerdata.cells_with_special_rules[ij.x][ij.y+1]=="?":
				Playerdata.cells_with_special_rules[ij.x][ij.y+1] = " "
				cell_coord_test = cell_coord+Vector2i(1,0)
				handle_cells(cell_coord_test, 0)
	elif Playerdata.cells_with_special_grid[ij.x][ij.y] == "carnivorous_grass":#食腐草格
		var surrounding_cells = get_surrounding_mines(cell_coord)
		var cell_atlas
		var cell_source_id
		var count_test = 0
		surrounding_cells.erase(cell_coord)
		for cell in surrounding_cells:
			cell_atlas=get_cell_atlas_coords(DEFAULT_LAYER,cell)
			cell_source_id=get_cell_source_id(DEFAULT_LAYER,cell)
			if (cell_source_id==0 and cell_atlas == Vector2i(4,12)) or cell_source_id == 2:
				break
			count_test += 1
		if count_test == surrounding_cells.size():
			add_HP(1)
	pass

func add_HP(number:int):#回复生命
	if Playerdata.HP + number > Playerdata.max_hp:
		return
	else:
		Playerdata.HP += number
		lose_hp.emit(Playerdata.HP,Playerdata.max_hp)


func detect_special_mines(cell_coord:Vector2i):#检测是否是特殊雷,若是产生对应效果
	var ij = get_ij(cell_coord)
	if Playerdata.cells_with_special_mines[ij.x][ij.y] == "poison":#毒雷
		Playerdata.poisoning_layers += 1
		sig_poison_layers_change.emit()
	elif Playerdata.cells_with_special_grid[ij.x][ij.y] == "red":#红雷
		harm(1)
	else:
		return
	pass


func on_cell_clicked(cell_coord:Vector2i):#鼠标点击地块
	var cell_number_vector2i = get_cell_atlas_coords(DEFAULT_LAYER,cell_coord)
	if (get_cell_source_id(DEFAULT_LAYER,cell_coord) == 0 and cell_number_vector2i == Vector2i(4,12)) or get_cell_source_id(DEFAULT_LAYER,cell_coord) == 2:
		if Playerdata.cells_with_mines.any(func (cell):return cell.x ==  cell_coord.x && cell.y == cell_coord.y):#只要有一个雷与点击的地块一样就返回true
			#受到伤害，揭示格子，并判断是否胜利
			detect_special_grids(0, cell_coord)#检测特殊格
			detect_special_mines(cell_coord)#检测特殊雷
			harm(1)
			if Playerdata.HP <= 0:#这里有问题
				lose(cell_coord)
				return
			#set_tile_cell(cell_coord,"mine")
			set_mine_tile_cell(cell_coord)#设置雷图案
			Playerdata.mines_already_open.append(cell_coord)
			Playerdata.mines_count = Playerdata.mines_count + 1 #雷计数加一
			flag_plus.emit(Playerdata.mines_count)#修改ui雷数
			steps_change(1)
			if Playerdata.mines_count == Playerdata.cells_with_mines.size():#判断是否胜利
				win()
			return
			
		else:#没有点到雷
			detect_special_grids(1, cell_coord)#检测特殊格
			Playerdata.cells_checked_recursively.append(cell_coord)
			#Playerdata.mines_already_open.append(cell_coord)
			handle_cells(cell_coord)#测试
			steps_change(1)
	
	

func lose(cell_corrd:Vector2i):#游戏失败
	game_lost.emit()
	Playerdata.is_game_finished = true
	for cell in Playerdata.cells_with_mines:
		#set_tile_cell(cell,"mine")
		set_mine_tile_cell(cell)
	
	#弹出游戏失败
	var lose_con = TIPS_CONTROL.instantiate()#实例化场景资源
	lose_con.get_node("CanvasLayer/Label").text = "游戏失败"
	add_child(lose_con)
	#set_tile_cell(cell_corrd,"red_mine")
	##删除失败存档
	#DirAccess.remove_absolute(Playerdata.SAVE_FILE_PATH)  # 删除旧存档文件
	
func lose_noparamter():#游戏失败(无参数)
	#game_lost.emit()
	#Playerdata.is_game_finished = true
	#for cell in Playerdata.cells_with_mines:
		#set_tile_cell(cell,"mine")
	game_lost.emit()
	Playerdata.is_game_finished = true
	for cell in Playerdata.cells_with_mines:
		#set_tile_cell(cell,"mine")
		set_mine_tile_cell(cell)
	
	#弹出游戏失败
	var lose_con = TIPS_CONTROL.instantiate()#实例化场景资源
	lose_con.get_node("CanvasLayer/Label").text = "游戏失败"
	add_child(lose_con)
		

func handle_cells(cell_coord: Vector2i,combo_flag:int = 1):#对点击非雷地块的处理
	#comboflag为1表示不进行combo，为1进行
	if combo_flag==1:
		add_combo()
	var title_data = get_cell_tile_data(DEFAULT_LAYER,cell_coord)
	#print(title_data)#测试titledata
	if title_data==null:
		#print("无地块");
		return
	
	var cell_has_mine = title_data.get_custom_data("has_mine")
	
	if cell_has_mine:#如果有雷
		#print("有雷");
		return
		
	#var surrounding_cells = get_surrounding_cells(cell_coord)#测试
	#print(surrounding_cells)
	#特殊线索
	var ij = get_ij(cell_coord)
	if Playerdata.cells_with_special_rules[ij.x][ij.y]=="?":#问号线索
		set_cell(DEFAULT_LAYER,cell_coord,SPECIAL_RULES_TILE_SET_ID,SPECIAL_RULES_CELLS["？"])
		return
	
	var mine_count = get_surrounding_cells_mine_count(cell_coord)
	
	if Playerdata.Special_rules == 0:#无特殊规则
		set_tile_cell(cell_coord,"%d" % mine_count)
		#if mine_count == 0:#递归处理0地块
			#set_tile_cell(cell_coord,"0")
			##var surrounding_cells = get_surrounding_cells(cell_coord)
			#var surrounding_cells = get_surrounding_mines(cell_coord)
			#for cell in surrounding_cells:
				#handle_surrounding_cells(cell)
			#pass
		#else:
			#set_tile_cell(cell_coord,"%d" % mine_count)
	elif Playerdata.Special_rules == 1:#大误差规则,雷可能+1-1，可能不变
		var randi_number = randi_range(-1, 1)
		mine_count = mine_count+randi_number
		if mine_count<0:
			mine_count = 0
		
		set_tile_cell(cell_coord,"%d" % mine_count)
	elif Playerdata.Special_rules == 2:#小误差规则，雷一定会+1-1
		var randi_number = 1 if randf() < 0.5 else -1
		mine_count = mine_count+randi_number
		if mine_count<0:
			mine_count = 1
		
		set_tile_cell(cell_coord,"%d" % mine_count)
	
func handle_surrounding_cells(cell_coord:Vector2i):#处理周围地块
	if Playerdata.cells_checked_recursively.has(cell_coord):
		return
		
	Playerdata.cells_checked_recursively.append(cell_coord)
	handle_cells(cell_coord)

func get_surrounding_cells_mine_count(cell_coord: Vector2i):#获取点击地块的周围雷数
	var mine_count = 0
	#var surrounding_cells = get_surrounding_cells(cell_coord)#这里可能不符合我的扫雷
	var surrounding_cells = get_surrounding_mines(cell_coord)
	for cell in surrounding_cells:
		#print(cell)
		var tile_data = get_cell_tile_data(DEFAULT_LAYER,cell)
		if tile_data and tile_data.get_custom_data("has_mine"):
			mine_count +=1
			
	return mine_count

func get_surrounding_mines(cell_coord: Vector2i):#获取地块周围8个格子
	var surrounding_cells = []
	for i in range(cell_coord.y-1,cell_coord.y+2):
		for j in range(cell_coord.x-1,cell_coord.x+2):
			surrounding_cells.append(Vector2i(j,i))
	
	#print("cell_coord：")
	#print(cell_coord)
	#print("周围的雷：")
	#print(surrounding_cells)
	return surrounding_cells

func place_mines():#放置雷
	for i in Playerdata.number_of_mines:
		#var cell_coordinate = Vector2(randi_range(-2*rows,2*rows-1),randi_range(-2*columns,2*columns-1))
		#while cells_with_mines.has(cell_coordinate):
			#cell_coordinate = Vector2(randi_range(-2*rows,2*rows-1),randi_range(-2*columns,2*columns-1))
		
		#var cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns/2-1))
		#while Playerdata.cells_with_mines.has(cell_coordinate):
			#cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns/2-1))
		
		var cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows-Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns-Playerdata.columns/2-1))
		while Playerdata.cells_with_mines.has(cell_coordinate):
			cell_coordinate = Vector2(randi_range(-Playerdata.rows/2,Playerdata.rows-Playerdata.rows/2-1),randi_range(-Playerdata.columns/2,Playerdata.columns-Playerdata.columns/2-1))

		Playerdata.cells_with_mines.append(cell_coordinate)
	for cell in Playerdata.cells_with_mines:
		erase_cell(DEFAULT_LAYER,cell)
		set_cell(DEFAULT_LAYER,cell,Tile_SET_ID,CELLS.DEFAULT,1)
		#var test = get_cell_tile_data(DEFAULT_LAYER,cell)
		#var test_coord =cell
		#var test_custom = test.get_custom_data("has_mine")
		#print("test_coord =",test_coord)
		#print("test_custom = %",test_custom)
		

func set_tile_cell(cell_coord,cell_type):#在cell——coord坐标生成cell——type类型的地块
	set_cell(DEFAULT_LAYER,cell_coord,Tile_SET_ID,CELLS[cell_type])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
func set_mine_tile_cell(cell_coord):#在cell——coord坐标生成正确的雷的图案
	var ij = get_ij(cell_coord)
	if Playerdata.cells_with_special_mines[ij.x][ij.y] == "poison":#毒雷
		set_cell(DEFAULT_LAYER,cell_coord,SPECIAL_MINE_TILE_SET_ID,SPECIAL_MINE_CELLS["poison"])
	elif Playerdata.cells_with_special_mines[ij.x][ij.y] == "red":#红雷
		set_cell(DEFAULT_LAYER,cell_coord,SPECIAL_MINE_TILE_SET_ID,SPECIAL_MINE_CELLS["red"])
	else:
		set_cell(DEFAULT_LAYER,cell_coord,Tile_SET_ID,CELLS["mine"])
	pass

func savedata():#保存数据
	#直接调用Playerdata的save函数
	Playerdata.save()
	
func steps_change(change_nunmber:int):#步数变化
	#中毒计数
	Playerdata.total_steps += change_nunmber#总步数改变
	
	if Playerdata.poisoning_layers>0:
		Playerdata.poison_steps += change_nunmber
		if Playerdata.poison_steps%Playerdata.poison_resistance == 0:
			Playerdata.poison_steps = 0
			harm(Playerdata.poisoning_layers)
			#血量低于0触发失败
			if Playerdata.HP <= 0:
				lose_noparamter()
		sig_poison_steps_change.emit()
	
	
	#ui改变
	sig_up_ui_change.emit()
	
	pass
