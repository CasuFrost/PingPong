extends Node2D
var record = 0
var pause = false
var colorSkye : Color = Color(0.6,0.8,0.8,1)
var colorSkyeDark : Color = Color(0.2,0.2,0.3,1)
var colorSelector=1

var dir =str(OS.get_user_data_dir())+"/game_save.tres"
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("LoseMenù").visible=false
	$player/demoAsset.material.set_shader_param("color",Color(0.5,0.5,1))
	dir = str(OS.get_user_data_dir())+"/game_save.tres"
	var f = File.new()
	if !f.file_exists(dir):
		var game_save = GameSave.new()
		game_save.Points=str("0")
		ResourceSaver.save(dir,game_save)
		#var game_save = load(GameSave.SAVE_GAME_PATH) as GameSave
		#record=int(game_save.points)
	
	var game_save = load(dir) as GameSave
	record=int(game_save.Points)
	$Record.text="record : "+str(record)
	#$Record.text=str(OS.get_user_data_dir())+"/point.txt"
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Gerry/Light2D.visible=!pause
	if Input.is_action_just_pressed("ui_accept"):
		pause=!pause
	#print(pause)
#	pass


func _on_red_button_down():
	$player/demoAsset.material.set_shader_param("Active",true)
	$player/demoAsset.material.set_shader_param("color",Color(1,0,0))


func _on_blue_button_down():
	$player/demoAsset.material.set_shader_param("Active",true)
	$player/demoAsset.material.set_shader_param("color",Color(0.5,0.5,1))


func _on_greem_button_down():
	$player/demoAsset.material.set_shader_param("Active",true)
	$player/demoAsset.material.set_shader_param("color",Color(0,1,0))


func _on_greem2_button_down():
	$player/demoAsset.material.set_shader_param("Active",false)


func _on_backGroundColor_button_down():
	colorSelector=colorSelector*-1
	if colorSelector==1:
		$Sfondo.color=colorSkye
		$ColorButtons/backGroundColor.modulate=colorSkyeDark
	else:
		$Sfondo.color=colorSkyeDark
		$ColorButtons/backGroundColor.modulate=colorSkye


func _on_Timer_timeout():
	$"Moving area".visible=true


func _on_Gerry_animation_finished():
	if !$"LoseMenù".visible:
		$Gerry.play("idle")
