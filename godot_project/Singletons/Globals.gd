extends Node2D


var console
var player
var player_coords: Vector2 
var root: Folder # représente l'entièreté de la map
var current_folder: Folder
var timer_principal:float = 60 # en seconde
var intro_music

var _console_width: float = 30 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont
var console_font_size = 30
var invite_text = '  ~> '
var seed_ = 42
var has_greeted = false
var game_has_started = false

var _grid_margin = 12

var passwords_dictionnary


var COLORS = {
	"RED": Color('#D45769'),
	"GREEN": Color(0, 1, 0),
	"YELLOW": Color('#E69D45'),
	"CYAN": Color('#308695'),
	"WHITE": Color('#D4CFC9')
}


var _commands = {
	'boot':  {
		'enabled':true,
		'full_name':"boot"
		},
	'engage': {
		'enabled':false,
		'full_name':"engage"
		},
	'move': {
		'enabled':false,
		'full_name':"move <direction>"
		},
	'cd': {
		'enabled':false,
		'full_name':"cd <optional_password>"
		},
	'download': {
		'enabled':false,
		'full_name':"download <optional_password>"
		},
	'passwords':{
		'enabled':false,
		'full_name':"passwords"
		},
	'unzip':{
		'enabled':false,
		'full_name':"unzip"
		},
	'checkpoint': {
		'enabled':false,
		'full_name':"checkpoint"
		},
	'pause':{
		'enabled':false,
		'full_name':"pause"
		},
	'play':{
		'enabled':false,
		'full_name':"play"
		},
	'exit': {
		'enabled':true,
		'full_name':"exit"
		},
}

func get_commands():
	return _commands.keys()

func enable_command(command: String) -> void:
	_commands[command]['enabled'] = true
	
func disable_command(command: String) -> void:
	_commands[command]['enabled']  = false
	
func com_enabled(command: String) -> bool:
	return _commands[command]['enabled'] 


func _ready():
	print("Globals ready")
	seed(seed_)
	console_font = DynamicFont.new()
	console_font.font_data = load("res://Fonts/digital-7.ttf") #load("res://Fonts/Calculator.ttf")
	console_font.size = console_font_size
	console = load("res://Scenes/Console.tscn").instance()
	player = load("res://Player/Player.tscn").instance()
	intro_music = load("res://Scenes/intro_music.tscn").instance()
	#print(console_font.size)
	root = load("res://Elements/Folder.tscn").instance()
	root.Initialize(null, Vector2(0,0), Element.Type.FOLDER, Element.Protection.ROUGE, "password4")
	root.name="root"
	generate_sous_dossier(root)
	generate_passwords_dictionnary()
	#current_folder.initialize_scene()
	
	#current_folder.initialize_scene(self)
	#root.print()

func _process(delta):
	timer_principal -= delta
	
	if timer_principal<=0:
		game_over()
	
	if current_folder==root:
		victory()



func game_over():
	pass
	
func victory():
	pass
	
func get_console_width() -> float:
	return get_viewport().size.x / 100 * Globals._console_width
	
func get_x_grid_margin():
	return (get_viewport().size.x - get_console_width()) / 100 * _grid_margin
	
func get_y_grid_margin():
	return get_viewport().size.y / 100 * _grid_margin
	
###########################
# CREATION DE LA MAP
###########################

func get_position_randomly(folder) -> Vector2:
	#retourne aléatoirement une position vide de la grille
	var espace_libre=false
	var pos:Vector2
	
	while !espace_libre:
		pos = Vector2(randi() % folder.cell_amount_x, randi() % folder.cell_amount_y)
		var element = folder.getElement(pos)
		if element==null:
			espace_libre=true
	
	return pos;


func addFolder(dossier,pos:Vector2, protection=Element.Protection.JAUNE, password="", is_zipped=false):
	var child = load("res://Elements/Folder.tscn").instance()
	
	dossier.addChild(child) # ajouter folder dans la logique de la map
	child.Initialize(	dossier,
						pos,
						Element.Type.FOLDER,
						protection,
						password,
						is_zipped)
	child.position_grid = get_position_randomly(dossier)
	child.position_grid_parent = get_position_randomly(dossier)

