extends Panel


@onready var TIPS_CONTROL = preload("res://Main/tips_control.tscn")



@export var buff_id = 1#记录这个ui是对应哪个buff的
@export var i = 0 #这个ui在数组中的位置
signal buff_choosed(id,i)#这个ui的buff被选中了
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_price_button_pressed():#被购买
	if Playerdata.money<Playerdata.get_buff_price(buff_id):#金钱不足
		var tips = TIPS_CONTROL.instantiate()#实例化场景资源
		tips.get_node("CanvasLayer/Label").text = "金钱不足"
		add_child(tips)
		return
	emit_signal("buff_choosed",buff_id,i)
	self.visible = false
	pass # Replace with function body.
