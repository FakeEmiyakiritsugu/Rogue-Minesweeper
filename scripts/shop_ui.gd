extends CanvasLayer

#const SAVE_PATH = "user://save"#存储文件夹路径
#const SAVE_FILE_PATH = SAVE_PATH+"/save_data.tres"#存储文件的路径
#var latest_save:SaveData = null #记录上个存档

#通用ui
@onready var TIPS_CONTROL = preload("res://Main/tips_control.tscn")
@onready var lose_control = preload("res://Main/lose_control.tscn")#预加载死亡窗口



#相关参数
var actural_buff_shop_refresh_price#实际buff商店刷新价格
var actural_buff_shop_upgrade_price#实际buff商店升级价格
var actural_buff_shop_cells_number#实际buff商店格子数量



#储存对应ui组件的数组
#var fixed_debuff_equip_back_panel = []#固定debuff总
#var fixed_debuffname_label = []#固定debuff名字
#var fixed_debuff_type_label = []#固定debuff种类
#var fixed_debuff_effect_label = []#固定debuff效果描述


var total_buff_back_panel = []#buff总
var total_buff_name_label = []#buff名字
var total_buff_type_label = []#buff种类
var total_buff_effect_label = []#buff效果描述
var total_buff_pricebutton_label = []#buff价格按钮


var total_already_buff_back_panel = []#已有buff总
var total_already_buffname_label = []#已有buff名字
var total_already_buff_type_label = []#已有buff种类
var total_already_buff_effect_label = []#已有buff效果描述
var total_already_buff_number_label = []#已有buff数量



var total_playerdata_ui_container = []#人物属性总
var total_playerdata_ui_text_label = []#人物属性名字
var total_playerdata_ui_number_label = []#人物属性对应数量



#饰品商店
@onready var item_shop_level = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel3/ItemShopLevel
@onready var item_shop_refresh_price = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel5/ItemShopRefreshPrice
@onready var buff_upgrade_price_label = $PanelContainer/HBoxContainer/VBoxContainer/HBoxContainer2/Panel9/BuffUpgradePriceLabel
@onready var BUFF_BACK_PANEL = preload("res://Main/Small Components/buff_back_panel_1.tscn")


#已拥有饰品
@onready var ALREADY_BUFF_BACK_PANEL_1 = preload("res://Main/Small Components/already_buff_back_panel_1.tscn")

#人物属性ui
@onready var PLAYERDATA_UI_CONTAINER = preload("res://Main/Small Components/playerdata_ui_container.tscn")



#左侧ui
@onready var left_money_label = $PanelContainer4/VBoxContainer2/VBoxContainer/HBoxContainer/Panel2/MoneyLabel
@onready var left_buff_free_refresh_label = $PanelContainer4/VBoxContainer2/VBoxContainer/HBoxContainer2/Panel2/BuffFreeRefreshLabel
@onready var left_ui_container = $PanelContainer4/VBoxContainer2/VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	Playerdata.loadsave_data()
	init_playerdata()
	init_items_shop()
	init_already_buff()
	init_leftui()
	pass # Replace with function body.
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func init_items_shop():#初始化items_shop的总封装
	
	init_items_shop_ui()
	show_buff_shop()
	pass


