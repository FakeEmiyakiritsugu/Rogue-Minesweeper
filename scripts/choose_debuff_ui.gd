extends CanvasLayer

#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
#var latest_save:SaveData = null #记录上个存档

#相关参数
var actural_ran_deb_shop_refresh_price#实际随机debuff商店刷新价格
var actural_ran_deb_shop_upgrade_price#实际随机debuff商店升级价格
var actural_ran_deb_shop_cells_number#实际随机debuff商店格子数量


#ui相关

@onready var tips_control = preload("res://Main/tips_control.tscn")#预加载诅咒点提示窗口
@onready var lose_control = preload("res://Main/lose_control.tscn")#预加载死亡窗口


#储存对应ui组件的数组
var fixed_debuff_equip_back_panel = []#固定debuff总
var fixed_debuffname_label = []#固定debuff名字
var fixed_debuff_type_label = []#固定debuff种类
var fixed_debuff_effect_label = []#固定debuff效果描述


var random_debuff_equip_back_panel = []#随机debuff总
var random_debuffname_label = []#随机debuff名字
var random_debuff_type_label = []#随机debuff种类
var random_debuff_effect_label = []#随机debuff效果描述
var random_debuff_pricebutton_label = []#随机debuff诅咒点数按钮


var already_debuff_equip_back_panel = []#已有debuff总
var already_debuffname_label = []#已有debuff名字
var already_debuff_type_label = []#已有debuff种类
var already_debuff_effect_label = []#已有debuff效果描述
var already_debuff_cursepoint_label = []#已有debuff诅咒点数
var already_debuff_cursenumber_label = []#已有debuff诅咒数量
#固定debuff商店
@onready var fixed_debuff_equip_back_panel_1 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel1
@onready var fixed_debuffname_label1 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel1/FixedDebuffVBoxContainer/HBoxContainer/VBoxContainer/FixedDebuffnameLabel
@onready var fixed_debuff_type_label1 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel1/FixedDebuffVBoxContainer/HBoxContainer/VBoxContainer/FixedDebuffTypeLabel
@onready var fixed_debuff_effect_label1 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel1/FixedDebuffVBoxContainer/FixedDebuffEffectLabel

@onready var fixed_debuff_equip_back_panel_2 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel2
@onready var fixed_debuffname_label2 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel2/FixedDebuffVBoxContainer/HBoxContainer/VBoxContainer/FixedDebuffnameLabel
@onready var fixed_debuff_type_label2 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel2/FixedDebuffVBoxContainer/HBoxContainer/VBoxContainer/FixedDebuffTypeLabel
@onready var fixed_debuff_effect_label2 = $PanelContainer/HBoxContainer/VBoxContainer/FixedDebuffHBoxContainer/FixedDebuffEquipBackPanel2/FixedDebuffVBoxContainer/FixedDebuffEffectLabel


#随机debuff商店
@onready var random_debuff_back_panel = preload("res://Main/random_debuff_back_panel.tscn")#预加载窗口
@onready var text_curse_point = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel7/TextCursePoint#剩余诅咒点label
@onready var random_debuff_shop_level = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel3/RandomDebuffShopLevel#随机debuff商店等级
@onready var upgrade_price_label = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel9/UpgradePriceLabel#随机debuff商店升级价格



#已有debuff 显示
@onready var already_debuff_back_panel = preload("res://Main/already_debuff_back_panel.tscn")#预加载窗口
@onready var text_total_curse_point = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer3/Panel3/TextTotalCursePoint#总诅咒点label
@onready var refresh_price_label = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel5/RefreshPriceLabel#刷新价格label


#摄像机左边
@onready var money_label = $PanelContainer4/VBoxContainer/HBoxContainer/Panel2/MoneyLabel#剩余金钱label
@onready var random_debuff_shop_free_refresh_label = $PanelContainer4/VBoxContainer/HBoxContainer2/Panel2/FreeRefreshLabel#剩余免费刷新次数label


