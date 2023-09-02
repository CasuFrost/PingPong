extends Node2D
onready var scia = get_parent().get_node("SciaPalla")
onready var cloudyExp = get_parent().get_node("CloudyExplosion")
onready var enemy = get_parent().get_node("Gerry")
onready var adMob = get_parent().get_node("AdMob")
var s=0
var r=0
var points = 0
var paolo = 5
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 11
var is_on_hit_area
var is_on_player_area_left
var is_on_player_area_right
var is_hittable
var is_hittable_left
var is_hittable_right
var maxSciaLen=20
var ogDir=0
var dirChanged = 0
var newDir=0
var ogSpeed = 11
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize() # Replace with function body.
	reset_ball()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	get_parent().get_node("Points").text=str(points)
	$sparkles.emitting=speed>0
	if not get_parent().pause:
	#print(speed)
		if $bounce.visible==true and speed>0:
			ogDir=r
			if r>-7 or r<7:
				dirChanged=rng.randf_range(-2, 2)
			else:
				dirChanged=0
			newDir = ogDir+dirChanged
			r=newDir
			#ad R aggiungo dir changed
		if $bounce.visible==true and speed<0:
			speed=global_position.direction_to(Vector2(540,380)).normalized().y*14
			r=global_position.direction_to(Vector2(540,380)).normalized().x*14
		if len(scia.points)>maxSciaLen:
				scia.remove_point(0)
		if abs(speed)>19:
			maxSciaLen=35
#			$Particles2D.emitting=true
		else:
			maxSciaLen=20
#			$Particles2D.emitting=false
		is_hittable_left=is_on_hit_area and is_on_player_area_left
		is_hittable_right=is_on_hit_area and is_on_player_area_right
		is_hittable = is_hittable_left or is_hittable_right
		
		#ss=(position.y/-2.198)
		s=(position.y/9000.114)
		#s=clamp(s,0.33,90)
		$BallNew.scale.y=s
		$BallNew.scale.x=s
	
#	pass
func _physics_process(delta):
	
	
	if not get_parent().pause:
	#print(speed)
		position.y+=speed
		position.x+=r
		if position.y>1400: #Player loose
			#adMob.show_banner()
			enemy.get_node("laugh").play()
			enemy.get_node("flaoting").play("float and laugh")
			enemy.play("Laugh")
			get_parent().get_node("LoseMenù").visible=true
			enemy.z_index=1
			visible=false
			get_parent().pause=true
			get_parent().get_node("LoseMenù/ColorRect/Label").text=get_lose_text(points)
			get_parent().get_node("LoseMenù/ColorRect/score").text="score : "+str(points)
			#print("you loose")
#			cloudyExp.global_position=global_position
#			cloudyExp.emitting=true
#			if points>get_parent().record:
#				get_parent().record=points
#				save_points(points)
#			points = 0
#			speed=11
#			ogSpeed = 11
			
		if position.y<379: 
			scia.clear_points()
			get_parent().get_node("player/hit").pitch_scale=rng.randf_range(0.7, 1.3)
			get_parent().get_node("player/hit").play()
			speed=ogSpeed
			
		if speed>0:
			$Ball.material.set_shader_param("glow",true)
			scia.add_point(position)
		else:
			$Ball.material.set_shader_param("glow",false)
			scia.remove_point(0)
			scia.remove_point(0)
			
		if position.y>1400 or position.y<379:
			if position.y<379:
				if rng.randi_range(0, 1)==0:
					get_parent().get_node("Gerry").play("Rebound")
				else:
					get_parent().get_node("Gerry").play("ReboundRev")
			scia.clear_points()
			global_position.y=380
			global_position.x=540
			
			r= rng.randi_range(-7, 7)
			
	get_parent().get_node("Bounce").scale=scale
	get_parent().get_node("Bounce").visible=$bounce.visible
	if get_parent().get_node("Bounce").visible:
		get_parent().get_node("Bounce").position=position
	

func _on_ball_area_entered(area):
	if area.is_in_group("rimbNe") and speed>=0:
		$BallOnTable.pitch_scale=rng.randf_range(0.7, 1.3)
		#get_parent().get_node("Bounce").position=position
		$Ball/AnimationPlayer.play("rimb")
	if area.is_in_group("rimb") and speed<0:
		$BallOnTable.pitch_scale=rng.randf_range(0.7, 1.3)
		#get_parent().get_node("Bounce").position=position
		$Ball/AnimationPlayer.play("rimb")

	if area.is_in_group("hitarea"):
		is_on_hit_area=true
	if area.is_in_group("PlyaerR"):
		is_on_player_area_right=true
	if area.is_in_group("PlyaerL"):
		is_on_player_area_left=true


func _on_ball_area_exited(area):
	if area.is_in_group("hitarea"):
		is_on_hit_area=false
	if area.is_in_group("PlyaerR"):
		is_on_player_area_right=false
	if area.is_in_group("PlyaerL"):
		is_on_player_area_left=false
		
func save_points(points):
	var game_save = GameSave.new()
	game_save.Points=str(get_parent().record)
	ResourceSaver.save(get_parent().dir,game_save)
	get_parent().get_node("Record").text="record : "+str(get_parent().record)


func _on_Restart_Button_button_down():
	#adMob.hide_banner()
	enemy.get_node("flaoting").play("float")
	enemy.play("idle")
	enemy.z_index=0
	visible=true
	get_parent().pause=false
	get_parent().get_node("LoseMenù").visible=false
	cloudyExp.global_position=global_position
	cloudyExp.emitting=true
	if points>get_parent().record:
		get_parent().record=points
		save_points(points)
	reset_ball()
	
	
func reset_ball():
	points = 0
	speed=11
	ogSpeed = 11
func get_lose_text(p):
	if p>=100:
		return "you are strong."
	var randomNumber = rng.randi_range(0, 6)
	var dict = {
		0:"Oops! You lost!",
		1:"You're weak...",
		2:"Next time",
		3:"Try again!",
		4:"ahaha noob",
		5:"try other sports.",
		6:"ridiculous"
	
	}
	return dict[randomNumber]