func init_items_shop_ui():#生成元件，初始化randomdebuff,ui的数组,展示randomdebuff的文字信息
	#若还没抽取，抽取
	if Playerdata.buff_shop_out_flag == false:
		Playerdata.extra_buff_shop_refresh_times = 0#刷新额外刷了多少次初始化
		Playerdata.buff_shop_refresh_times = Playerdata.free_refresh#免费刷新次数初始化
		for i in range(get_actural_buff_shop_cells_number()):  # 循环
			var suijishu = randi() % (LoadSource.buff_dic.size())
			Playerdata.buff_shop_save.append(suijishu)  # 生成 0~LoadSource.buff_dic.size() 的随机整数并加入数组
		
		Playerdata.buff_shop_out_flag = true
		Playerdata.save()
		pass
	pass
	
	#初始化商店数值

	item_shop_level.text = str(Playerdata.buff_shop_level)
	
	if Playerdata.buff_shop_refresh_times > 0:
		item_shop_refresh_price.text = '0'
	else:
		item_shop_refresh_price.text = str(get_actural_buff_shop_refresh_price())
	buff_upgrade_price_label.text = str(Playerdata.buff_shop_upgrade_price)
	
	#加入树
	for i in get_actural_buff_shop_cells_number():
		var buff_back_panel = BUFF_BACK_PANEL.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/BuffHBoxContainer3").add_child(buff_back_panel)
		total_buff_back_panel.append(buff_back_panel)
		total_buff_name_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer/VBoxContainer/BuffnameLabel"))
		total_buff_type_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer/VBoxContainer/BuffTypeLabel"))
		total_buff_effect_label.append(buff_back_panel.get_node("BuffVBoxContainer2/RichTextLabel"))
		total_buff_pricebutton_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer2/PriceButton"))
		buff_back_panel.buff_choosed.connect(buff_choosed)#连接信号
		buff_back_panel.i = i#绑定控件与数组内对应位置
	
	
	#for i in range(get_actural_buff_shop_cells_number()):
		#total_buff_back_panel[i].buff_id = Playerdata.buff_shop_save[i]#将ui绑定对应debuffid
		##内容添加到ui上
		##random_debuff_equip_back_panel[i].visible = true
		#total_buff_name_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["name"]
		#total_buff_type_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["category"]
		#total_buff_effect_label[i].text=LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["description"]
		#total_buff_pricebutton_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["price"]
		#pass
	#pass

func show_buff_shop():#展示buff商店的文字信息
	for i in range(get_actural_buff_shop_cells_number()):
		total_buff_back_panel[i].buff_id = Playerdata.buff_shop_save[i]#将ui绑定对应debuffid
		#内容添加到ui上
		total_buff_back_panel[i].visible = true
		total_buff_name_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["name"]
		total_buff_type_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["category"]
		total_buff_effect_label[i].text=LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["description"]
		total_buff_pricebutton_label[i].text = str(Playerdata.get_buff_price(Playerdata.buff_shop_save[i]))
		pass
	pass


func buff_choosed(id,i):#buff被选中
	#扣除金钱，增加buff记录，buff作用，保存，更改ui
	
	#扣除金钱
	Playerdata.money -= Playerdata.get_buff_price(id)
	#增加buff记录
	if Playerdata.already_buff.has(id):
		Playerdata.already_buff[id]+=1
	else:
		Playerdata.already_buff[id]=1
	#buff作用
	immediately_buff_action(id)
	#保存
	Playerdata.save()
	#更改ui
	left_money_label.text = str(Playerdata.money)#金钱显示
	updata_already_buff_ui()#更新已选择buffui
	

func updata_already_buff_ui():#清空已有buff的ui,展示新的ui
	empty_already_buff_ui()#先清空之前的已选择buffui
	
	for i in range(Playerdata.already_buff.size()):#生成元件，初始化alreadybuff,ui的数组
		var alr_bu_back_panel = ALREADY_BUFF_BACK_PANEL_1.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/AlreadyItemsHBoxContainer").add_child(alr_bu_back_panel)
		total_already_buff_back_panel.append(alr_bu_back_panel)
		total_already_buffname_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyBuffnameLabel"))
		total_already_buff_type_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyBuffTypeLabel"))
		total_already_buff_effect_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/RichTextLabel"))
		total_already_buff_number_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer2/AlreadyNumberLabel"))

	show_already_buff()
	pass