##玩家数值
#var HP = 5 #生命值
#var armor = 2#最大护甲
#var current_armor = 2#当前这关的护甲
#var initial_size = 5#地图初始大小
#var rounds = 1#回合数
#var initial_rules_number = 8 #初始给的线索数
#var mines_number = 3 #地图雷数
#@export var Special_rules = 0#当前游戏使用的规则，0表示原版，1表示大误差，2表示小误差
#var money = 15 #玩家的金钱
#@export var income = 10 #每回合过后增加的金钱是收入+雷数
#@export var bloodsucking = 10#连续点开？格子不触雷后回复1点生命
#@export var dig_treasure = 10#连续点开？格子不触雷后获得1点钱
#@export var interest = 10#每回合结束，每有？的钱就给？钱
#@export var max_hp = 5 #血量上限
#@export var combo = 10 #连击
# Called when the node enters the scene tree for the first time.




func _ready():
	#print(LoadSource.debuff_dic[0]["category"])
	#fixed_debuffname_label1.text=LoadSource.debuff_dic[1]["name"]
	#fixed_debuff_type_label1.text=LoadSource.debuff_dic[1]["category"]
	#fixed_debuff_effect_label1.text=LoadSource.debuff_dic[1]["description"]
	#latest_save = load(SAVE_FILE_PATH)
	#print(latest_save.game_run_flag)
	
	Playerdata.loadsave_data()
	init_fixed()
	init_random()
	init_already()
	init_leftui()
	Playerdata.save()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_actural_ran_deb_shop_refresh_price():#实际刷新价格=基础刷新价格+5*额外刷新次数
	actural_ran_deb_shop_refresh_price = Playerdata.random_debuff_shop_refresh_price+5*Playerdata.extra_ran_deb_shop_refresh_times
	return actural_ran_deb_shop_refresh_price

func init_leftui():#初始化左侧ui
	money_label.text = str(Playerdata.money)#剩余金钱
	random_debuff_shop_free_refresh_label.text = str(Playerdata.random_debuff_shop_refresh_times)#剩余免费刷新次数
	pass


func init_fixed():#初始化fixeddebuff的总封装
	init_fixed_debuff()
	init_fixed_ui()
	show_fixed_debuff()

func init_fixed_ui():#初始化fixeddebuff,ui的数组
	#固定debuff
	fixed_debuff_equip_back_panel.append(fixed_debuff_equip_back_panel_1)
	fixed_debuff_equip_back_panel.append(fixed_debuff_equip_back_panel_2)
	
	#固定debuff名字
	fixed_debuffname_label.append(fixed_debuffname_label1)
	fixed_debuffname_label.append(fixed_debuffname_label2)
	
	#固定debuff种类
	fixed_debuff_type_label.append(fixed_debuff_type_label1)
	fixed_debuff_type_label.append(fixed_debuff_type_label2)
	
	#固定debuff作用描述
	fixed_debuff_effect_label.append(fixed_debuff_effect_label1)
	fixed_debuff_effect_label.append(fixed_debuff_effect_label2)
	pass

func init_fixed_debuff():#初始化fixeddebuff，将debuff的作用添加,因为是固定
	#所以在每轮开始时就锁了，效果直接就添加了
	if Playerdata.fixed_debuff_flag==false:
		#初始化fixeddebuff数组
		#默认添加雷1
		Playerdata.save_fixed_debuff.append(0)
		#将所有需要立刻产生效果的debuff产生效果，然后添加id到角色的debuff存储中
		for id in Playerdata.save_fixed_debuff:
			#print("cnm")
			immediately_debuff_action(id)
			if Playerdata.already_debuff.has(id):
				Playerdata.already_debuff[id]+=1
			else:
				Playerdata.already_debuff[id]=1
			
		Playerdata.fixed_debuff_flag=true
		Playerdata.save()
		pass

