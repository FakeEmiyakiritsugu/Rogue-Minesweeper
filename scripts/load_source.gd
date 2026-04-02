extends Node

#预加载
const DEBUFF_01 = preload("res://picture/debuff01.png")
#路径
const DEBUFF_SAVE_PATH = "res://data/DebuffList.csv"
const BUFF_SAVE_PATH = "res://data/BuffList.csv"

#debuff数据，字典形式存储
var debuff_dic:Array[Dictionary]
#buff数据，字典形式存储
var buff_dic:Array[Dictionary]
# Called when the node enters the scene tree for the first time.
func _ready():
	#load_debuff_csv(DEBUFF_SAVE_PATH)
	#load_debuff_csv(BUFF_SAVE_PATH)
	load_csv(DEBUFF_SAVE_PATH,debuff_dic)
	load_csv(BUFF_SAVE_PATH,buff_dic)
	

func load_csv(csv_path:String,out_array:Array):#加载csv文件
	#csv文件
	var csv_file
	#首行信息
	var title_Array:PackedStringArray
	if FileAccess.file_exists(csv_path):
		csv_file = FileAccess.open(csv_path,FileAccess.READ)
		#获取首行信息
		title_Array = csv_file.get_csv_line(",")
		while csv_file.get_position() < csv_file.get_length():#读取每行的信息
			var csv_first:PackedStringArray = csv_file.get_csv_line()
			var temporary_csv_dic:Dictionary
			for title in title_Array.size():#循环将当前行的信息存到对应字典位置
				if title==0:#id化为数字形式
					temporary_csv_dic[title_Array[title]] = csv_first[title].to_int()
				else :
					temporary_csv_dic[title_Array[title]] = csv_first[title]
			
			out_array.append(temporary_csv_dic)



#func load_debuff_csv(csv_path:String):#加载csv文件
	##csv文件
	#var csv_file
	##首行信息
	#var debuff_title:PackedStringArray
	#if FileAccess.file_exists(csv_path):
		#csv_file = FileAccess.open(csv_path,FileAccess.READ)
		##获取首行信息
		#debuff_title = csv_file.get_csv_line(",")
		#while csv_file.get_position() < csv_file.get_length():#读取每行的信息
			#var csv_debuff:PackedStringArray = csv_file.get_csv_line()
			#var temporary_debuff_dic:Dictionary
			#for title in debuff_title.size():#循环将当前行的信息存到对应字典位置
				#if title==0:#id化为数字形式
					#temporary_debuff_dic[debuff_title[title]] = csv_debuff[title].to_int()
				#else :
					#temporary_debuff_dic[debuff_title[title]] = csv_debuff[title]
			#
			#debuff_dic.append(temporary_debuff_dic)
			#
##不知道为什么读不了中文？？？？？？？？？？已解决，是编码的问题
			#
#func load_buff_csv(csv_path:String):#加载csv文件
	##csv文件
	#var csv_file
	##首行信息
	#var buff_title:PackedStringArray
	#if FileAccess.file_exists(csv_path):
		#csv_file = FileAccess.open(csv_path,FileAccess.READ)
		##获取首行信息
		#buff_title = csv_file.get_csv_line(",")
		#while csv_file.get_position() < csv_file.get_length():#读取每行的信息
			#var csv_buff:PackedStringArray = csv_file.get_csv_line()
			#var temporary_buff_dic:Dictionary
			#for title in buff_title.size():#循环将当前行的信息存到对应字典位置
				#if title==0:#id化为数字形式
					#temporary_buff_dic[buff_title[title]] = csv_buff[title].to_int()
				#else :
					#temporary_buff_dic[buff_title[title]] = csv_buff[title]
			#
			#debuff_dic.append(temporary_debuff_dic)



