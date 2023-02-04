extends KinematicBody2D

var velocity: Vector2 = Vector2.ZERO
var sprite_node: Sprite

func _ready():
	print("Player ready")
	sprite_node = get_node("Sprite")
	#move_to_grid_center()
	#scale_self_to_grid()
	#print(Globals.get_index_from_physical_coords(Vector2(500, 500)))

func scale_to_grid():
	print("scaling player")
	var sprite_size: int = sprite_node.texture.get_width()
	var ratio: float = float(sprite_size) / GridUtils.get_grid_x_cell_size(Globals.current_folder)
	sprite_node.scale.x = 1 / ratio
	sprite_node.scale.y = 1 / ratio
	
	var last_pos: Vector2 = self.get_position()
	#print("ratio: %f" % ratio)
	last_pos.x -= (float(sprite_size) - GridUtils.get_grid_x_cell_size(Globals.current_folder)) / 2
	last_pos.y -= (float(sprite_size) - GridUtils.get_grid_x_cell_size(Globals.current_folder)) / 2
	self.set_position(last_pos)
	
func move_to_grid_center():
	#print("hello from player.gd")
	#print(Globals.get_physical_coords_of_grid_index(Vector2(int(Globals.grid_size_x / 2), int(Globals.grid_size_y / 2))))
	self.set_position(
		GridUtils.get_physical_coords_of_grid_index(
			Globals.current_folder,
			Vector2(
				int(Globals.current_folder.cell_amount_x / 2),
				int(Globals.current_folder.cell_amount_y / 2))
			)
		)

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

func get_self_center() -> Vector2:
	var sprite_size_x: int = sprite_node.texture.get_width()
	var sprite_size_y: int = sprite_node.texture.get_width()
	return Vector2(
		self.get_position().x + sprite_size_x * sprite_node.scale.x,
		self.get_position().y + sprite_size_y * sprite_node.scale.y
	)
