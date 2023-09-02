extends AnimatedSprite
onready var ball = get_parent().get_node("ballContainer")
onready var hitEffect = get_parent().get_node("hitBallEffect")
var rng = RandomNumberGenerator.new()
# Declare member variables here. Examples:
var speedEnc=0.2
var speed=0
var rPressed
var AnimHitting = false
var lPressed
var MovePressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(ball.paolo)
	rng.randomize() # Replace with function body.
func _input(event):
	if ball.points<40:
		speedEnc=0.2
	if ball.points>40 and ball.points<70:
		speedEnc=0.05
	if ball.points>70:
		speedEnc=0.025
	if event is InputEventScreenTouch:
		if event.position.y>1530:
			get_parent().get_node("Moving area").visible=false
			get_parent().get_node("Moving area/Timer").start()
			if event.is_pressed():
				MovePressed=true
			else:
				MovePressed=false
		else:
			speed=0
		if event.position.y<1530 and not get_parent().pause:
			if event.is_pressed():
				if event.position.x>540:
					if $Timer.time_left==0:
						$Timer.start()
						rPressed=true 
						AnimHitting=true
				else:
					if $Timer.time_left==0:
						$Timer.start()
						lPressed=true 
						AnimHitting=true
	
func _physics_process(delta):
	if not get_parent().pause:
		position.x+=speed
func _process(delta):
	if !AnimHitting:
		if MovePressed:
			if speed>0:
				$demoAsset.play("goRight")
			else :
				$demoAsset.play("goLeft")
		else:
			$demoAsset.play("d")
	if not get_parent().pause:
		position.x=clamp(position.x,132,948)
		if MovePressed:
			if get_global_mouse_position().x>540:
				speed=14
			else:
				speed=-14
		else:
			speed=0
		if lPressed:
			racket_swoosh()
			AnimHitting=true
			lPressed=false 
			$demoAsset.play("l2")
			if ball.is_hittable_left:
				particles_activate()
				ball.points+=1
				$hit.pitch_scale=rng.randf_range(0.7, 1.3)
				$hit.play()
				ball.speed+=0.2
				ball.ogSpeed+=0.2
				ball.speed=ball.speed*-1
				ball.r=ball.r*-1
				ball.speed=ball.global_position.direction_to(Vector2(x_calc_dir(false),660)).normalized().y*14
				ball.r=ball.global_position.direction_to(Vector2(x_calc_dir(false),660)).normalized().x*14
		if rPressed:
			racket_swoosh()
			AnimHitting=true
			rPressed=false 
			#play("R")
			$demoAsset.play("r2")
			if ball.is_hittable_right:
				particles_activate()
				ball.points+=1
				ball.ogSpeed+=0.2
				$hit.pitch_scale=rng.randf_range(0.7, 1.3)
				$hit.play()
				ball.speed+=0.2
				ball.speed=ball.speed*-1
				ball.r=ball.r*-1
				ball.speed=ball.global_position.direction_to(Vector2(x_calc_dir(true),660)).normalized().y*14
				ball.r=ball.global_position.direction_to(Vector2(x_calc_dir(true),660)).normalized().x*14
				
		if get_parent().get_node("Joystick/big/small").position.x!=0:
			position.x+=(get_parent().get_node("Joystick/big/small").position.x/abs(get_parent().get_node("Joystick/big/small").position.x))*14
		if Input.is_key_pressed(KEY_D):
			position.x+=14
			
		if Input.is_key_pressed(KEY_A):
			position.x-=14
			
func _on_player_animation_finished():
	pass


func _on_l_pressed():
	pass
	
func x_calc_dir(destra):
	var minn=450
	var maxx=630
	if global_position.x>540 :
		if destra:
			return rng.randi_range(minn, maxx)
		else:
			return rng.randi_range(minn, maxx)
	else:
		if not destra:
			return rng.randi_range(minn, maxx)
		else:
			return rng.randi_range(minn, maxx)

func _on_r_pressed():
	pass
	

func particles_activate():
	hitEffect.global_position=ball.global_position
	hitEffect.emitting=true
	hitEffect.get_node("Timer").start()
func _on_demoAsset_animation_finished():
	AnimHitting=false
func racket_swoosh():
	$RacketSwoosh.pitch_scale=rng.randf_range(0.7, 1.3)
	$RacketSwoosh.play()

func _on_Timer_timeout():
	hitEffect.emitting=false