func show_fixed_debuff():#展示fixeddebuff的文字信息
	var i=0
	for id in Playerdata.save_fixed_debuff:
		fixed_debuff_equip_back_panel[i].visible = true
		fixed_debuffname_label[i].text = LoadSource.debuff_dic[id]["name"]
		fixed_debuff_type_label[i].text = LoadSource.debuff_dic[id]["category"]
		fixed_debuff_effect_label[i].text=LoadSource.debuff_dic[id]["description"]
		i=i+1
		pass
	pass

func init_random():#初始化randomdebuff的总封装
	init_random_ui()
	show_random_debuff()



func show_random_debuff():#展示randomdebuff的文字信息
	
	text_curse_point.text = str(Playerdata.curse_point_required_remain)#剩余诅咒点显示
	
	for i in range(get_actural_ran_deb_shop_cells_number()):
		random_debuff_equip_back_panel[i].debuff_id = Playerdata.random_debuff_shop_save[i]#将ui绑定对应debuffid
		#内容添加到ui上
		#random_debuff_equip_back_panel[i].visible = true
		random_debuffname_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["name"]
		random_debuff_type_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["category"]
		random_debuff_effect_label[i].text=LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["description"]
		random_debuff_pricebutton_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["curse_point"]
		pass
	pass


func print_child_tree(node: Node, indent: int = 0):#打印节点树结构
	print("  ".repeat(indent) + node.name)
	for child in node.get_children():
		print_child_tree(child, indent + 1)



func init_random_ui():#生成元件，初始化randomdebuff,ui的数组
	#若还没抽取，抽取
	if Playerdata.random_debuff_shop_out_flag == false:
		Playerdata.curse_point_required_remain = Playerdata.each_round_curse_points#剩余诅咒点初始化
		Playerdata.extra_ran_deb_shop_refresh_times = 0#刷新额外刷了多少次初始化
		Playerdata.random_debuff_shop_refresh_times = Playerdata.free_refresh#免费刷新次数初始化
		for i in range(get_actural_ran_deb_shop_cells_number()):  # 循环
			var suijishu = randi() % (LoadSource.debuff_dic.size())
			while suijishu ==1:
				suijishu = randi() % (LoadSource.debuff_dic.size())
			Playerdata.random_debuff_shop_save.append(suijishu)  # 生成 0~LoadSource.debuff_dic.size() 的随机整数并加入数组
			
		Playerdata.random_debuff_shop_out_flag = true
		Playerdata.save()
		pass
	#初始化商店数值

	random_debuff_shop_level.text = str(Playerdata.random_debuff_shop_level)
	if Playerdata.random_debuff_shop_refresh_times>0:
		refresh_price_label.text = '0'
	else:
		refresh_price_label.text = str(get_actural_ran_deb_shop_refresh_price())
	upgrade_price_label.text = str(Playerdata.random_debuff_shop_upgrade_price)
	
	#加入树
	for i in get_actural_ran_deb_shop_cells_number():
		var ran_de_back_panel = random_debuff_back_panel.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/RandomDebuffHBoxContainer").add_child(ran_de_back_panel)
		random_debuff_equip_back_panel.append(ran_de_back_panel)
		random_debuffname_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer/VBoxContainer/RandomDebuffnameLabel"))
		random_debuff_type_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer/VBoxContainer/RandomDebuffTypeLabel"))
		random_debuff_effect_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/RichTextLabel"))
		random_debuff_pricebutton_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer2/PriceButton"))
		ran_de_back_panel.debuff_choosed.connect(debuff_choosed)
		ran_de_back_panel.i = i#绑定控件与数组内对应位置
		#ran_de_back_panel.scale = Vector2(0.5,0.5)#缩放
	#随机debuff
	
	##随机debuff名字
	#random_debuffname_label.append(random_debuffname_label1)
	#random_debuffname_label.append(random_debuffname_label2)
	#
	##随机debuff种类
	#random_debuff_type_label.append(random_debuff_type_label1)
	#random_debuff_type_label.append(random_debuff_type_label2)
	#
	##随机debuff作用描述
	#random_debuff_effect_label.append(random_debuff_effect_label1)
	#random_debuff_effect_label.append(random_debuff_effect_label2)
	pass