func generate_sous_dossier(dossier, level:int=8):
	if level==8:
		# DOSSIER 1 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE, "password5")
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==7:
		# DOSSIER 1 (Password)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE, "password6", true)
		dossier.lastChildren().addPassword(Vector2(0,0),"password4")
		
		# DOSSIER 2 (Password)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
		dossier.lastChildren().addPassword(Vector2(0,0),"password6")
		
		# DOSSIER 3 (Vide)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
											
		# DOSSIER 4 (Vide)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
											
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE, "password3")
		generate_sous_dossier(dossier.lastChildren(), level-1)
	
	elif level==6:
		# DOSSIER 1 (TUTO ALIAS)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		#dossier.lastChildren().addTuto(<Alias>)
		
		# DOSSIER 2 (TUTO LOOP)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE, "password2", true)
		#dossier.lastChildren().addTuto(<Loop>)
		
		# DOSSIER 3 (CHECKPOINT)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE, "", true)
		dossier.lastChildren().addCheckpointFile(Vector2(0,0))
		
		# DOSSIER 4 (Mot de passe)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE, "", true)
		dossier.lastChildren().addPassword(Vector2(0,0),"password5")
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		generate_sous_dossier(dossier.lastChildren(), level-1)
	
	elif level==5:
		# DOSSIER 1 (TUTO CHECKPOINT)
		addFolder(dossier, Vector2(0,0))
		#dossier.lastChildren().addTuto(Vector2(0,0), 'checkpoint', "")
		
		# DOSSIER 2 (Vide )
		addFolder(dossier, Vector2(0,0))
		
		# DOSSIER 3 (Privilège rouge)
		addFolder(dossier, Vector2(0,0))
		dossier.lastChildren().addPriviledge(Vector2(0,0), Element.Protection.ROUGE, Element.Protection.ORANGE)
		
		# DOSSIER 4 (Mot de passe)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addPassword(Vector2(0,0), "password3", Element.Protection.ORANGE)
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "password1")
		#dossier.lastChildren().addTuto(Vector2(0,0), 'unzip', "")
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==4:
		# DOSSIER 1 (Privilège orange)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "", true)
		dossier.lastChildren().addPriviledge(Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addTuto(Vector2(0,0), '', "You can access\nmore folders with\nhigher privileges")
		
		# DOSSIER 2 (Mot de passe)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addPassword(Vector2(0,0), "password2")
		
		# DOSSIER 3 (Tuto Remove)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		#dossier.lastChildren().addTuto(<Remove>)
		
		# DOSSIER 4 (Tuto back)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "", true)
		dossier.lastChildren().addTuto(Vector2(0,0), '', "Go through commands\nhistory with\n'KEY_UP' and 'KEY_DOWN'")
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0))
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==3:
		# DOSSIER 1 (Password)
		addFolder(dossier, Vector2(0,0))
		dossier.lastChildren().addPassword(Vector2(0,0), "password1" )
		dossier.lastChildren().addTuto(Vector2(0,0), 'passwords', "")
		
		# DOSSIER 2 (Tuto Tab)
		addFolder(dossier, Vector2(0,0))
		#dossier.lastChildren().addTuto(<Tab>)
		
		# DOSSIER 3 (Tuto Download)
		#addFolder(dossier, Vector2(0,0))
		#dossier.lastChildren().addTuto(<Downloadk>)
		
		
		# DOSSIER 4 (Suite du chemin)
		addFolder(dossier, Vector2(3,2))
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==2:
		# DOSSIER 1 (Vide)
		addFolder(dossier, Vector2(0,0))
		
		# DOSSIER 4 (Suite du chemin)
		addFolder(dossier, Vector2(1,1))
		current_folder=dossier.lastChildren()
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==1:
		pass
		# définir position départ du joueur
		#joueur.current_folder = dossier
		#joueur.position = Vecteur(0,0)
		
func get_nb_visited_folders()->int:
	return root.get_nb_visited_folders();

func print_timer()->String:
	var secondes = int(timer_principal) % 60
	var minutes = (int(timer_principal) - secondes)/60
	
	var secondes_txt = str(secondes)
	if secondes<10:
		secondes_txt = "0"+str(secondes)
	
	var minutes_txt = str(minutes)
	if minutes<10:
		minutes_txt = "0"+str(minutes)
		
	return minutes_txt+":"+secondes_txt
	
func generate_passwords_dictionnary():
	passwords_dictionnary = {}
	for i in range(10):
		passwords_dictionnary["password"+str(i)]= generate_random_password()

func generate_random_password()->String:
	var pw =""
	var alphabet = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
	for i in range(5):
		var n = randi() % 25
		pw += alphabet[n]
	return pw.to_upper()
