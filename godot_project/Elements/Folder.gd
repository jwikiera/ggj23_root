extends Element

class_name Folder

#extends CollisionShape2D

var children: Array

var cell_amount_x
var cell_amount_y

var grid = []

var player_coords: Vector2 
var _cell_scene

func _ready():
	print("Folder scene loaded")
	Commands.connect("move", self, "_on_move_signal")
	cell_amount_x = 10
	cell_amount_y = 17
	player_coords = Vector2(int(cell_amount_x / 2), int(cell_amount_y / 2))
	Globals.current_folder = self
	add_child(Globals.console)
	add_child(Globals.player)
	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
	Globals.player.scale_to_grid()
	_cell_scene = load("res://Grid/Cell.tscn")
	init_grid()
	#print_grid_debug()

func draw_rect_at_index(folder: Folder, index: Vector2) -> void:
	var pos = GridUtils.get_physical_coords_of_grid_index(folder, index)
	draw_rect(
		Rect2(
			pos.x,
			pos.y,
			10,
			10	
		),
		Color(1, 0, 1)
	)

func _draw():
	draw_grid_lines()
	draw_rect_at_index(self, Vector2(0, 0))
	draw_rect_at_index(self, Vector2(5, 13))
	
	
#	var index = Vector2(int(Globals.grid_size_x / 2), int(Globals.grid_size_y / 2))
#	draw_rect(Rect2(Globals.get_grid_pos_x() + index.x * Globals.get_grid_x_cell_size(),
#		Globals.get_grid_pos_y() + index.y * Globals.get_grid_y_cell_size(), 5, 5), Color(1, 1, 1))

#func fill_grid(grid):

func _process(delta):
	update()


func init_grid():
	pass
#	for i in range(Globals.grid_size_y):
#		Globals.grid.append([])
#		for j in range(Globals.grid_size_x):
#			var cell = _cell_scene.instance()
#			add_child(cell)
#			Globals.grid[i].append(cell)
			
func print_grid_debug():
	for i in range(Globals.grid_size_y):
		for j in range(Globals.grid_size_x):
			print(Globals.grid[i][j])

func draw_grid_lines():
	var x_size: float = GridUtils.get_grid_x_cell_size(self)
	var y_size: float = GridUtils.get_grid_y_cell_size(self)
	
	var i: int = 0 # y	
	while i < cell_amount_y + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(self), GridUtils.get_grid_pos_y(self) + i * y_size),
			Vector2(GridUtils.get_grid_pos_x(self) + cell_amount_x * x_size, GridUtils.get_grid_pos_y(self) + i * y_size),
			Globals.COLORS['WHITE']
		)
		i += 1
		
	var j: int = 0 # x
	while j < cell_amount_x + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(self) + j * x_size, GridUtils.get_grid_pos_y(self)),
			Vector2(GridUtils.get_grid_pos_x(self) + j * x_size, GridUtils.get_grid_pos_y(self) + cell_amount_y * y_size),
			Globals.COLORS['WHITE']
		)
		j += 1


######################
# AJOUTS D'ELEMENTS  #
######################

func addChild(child):
	children.append(child)

func addPassword(_position:Vector2, _password_content, _protection_level=Element.Protection.JAUNE, _password_access="",  _is_zipped=false):
		var child = PasswordFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.PASSWORD,
						_protection_level,
						_password_access,
						_is_zipped)
		child.password_content=_password_content
		children.append(child)
	
func addCheckpointFile(_position:Vector2, _protection_level=Element.Protection.JAUNE, _password="", _is_zipped=false):
		var child = CheckpointFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.CHECKPOINT_FILE,
						_protection_level,
						_password,
						_is_zipped)
		children.append(child)

func addCheckpointElement(_position:Vector2):
		var child = CheckpointElement.new()
			
		child.Initialize(self,
						_position,
						Element.Type.CHECKPOINT_ELEMENT)
		children.append(child)

func addPriviledge(_position:Vector2, _priviledge_level, _protection_level=Element.Protection.JAUNE, _password="", _is_zipped=false):
		var child = PriviledgeFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.PRIVILEDGE,
						_protection_level,
						_password,
						_is_zipped)
		child.priviledge_level = _priviledge_level
		children.append(child)

######################
# ACCESSEURS BASIQUE #
######################

func print():
	print(name_element)
	for i in range(children.size()):
		children[i].print()


func getElement(pos : Vector2)->Element:
	for i in range(children.size()):
		if children[i].position==pos:
			return children[i]
	
	if parent.position==pos:
		return parent
	
	return null


func lastChildren()->Element:
	if children.size()>0:
		return children[children.size()-1]
	return null


func _on_move_signal(direction: int) -> void:
	if direction == Commands.DIRS.DIR_UP:
		if player_coords.y == 0:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			player_coords.y -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
			Globals.player.scale_to_grid()
	if direction == Commands.DIRS.DIR_DOWN:
		if player_coords.y == cell_amount_y - 1:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			player_coords.y += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
			Globals.player.scale_to_grid()
	if direction == Commands.DIRS.DIR_LEFT:
		if player_coords.x == 0:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			player_coords.x -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
			Globals.player.scale_to_grid()
	if direction == Commands.DIRS.DIR_RIGHT:
		if player_coords.x == cell_amount_x - 1:
			Globals.console.send_log("RED:Error! Position out of bounds.")
		else:
			player_coords.x += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
			Globals.player.scale_to_grid()
		
#	if direction == Commands.DIRS.DIR_UP:
#		velocity.y = -64
#	if direction == Commands.DIRS.DIR_DOWN:
#		velocity.y = 64
#	if direction == Commands.DIRS.DIR_LEFT:
#		velocity.x = -64
#	if direction == Commands.DIRS.DIR_RIGHT:
#		velocity.x = 64
#	move_and_collide(velocity)
#	velocity = Vector2.ZERO