func init_already():
	init_already_ui()
	show_already_debuff()
	pass

func init_already_ui():#生成元件，初始化alreadybuff,ui的数组
	#print(Playerdata.already_debuff.size())
	text_total_curse_point.text = str(Playerdata.total_curse_points)#总诅咒点显示
	for i in range(Playerdata.already_debuff.size()):
		var alr_de_back_panel = already_debuff_back_panel.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/AlreadydebuffHBoxContainer").add_child(alr_de_back_panel)
		already_debuff_equip_back_panel.append(alr_de_back_panel)
		already_debuffname_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyDebuffnameLabel"))
		already_debuff_type_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyDebuffTypeLabel"))
		already_debuff_effect_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/RichTextLabel"))
		already_debuff_cursepoint_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer2/CursePointNumberLabel"))
		already_debuff_cursenumber_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer2/CurseNumberLabel"))
		
func show_already_debuff():#展示alreadydebuff的文字信息
	var i = 0#计数
	for id in Playerdata.already_debuff:#内容添加到ui上
		already_debuff_equip_back_panel[i].visible = true
		already_debuffname_label[i].text = LoadSource.debuff_dic[id]["name"]
		already_debuff_type_label[i].text = LoadSource.debuff_dic[id]["category"]
		already_debuff_effect_label[i].text=LoadSource.debuff_dic[id]["description"]
		already_debuff_cursepoint_label[i].text = LoadSource.debuff_dic[id]["curse_point"]
		already_debuff_cursenumber_label[i].text = str(Playerdata.already_debuff[id])
		i = i+1
		pass
	pass

func empty_already_debuff_ui():#清空已有debuff的ui
	for ui in already_debuff_equip_back_panel:
		ui.queue_free()
	already_debuff_equip_back_panel.clear()
	already_debuffname_label.clear()
	already_debuff_type_label.clear()
	already_debuff_effect_label.clear()
	already_debuff_cursepoint_label.clear()
	already_debuff_cursenumber_label.clear()
	pass


func immediately_debuff_action(debuff_id:int):#立刻产生效果的debuff产生作用
	if debuff_id==0:
		Playerdata.mines_number+=1
		#print("Playerdata.mines_number=",Playerdata.mines_number)
	elif debuff_id==3:
		Playerdata.money-=20
		#if Playerdata.money<0:
			#Playerdata.money = 0
		money_label.text = str(Playerdata.money)
	elif debuff_id==4:
		Playerdata.HP-=1
		if Playerdata.HP<1:#如果生命值扣完，游戏失败
			lose()
	elif debuff_id==5:
		Playerdata.initial_rules_number -= 1
		if Playerdata.initial_rules_number<0:#至少为0
			Playerdata.initial_rules_number = 0
	else:
		return
	Playerdata.save()#最后保存信息
	#之后还需添加实时显示信息的变化

func lose():#在debuff选择界面挂掉，你真是个人才（大拇指）！
	var lose_con = lose_control.instantiate()#实例化场景资源
	add_child(lose_con)
	pass