func empty_already_buff_ui():#清空已有buff的ui
	for ui in total_already_buff_back_panel:
		ui.queue_free()
	total_already_buff_back_panel.clear()
	total_already_buffname_label.clear()
	total_already_buff_type_label.clear()
	total_already_buff_effect_label.clear()
	total_already_buff_number_label.clear()
	pass


func immediately_buff_action(buff_id:int):#立刻产生效果的buff产生作用
	if buff_id == 0:
		if Playerdata.mines_number > 1:
			Playerdata.mines_number -= 1
	elif buff_id == 1:
		Playerdata.max_hp -= max(floor(Playerdata.max_hp/10),1)
		if Playerdata.max_hp <= 0:
			lose()
		Playerdata.gain_experience += 0.2
	elif  buff_id == 2:
		Playerdata.life_regeneration -= 1
	elif buff_id == 3:
		Playerdata.bloodsucking_recovery += 1
		Playerdata.bloodsucking += 5
	elif buff_id == 4:
		Playerdata.HP -= 2
		if Playerdata.HP <= 0:
			lose()
		add_exp(6)
	elif buff_id == 5:
		Playerdata.max_hp += 1
		Playerdata.mines_number += 1
	elif buff_id == 7:
		Playerdata.armor += 1
		Playerdata.max_hp -= 2
		if Playerdata.max_hp <= 0:
			lose()
	elif buff_id == 8:
		pass
	elif buff_id == 9:
		Playerdata.mines_number += 3
		Playerdata.life_regeneration += 1
	elif buff_id == 10:
		Playerdata.max_mana += 2
	elif buff_id == 11:
		Playerdata.shop_price *= 0.8
		show_buff_shop()
	elif buff_id == 12:
		pass
	elif buff_id == 13:
		pass
	else:
		return
		pass
	
	
	Playerdata.save()#最后保存信息
	#之后还需添加实时显示信息的变化
	updata_playerdata_ui()

func add_exp(number:int):#增加经验值
	Playerdata.exp += number*Playerdata.gain_experience
	while Playerdata.exp >= Playerdata.get_exp_upgrade():
		Playerdata.exp -= Playerdata.get_exp_upgrade()
		Playerdata.level += 1

	pass

func lose():#在商店界面挂掉，你真是个人才（大拇指）！
	var lose_con = lose_control.instantiate()#实例化场景资源
	lose_con.get_node("CanvasLayer/Label").text = "在商店界面挂掉，你真是个人才（大拇指）！"
	add_child(lose_con)
	pass



func updata_playerdata_ui():#更新人物属性的ui
	show_playerdata()
	pass

func init_already_buff():#初始化已有buff
	init_already_buff_ui()
	show_already_buff()
	pass

func init_already_buff_ui():#生成元件，初始化alreadybuff,ui的数组
	for i in range(Playerdata.already_buff.size()):
		var alr_bu_back_panel = ALREADY_BUFF_BACK_PANEL_1.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/AlreadyItemsHBoxContainer").add_child(alr_bu_back_panel)
		total_already_buff_back_panel.append(alr_bu_back_panel)
		total_already_buffname_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyBuffnameLabel"))
		total_already_buff_type_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer/VBoxContainer/AlreadyBuffTypeLabel"))
		total_already_buff_effect_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/RichTextLabel"))
		total_already_buff_number_label.append(alr_bu_back_panel.get_node("AlreadyBuffVBoxContainer2/HBoxContainer2/AlreadyNumberLabel"))


func show_already_buff():#展示alreadybuff的文字信息
	var i = 0#计数
	for id in Playerdata.already_buff:#内容添加到ui上
		total_already_buff_back_panel[i].visible = true
		total_already_buffname_label[i].text = LoadSource.buff_dic[id]["name"]
		total_already_buff_type_label[i].text = LoadSource.buff_dic[id]["category"]
		total_already_buff_effect_label[i].text=LoadSource.buff_dic[id]["description"]
		total_already_buff_number_label[i].text = str(Playerdata.already_buff[id])
		i = i+1
		pass
	pass

