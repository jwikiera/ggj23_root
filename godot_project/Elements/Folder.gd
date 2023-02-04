extends Element

class_name Folder

#extends CollisionShape2D

var children: Array

var cell_amount_x
var cell_amount_y

var grid = []


var _cell_scene

func _ready():
	print("Folder scene loaded")
	add_child(Globals.console)
	_cell_scene = load("res://Grid/Cell.tscn")
	cell_amount_x = 10
	cell_amount_y = 5
	init_grid()
	#print_grid_debug()
	
func _draw():
	draw_grid_lines()
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