func debuff_choosed(id,i):#debuff被选中
	#print(id)
	#扣除剩余诅咒点，增加总诅咒点，增加debuff记录，debuff作用，保存，更改ui
	#扣除剩余诅咒点
	Playerdata.curse_point_required_remain -= int(LoadSource.debuff_dic[id]["curse_point"])
	#增加总诅咒点
	Playerdata.total_curse_points += int(LoadSource.debuff_dic[id]["curse_point"])
	#print(Playerdata.total_curse_points)
	#增加debuff记录
	#print(id)
	if Playerdata.already_debuff.has(id):
		Playerdata.already_debuff[id]+=1
	else:
		Playerdata.already_debuff[id]=1
	
	#print(Playerdata.already_debuff)
	#debuff作用
	immediately_debuff_action(id)
	
	#保存
	Playerdata.save()
	
	#更改ui
	text_curse_point.text = str(Playerdata.curse_point_required_remain)#剩余诅咒点显示
	text_total_curse_point.text = str(Playerdata.total_curse_points)#总诅咒点显示
	empty_already_debuff_ui()#先清空之前的已选择debuffui
	#init_already()
	#以下是原init_already()
	
	
	text_total_curse_point.text = str(Playerdata.total_curse_points)#总诅咒点显示
	for i2 in range(Playerdata.already_debuff.size()):
		var alr_de_back_panel = already_debuff_back_panel.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/AlreadydebuffHBoxContainer").add_child(alr_de_back_panel)
		already_debuff_equip_back_panel.append(alr_de_back_panel)
		already_debuffname_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyDebuffnameLabel"))
		already_debuff_type_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyDebuffTypeLabel"))
		already_debuff_effect_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/RichTextLabel"))
		already_debuff_cursepoint_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer2/CursePointNumberLabel"))
		already_debuff_cursenumber_label.append(alr_de_back_panel.get_node("AlreadyDebuffVBoxContainer2/HBoxContainer2/CurseNumberLabel"))
		
	var i3 = 0#计数
	for id2 in Playerdata.already_debuff:#内容添加到ui上
		already_debuff_equip_back_panel[i3].visible = true
		already_debuffname_label[i3].text = LoadSource.debuff_dic[id2]["name"]
		already_debuff_type_label[i3].text = LoadSource.debuff_dic[id2]["category"]
		already_debuff_effect_label[i3].text=LoadSource.debuff_dic[id2]["description"]
		already_debuff_cursepoint_label[i3].text = LoadSource.debuff_dic[id2]["curse_point"]
		already_debuff_cursenumber_label[i3].text = str(Playerdata.already_debuff[id2])
		i3 = i3+1
		pass
	#init_already结束



func _on_next_button_pressed():#其实是回到商店的按钮事件
	#latest_save = load(SAVE_FILE_PATH)
	Playerdata.game_run_flag=2
	Playerdata.save()
	SceneChanger.change_scene("res://Main/shop_ui.tscn")#跳转到游戏界面
	pass # Replace with function body.




func _on_next_level_pressed():#下一关按钮
	if Playerdata.curse_point_required_remain>0:
		var tips = tips_control.instantiate()#实例化场景资源
		add_child(tips)
		return
	Playerdata.game_run_flag=0
	Playerdata.save()
	SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
	pass # Replace with function body.


func _on_refresh_button_pressed():#刷新按钮
	if Playerdata.money<get_actural_ran_deb_shop_refresh_price() and Playerdata.random_debuff_shop_refresh_times<1:#金钱不足且无免费次数
		var tips = tips_control.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "金钱不足"
		add_child(tips)
		return
	
	if Playerdata.random_debuff_shop_refresh_times>0:#有免费刷新次数
		Playerdata.random_debuff_shop_refresh_times-=1
	else :#如果有足够的金钱
		Playerdata.money -= get_actural_ran_deb_shop_refresh_price()
		Playerdata.extra_ran_deb_shop_refresh_times += 1
	
	#重新抽取
	Playerdata.random_debuff_shop_save.clear()
	for i in range(get_actural_ran_deb_shop_cells_number()): #循环
		var suijishu = randi() % (LoadSource.debuff_dic.size())
		while suijishu ==1:
			suijishu = randi() % (LoadSource.debuff_dic.size())
		Playerdata.random_debuff_shop_save.append(suijishu)  # 生成 0~LoadSource.debuff_dic.size() 的随机整数并加入数组
		
	
	money_label.text = str(Playerdata.money)#剩余金钱
	random_debuff_shop_free_refresh_label.text = str(Playerdata.random_debuff_shop_refresh_times)#剩余免费刷新次数
	#刷新商店数值
	random_debuff_shop_level.text = str(Playerdata.random_debuff_shop_level)
	if Playerdata.random_debuff_shop_refresh_times>0:
		refresh_price_label.text = '0'
	else:
		#print(Playerdata.extra_ran_deb_shop_refresh_times)
		refresh_price_label.text = str(get_actural_ran_deb_shop_refresh_price())
	upgrade_price_label.text = str(Playerdata.random_debuff_shop_upgrade_price)
	#text_curse_point.text = str(Playerdata.curse_point_required_remain)#剩余诅咒点显示
	
	for i in range(get_actural_ran_deb_shop_cells_number()):
		random_debuff_equip_back_panel[i].debuff_id = Playerdata.random_debuff_shop_save[i]#将ui绑定对应debuffid
		#内容添加到ui上
		random_debuff_equip_back_panel[i].visible = true#将隐藏的格子显示出来
		random_debuffname_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["name"]
		random_debuff_type_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["category"]
		random_debuff_effect_label[i].text=LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["description"]
		random_debuff_pricebutton_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["curse_point"]
		pass
	Playerdata.save()
	pass # Replace with function body.