func init_playerdata():#初始化人物属性
	init_playerdata_ui()
	show_playerdata()
	pass

func init_playerdata_ui():#初始化人物属性ui
	#实例化子节点，分配子节点组件入对应数组，
	for i in Playerdata.Player_values_fields.size():
		var Pla_data_ui_container = PLAYERDATA_UI_CONTAINER.instantiate()#实例化场景资源
		get_node("PanelContainer2/VBoxContainer/ScrollContainer/VBoxContainer").add_child(Pla_data_ui_container)
		total_playerdata_ui_container.append(Pla_data_ui_container)
		total_playerdata_ui_text_label.append(Pla_data_ui_container.get_node("HBoxContainer/TextLabel"))
		total_playerdata_ui_number_label.append(Pla_data_ui_container.get_node("HBoxContainer/NumberLabel"))
	pass

func show_playerdata():#展示人物属性
	#根据Player_values_fields分配数值和文字给对应节点
	for i in Playerdata.Player_values_fields.size():
		total_playerdata_ui_text_label[i].text = Playerdata.Player_values_text[i]+":"
		total_playerdata_ui_number_label[i].text = str(Playerdata.get(Playerdata.Player_values_fields[i]))
	pass


func init_leftui():#初始化左侧ui
	left_money_label.text = str(Playerdata.money)#剩余金钱
	left_buff_free_refresh_label.text = str(Playerdata.buff_shop_refresh_times)#剩余免费刷新次数
	pass


func get_actural_buff_shop_cells_number():#实际格子数量=buff_shop_base_cells_number+buff_shop_level
	actural_buff_shop_cells_number = Playerdata.buff_shop_base_cells_number+Playerdata.buff_shop_level
	return actural_buff_shop_cells_number
	pass


func get_actural_buff_shop_refresh_price():#实际刷新价格=基础刷新价格+5*额外刷新次数
	actural_buff_shop_refresh_price = Playerdata.buff_shop_base_refresh_price+5*Playerdata.extra_buff_shop_refresh_times
	return actural_buff_shop_refresh_price
		
		
func get_actural_buff_shop_upgrade_price():#实际升级价格=buff_shop_upgrade_price+20*（buff_shop_level-1）
	actural_buff_shop_upgrade_price = Playerdata.buff_shop_upgrade_price+20*(Playerdata.buff_shop_level-1)
	return actural_buff_shop_upgrade_price
	pass




func _on_next_button_pressed():#下一关被点击
	#latest_save = load(SAVE_FILE_PATH)
	Playerdata.game_run_flag=0
	Playerdata.save()
	#save函数不太对，需要大改，这样子很可能无法正常保存，要么改save函数，要么改成minesgrid中的保存形式yijiejue 
	SceneChanger.change_scene("res://Main/main.tscn")#跳转到游戏界面
	pass # Replace with function body.


func _on_choose_debuff_button_pressed():#选择关卡debuff被点击
	#latest_save = load(SAVE_FILE_PATH)
	#print(latest_save.game_run_flag)
	Playerdata.game_run_flag=3
	Playerdata.save()
	SceneChanger.change_scene("res://Main/choose_debuff_ui.tscn")#跳转到关卡debuff界面
	pass # Replace with function body.


