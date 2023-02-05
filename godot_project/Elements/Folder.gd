extends Element

class_name Folder

#extends CollisionShape2D

var children: Array

var position_grid_parent :Vector2 #position dans la grille en tant que parent

var cell_amount_x =7
var cell_amount_y =5

var grid = []

var visited : bool

var _cell_scene

var texture_regular = load("res://Assets/Textures/cursor_pink.png")
var texture_locked = load("res://Assets/Textures/folder_locked.png")
var texture_unlocked = load("res://Assets/Textures/folder_unlocked.png")

func refresh():
	set_icon()

func set_icon():
	print("=======")
	print("set icon "+ password_access + " " + str(visited))
	
	if len(password_access) > 1 and !visited:
		get_node("Sprite").texture = texture_locked
	elif len(password_access)>1 and visited:
		get_node("Sprite").texture = texture_unlocked

func _ready():
	print("Folder scene loaded " + name_element)
#
#	cell_amount_x = 10
#	cell_amount_y = 17
#
#	Globals.current_folder = self
#	add_child(Globals.console)
#	add_child(Globals.player)
#	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(self, player_coords))
#	Globals.player.scale_to_grid()
	_cell_scene = load("res://Grid/Cell.tscn")
	init_grid()
	#print_grid_debug()

func _draw():
	pass
#	draw_grid_lines()
	
	
#	var index = Vector2(int(Globals.grid_size_x / 2), int(Globals.grid_size_y / 2))
#	draw_rect(Rect2(Globals.get_grid_pos_x() + index.x * Globals.get_grid_x_cell_size(),
#		Globals.get_grid_pos_y() + index.y * Globals.get_grid_y_cell_size(), 5, 5), Color(1, 1, 1))

#func fill_grid(grid):




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




func initialize_scene(node_source:Node2D):
	print("Initialise scene " + name_element)
	# place les parents et enfants dans la scène
	if parent!=null:
		node_source.add_child(parent)
		parent.set_position_in_grid(parent.position_grid_parent)
		parent.refresh()
	
	for i in range(children.size()):
		node_source.add_child(children[i])
		children[i].set_position_in_grid(children[i].position_grid)
		children[i].refresh()
	
	visited=true

func delete_scene(node_source:Node2D):
	
	if parent!=null:
		node_source.remove_child(parent)
	
	for i in range(children.size()):
		node_source.remove_child(children[i])


######################
# AJOUTS D'ELEMENTS  #
######################

func addChild(child):
	children.append(child)

func addPassword(_position:Vector2, _password_content, _protection_level=Element.Protection.JAUNE, _password_access="",  _is_zipped=false):
		
		var scene_folder = load("res://Elements/PasswordFile.tscn")
		var child = scene_folder.instance()
		#var child = PasswordFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.PASSWORD,
						_protection_level,
						_password_access,
						_is_zipped)
		child.password_content=_password_content
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)
	
func addCheckpointFile(_position:Vector2, _protection_level=Element.Protection.JAUNE, _password="", _is_zipped=false):

		var scene_folder = load("res://Elements/CheckpointElement.tscn")
		var child = scene_folder.instance()	
		#var child = CheckpointElement.new()
			
		child.Initialize(self,
						_position,
						Element.Type.CHECKPOINT_FILE,
						_protection_level,
						_password,
						_is_zipped)
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)

func addCheckpointElement(_position:Vector2):
	
		var scene_folder = load("res://Elements/CheckpointElement.tscn")
		var child = scene_folder.instance()	
		#var child = CheckpointElement.new()
			
		child.Initialize(self,
						_position,
						Element.Type.CHECKPOINT_ELEMENT)
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)

func addPriviledge(_position:Vector2, _priviledge_level, _protection_level=Element.Protection.JAUNE, _password="", _is_zipped=false):

		var scene_folder = load("res://Elements/PriviledgeFile.tscn")
		var child = scene_folder.instance()	
		#var child = PriviledgeFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.PRIVILEDGE,
						_protection_level,
						_password,
						_is_zipped)
		child.priviledge_level = _priviledge_level
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)

func addTuto(_position:Vector2, command:String, explanation:String, _protection_level=Element.Protection.JAUNE, _password="", _is_zipped=false):

		var scene_folder = load("res://Elements/TutoFile.tscn")
		var child = scene_folder.instance()	
		#var child = PriviledgeFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.TUTO,
						_protection_level,
						_password,
						_is_zipped)
		child.command = command
		child.explanation=explanation
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)

func addSablier(_position:Vector2):
		var scene_folder = load("res://Elements/Sablier.tscn")
		var child = scene_folder.instance()	
		#var child = PriviledgeFile.new()
			
		child.Initialize(self,
						_position,
						Element.Type.SABLIER)
		child.position_grid = Globals.get_position_randomly(self)
		children.append(child)


######################
# ACCESSEURS BASIQUE #
######################

func print():
	print(name_element)
	for i in range(children.size()):
		children[i].print()


func getElement(pos : Vector2)->Element:
	#print("Niveau : " + name_element)
	for i in range(children.size()):
		if children[i].position_grid==pos:
			return children[i]
	
	if parent!=null and parent.position_grid_parent==pos:
		return parent
	
	return null


func lastChildren()->Element:
	if children.size()>0:
		return children[children.size()-1]
	return null

# Compter le nombre de "salles" visitées
func get_nb_visited_folders()->int:
	var nb = 0;
	for i in range(children.size()):
		if children[i].type==Element.Type.FOLDER:
			nb += children[i].get_nb_visited_folders()
	if visited:
		nb+=1
	
	return nb

func get_nb_folders()->int:
	var nb = 0;
	for i in range(children.size()):
		if children[i].type==Element.Type.FOLDER:
			nb += children[i].get_nb_folders()
	nb+=1
	
	return nb

func get_depth()->int:
	if children.size()>0:
		return 1+lastChildren().get_depth()
	else:
		return 1