func _on_up_gradation_button_pressed():#点击随机debuff商店升级
	
	if Playerdata.random_debuff_shop_level == 6:#等级已达最高
		var tips = tips_control.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "等级最高为6级！"
		add_child(tips)
		return
	
	
	if Playerdata.money >= get_actural_ran_deb_shop_upgrade_price():#有足够的钱
		#参数更新
		Playerdata.money -= get_actural_ran_deb_shop_upgrade_price()
		Playerdata.random_debuff_shop_level += 1
		#ui更新
		money_label.text = str(Playerdata.money)
		random_debuff_shop_level.text = str(Playerdata.random_debuff_shop_level)
		
		
		#增加ui数量
		var i = get_actural_ran_deb_shop_cells_number()-1
		var ran_de_back_panel = random_debuff_back_panel.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/RandomDebuffHBoxContainer").add_child(ran_de_back_panel)
		random_debuff_equip_back_panel.append(ran_de_back_panel)
		random_debuffname_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer/VBoxContainer/RandomDebuffnameLabel"))
		random_debuff_type_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer/VBoxContainer/RandomDebuffTypeLabel"))
		random_debuff_effect_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/RichTextLabel"))
		random_debuff_pricebutton_label.append(ran_de_back_panel.get_node("RandomDebuffVBoxContainer2/HBoxContainer2/PriceButton"))
		ran_de_back_panel.debuff_choosed.connect(debuff_choosed)
		ran_de_back_panel.i = i#绑定控件与数组内对应位置
		
		
		#增加一个新抽取的debuff进入数组
		var suijishu = randi() % (LoadSource.debuff_dic.size())
		while suijishu ==1:
			suijishu = randi() % (LoadSource.debuff_dic.size())
		Playerdata.random_debuff_shop_save.append(suijishu)  # 生成 0~LoadSource.debuff_dic.size() 的随机整数并加入数组
		
		
		random_debuff_equip_back_panel[i].debuff_id = Playerdata.random_debuff_shop_save[i]#将ui绑定对应debuffid
		#内容添加到ui上
		random_debuffname_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["name"]
		random_debuff_type_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["category"]
		random_debuff_effect_label[i].text=LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["description"]
		random_debuff_pricebutton_label[i].text = LoadSource.debuff_dic[Playerdata.random_debuff_shop_save[i]]["curse_point"]
		Playerdata.save()
		return
		
	else:#无足够的钱
		var tips = tips_control.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "金钱不足！"
		add_child(tips)
		return


	
func get_actural_ran_deb_shop_upgrade_price():#实际升级价格=random_debuff_shop_upgrade_price+20*（random_debuff_shop_level-1）
	actural_ran_deb_shop_upgrade_price = Playerdata.random_debuff_shop_upgrade_price+20*(Playerdata.random_debuff_shop_level-1)
	return actural_ran_deb_shop_upgrade_price
	pass


func get_actural_ran_deb_shop_cells_number():#实际格子数量=random_debuff_shop_cells_number+random_debuff_shop_cells_number
	actural_ran_deb_shop_cells_number = Playerdata.random_debuff_shop_cells_number+Playerdata.random_debuff_shop_level
	return actural_ran_deb_shop_cells_number
	pass
