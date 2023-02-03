extends KinematicBody2D

var velocity = Vector2.ZERO

func _ready():
	Commands.connect("move", self, "_on_move_signal")

func _physics_process(delta):
	pass
#	if Input.is_action_just_pressed("ui_right"):
#		velocity.x = 64
#	elif Input.is_action_just_pressed("ui_left"):
#		velocity.x = -64
#	elif Input.is_action_just_pressed("ui_up"):
#		velocity.y = -64
#	elif Input.is_action_just_pressed("ui_down"):
#		velocity.y = 64
#	else:
#		velocity.x = 0
#		velocity.y = 0
#
#	move_and_collide(velocity)


func _on_move_signal(direction: int) -> void:
	print("received signal!")
	if direction == Commands.DIRS.DIR_UP:
		velocity.y = -64
	if direction == Commands.DIRS.DIR_DOWN:
		velocity.y = 64
	if direction == Commands.DIRS.DIR_LEFT:
		velocity.x = -64
	if direction == Commands.DIRS.DIR_RIGHT:
		velocity.x = 64
	move_and_collide(velocity)
	velocity = Vector2.ZERO