func _on_buff_up_gradation_button_pressed():#饰品商店升级
	if Playerdata.buff_shop_level == 6:#等级已达最高
		var tips = TIPS_CONTROL.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "等级最高为6级！"
		add_child(tips)
		return
		
	if Playerdata.money >= get_actural_buff_shop_upgrade_price():#有足够的钱
		#参数更新
		Playerdata.money -= get_actural_buff_shop_upgrade_price()
		Playerdata.buff_shop_level += 1
		#ui更新
		left_money_label.text = str(Playerdata.money)
		item_shop_level.text = str(Playerdata.buff_shop_level)
		
		
		#增加ui数量
		var i = get_actural_buff_shop_cells_number()-1
		var buff_back_panel = BUFF_BACK_PANEL.instantiate()#实例化场景资源
		get_node("PanelContainer/HBoxContainer/VBoxContainer/BuffHBoxContainer3").add_child(buff_back_panel)
		total_buff_back_panel.append(buff_back_panel)
		total_buff_name_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer/VBoxContainer/BuffnameLabel"))
		total_buff_type_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer/VBoxContainer/BuffTypeLabel"))
		total_buff_effect_label.append(buff_back_panel.get_node("BuffVBoxContainer2/RichTextLabel"))
		total_buff_pricebutton_label.append(buff_back_panel.get_node("BuffVBoxContainer2/HBoxContainer2/PriceButton"))
		buff_back_panel.buff_choosed.connect(buff_choosed)#连接信号
		buff_back_panel.i = i#绑定控件与数组内对应位置
		
		
		#增加一个新抽取的debuff进入数组
		var suijishu = randi() % (LoadSource.buff_dic.size())
		Playerdata.buff_shop_save.append(suijishu)  # 生成 0~LoadSource.buff_dic.size() 的随机整数并加入数组
		
		
		total_buff_back_panel[i].buff_id = Playerdata.buff_shop_save[i]#将ui绑定对应debuffid
		#内容添加到ui上
		#random_debuff_equip_back_panel[i].visible = true
		total_buff_name_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["name"]
		total_buff_type_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["category"]
		total_buff_effect_label[i].text=LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["description"]
		total_buff_pricebutton_label[i].text = str(Playerdata.get_buff_price(Playerdata.buff_shop_save[i]))
		#total_buff_pricebutton_label[i].text = LoadSource.buff_dic[Playerdata.buff_shop_save[i]]["price"]
		
		
		Playerdata.save()
		return
		
	else:#无足够的钱
		var tips = TIPS_CONTROL.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "金钱不足！"
		add_child(tips)
		return
	
	




func _on_buff_refresh_button_pressed():#buff刷新按钮
	if Playerdata.money<get_actural_buff_shop_refresh_price() and Playerdata.buff_shop_refresh_times < 1:#金钱不足且无免费次数
		var tips = TIPS_CONTROL.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "金钱不足"
		add_child(tips)
		return
		
	if Playerdata.buff_shop_refresh_times>0:#有免费刷新次数
		Playerdata.buff_shop_refresh_times-=1
	else :#如果有足够的金钱
		Playerdata.money -= get_actural_buff_shop_refresh_price()
		Playerdata.extra_buff_shop_refresh_times += 1
		
	#重新抽取
	Playerdata.buff_shop_save.clear()
	for i in range(get_actural_buff_shop_cells_number()): #循环
		var suijishu = randi() % (LoadSource.buff_dic.size())
		Playerdata.buff_shop_save.append(suijishu)  # 生成 0~LoadSource.buff_dic.size() 的随机整数并加入数组
	
	
	left_money_label.text = str(Playerdata.money)#剩余金钱
	left_buff_free_refresh_label.text = str(Playerdata.buff_shop_refresh_times)#剩余免费刷新次数
	
	#刷新商店数值
	item_shop_level.text = str(Playerdata.buff_shop_level)
	if Playerdata.buff_shop_refresh_times>0:
		item_shop_refresh_price.text = '0'
	else:
		#print(Playerdata.extra_ran_deb_shop_refresh_times)
		item_shop_refresh_price.text = str(get_actural_buff_shop_refresh_price())
	#upgrade_price_label.text = str(Playerdata.random_debuff_shop_upgrade_price)
	
	
	
	
	
	
	show_buff_shop()
	Playerdata.save()
		
	pass # Replace with function body.


func _on_visiable_button_pressed():#左侧ui显示/关闭按钮
	left_ui_container.visible = !left_ui_container.visible
	pass # Replace with function body.
