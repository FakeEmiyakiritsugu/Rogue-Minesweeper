extends CanvasLayer


@onready var animation_player:AnimationPlayer =$AnimationPlayer
 
#场景切换的渐变
# Called when the node enters the scene tree for the first time.
func _ready():
	self.hide()
	pass # Replace with function body.


func change_scene(path):#切换到path场景
	self.show()
	self.set_layer(999)
	animation_player.play("changer")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(path)
	animation_player.play_backwards("changer")
	await animation_player.animation_finished
	self.set_layer(-1)
	self.hide()
	pass
