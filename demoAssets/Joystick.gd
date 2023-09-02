extends Area2D

onready var big_circle = $big
onready var small_circle = $big/small


onready var max_distance = $CollisionShape2D.shape.radius

var touched = false
#func _input(event):
#	if event is InputEventScreenDrag:
#		if event.position.y>1630:
#			if event.position.x>540:
#					print("move_l")
#			else:
#					print("move_r")
#	if event is InputEventScreenTouch:
#		if event.position.y<1630:
#			if event.position.x>540:
#				print("hit_r")
#			else:
#				print("hit_l")
#
#		var distance = event.position.distance_to(big_circle.global_position)
#		if not touched:
#			if distance<max_distance:
#				touched=true
#		else:
#			small_circle.position=Vector2(0,0)
#			touched=false
func _process(delta):
	
	if touched:
		small_circle.global_position=get_global_mouse_position()
		small_circle.position=big_circle.position+(small_circle.position-big_circle.position).clamped(max_distance+50)

	
