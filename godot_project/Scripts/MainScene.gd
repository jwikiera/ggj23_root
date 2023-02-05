extends Node2D


var ecran_victory: Sprite
var ecran_game_over: Sprite
var label_timer: Label
var label_nb_salles: Label


func print_welcome():
	yield(get_tree().create_timer(3.0), "timeout")
	if not Globals.has_greeted:
		Globals.console.send_log("Welcome")
	yield(get_tree().create_timer(2.0), "timeout")
	if not Globals.has_greeted:
		Globals.console.send_log("CYAN:You are at your own 'help'")
		Globals.has_greeted = true


func _ready():
	print("MainScene ready��")
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	add_child(Globals.intro_music)
	add_child(Globals.console)
	print_welcome()
	Commands.connect("move", self, "_on_move_signal")
	Commands.connect("change_dir", self, "_on_change_dir_signal")
	Commands.connect("start_game", self, "_on_start_game_received")
	Commands.connect("restart", self, "_on_restart_received")
	Globals.connect("victory", self, "_on_victory_received")
	Globals.connect("game_over", self, "_on_game_over_received")
	
	ecran_victory=get_node("EcranVictory")
	ecran_game_over=get_node("EcranGameOver")
	label_timer=get_node("Timer")
	label_nb_salles=get_node("NbSalles")
	ecran_victory.hide()
	ecran_game_over.hide()
	label_timer.hide()
	label_nb_salles.hide()
		

func _process(delta):
	if Input.is_action_just_released("num_up"):
		if Globals.player_coords.y == 0:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.y -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if Input.is_action_just_released("num_down"):
		if Globals.player_coords.y == Globals.current_folder.cell_amount_y - 1:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.y += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if Input.is_action_just_released("num_left"):
		if Globals.player_coords.x == 0:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.x -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if Input.is_action_just_released("num_right"):
		if Globals.player_coords.x == Globals.current_folder.cell_amount_x - 1:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.x += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	
	update()
	label_timer.text = Globals.print_timer()
	label_nb_salles.text = str(Globals.get_nb_visited_folders()) + "/" + str(Globals.get_nb_folders())


func _on_victory_received():
	ecran_victory.show()


func _on_game_over_received():
	ecran_game_over.show()


###########################
# CHANGEMENT DE FOLDER
###########################

func _on_change_dir_signal(new_folder:Folder, is_parent:bool):
	#placer joueur au bon endroit (étape 1)
	if is_parent:
		Globals.player_coords = Globals.current_folder.position_grid
	else:
		Globals.player_coords = Globals.current_folder.position_grid_parent
		
	# retirer les anciens elements et placer les nouveaux
	Globals.current_folder.delete_scene(self)
	Globals.current_folder=new_folder
	remove_child(Globals.player)
	Globals.current_folder.initialize_scene(self)
	add_child(Globals.player)
	
	# retirer mot de passe
	Globals.current_folder.password_access=""
	
	print("POS : ")
	print(Globals.current_folder )
	#placer joueur au bon endroit (étape 2 et fin)
	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	#GridUtils.compensate_scale_pos(Globals.player.get_node("Sprite"), Globals.current_folder)
	#GridUtils.compensate_scale_pos(Globals.player.get_node("Sprite"), Globals.current_folder)
	
	print("Nombre de salle : " + str(Globals.get_nb_visited_folders()))


###########################
# MOVE
###########################

func _on_move_signal(direction: int) -> void:
	if direction == Commands.DIRS.DIR_UP:
		if Globals.player_coords.y == 0:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.y -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_DOWN:
		if Globals.player_coords.y == Globals.current_folder.cell_amount_y - 1:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.y += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_LEFT:
		if Globals.player_coords.x == 0:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.x -= 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	if direction == Commands.DIRS.DIR_RIGHT:
		if Globals.player_coords.x == Globals.current_folder.cell_amount_x - 1:
			Globals.console.send_error("Error! Position out of bounds.")
		else:
			Globals.player_coords.x += 1
			Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))


func _on_start_game_received():
	print('Received start')
	Globals.game_has_started = true
	
	#Globals.intro_music.playing = false
	Util.fade_out_audio(Globals.intro_music, 10)
	
	Globals.current_folder.initialize_scene(self)
	add_child(Globals.player)
	
	Globals.player_coords = Globals.get_position_randomly(Globals.current_folder)
	Globals.player.set_position(GridUtils.get_physical_coords_of_grid_index(Globals.current_folder, Globals.player_coords))
	GridUtils.scale_sprite_node(Globals.player.get_node("Sprite"), Globals.current_folder)
	GridUtils.compensate_scale_pos(Globals.player.get_node("Sprite"), Globals.current_folder)
	GridUtils.compensate_scale_pos(Globals.player.get_node("Sprite"), Globals.current_folder)
	label_timer.show()
	label_nb_salles.show()
	Globals.background_music.play()

func _on_restart_received():
	#remove_child(Globals.player)
	Globals.player.queue_free()
	print_welcome()
	ecran_victory.hide()
	ecran_game_over.hide()
	label_timer.hide()
	label_nb_salles.hide()

	Globals.current_folder.delete_scene(self)
	Globals.restart()


###########################
# DRAWING
###########################

func _draw():
	if Globals.game_has_started:
		draw_grid_lines()
	#draw_rect_at_index(Globals.current_folder, Vector2(0, 0))
	#draw_rect_at_index(Globals.current_folder, Vector2(5, 13))
	
	
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

	
func draw_grid_lines():
	var x_size: float = GridUtils.get_grid_x_cell_size(Globals.current_folder)
	var y_size: float = GridUtils.get_grid_y_cell_size(Globals.current_folder)
	
	var i: int = 0 # y	
	while i < Globals.current_folder.cell_amount_y + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder), GridUtils.get_grid_pos_y(Globals.current_folder) + i * y_size),
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + Globals.current_folder.cell_amount_x * x_size, GridUtils.get_grid_pos_y(Globals.current_folder) + i * y_size),
			Globals.COLORS['WHITE']
		)
		i += 1
		
	var j: int = 0 # x
	while j < Globals.current_folder.cell_amount_x + 1:
		draw_line(
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + j * x_size, GridUtils.get_grid_pos_y(Globals.current_folder)),
			Vector2(GridUtils.get_grid_pos_x(Globals.current_folder) + j * x_size, GridUtils.get_grid_pos_y(Globals.current_folder) + Globals.current_folder.cell_amount_y * y_size),
			Globals.COLORS['WHITE']
		)
		j += 1
		
