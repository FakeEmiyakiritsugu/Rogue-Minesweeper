extends Panel

@export var debuff_id = 1#记录这个ui是对应哪个debuff的
@export var i = 0 #这个ui在数组中的位置
signal debuff_choosed(id,i)#这个ui的debuff被选中了
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.





func _on_price_button_pressed():#按下按钮使得触发购买
	emit_signal("debuff_choosed",debuff_id,i)
	self.visible = false
	pass # Replace with function body.

