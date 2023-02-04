extends Node2D


var console
var player
var player_coords: Vector2 
var root:Folder # représente l'entièreté de la map
var current_folder: Folder
var timer_principal:float = 60 # en seconde

var _console_width: float = 20 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont
var console_font_size = 30
var invite_text = '  ~> '
var seed_ = 'ibib3fi3b'

#var grid = []
#var grid_size_x = 30
#var grid_size_y = 11
var _grid_margin = 10


var COLORS = {
	"RED": Color(1, 0, 0),
	"GREEN": Color(0, 1, 0),
	"YELLOW": Color(1, 1, 0),
	"WHITE": Color(1, 1, 1)
}


func _ready():
	print("Globals ready")
	console_font = DynamicFont.new()
	console_font.font_data = load("res://Fonts/digital-7.ttf") #load("res://Fonts/Calculator.ttf")
	console_font.size = console_font_size
	console = load("res://Scenes/Console.tscn").instance()
	player = load("res://Player/Player.tscn").instance()
	#print(console_font.size)
	root = load("res://Elements/Folder.tscn").instance()
	root.Initialize(null, Vector2(0,0), Element.Type.FOLDER, Element.Protection.ROUGE, "password1")
	root.name="root"
	generate_sous_dossier(root)
	#current_folder.initialize_scene()
	
	#current_folder.initialize_scene(self)
	#root.print()

func _process(delta):
	timer_principal -= delta
	print(Globals.print_timer())
	
	if timer_principal<=0:
		game_over()



func game_over():
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

func set_position_randomly(folder) -> Vector2:
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
	child.position_grid = set_position_randomly(dossier)
	child.position_grid_parent = set_position_randomly(dossier)

func generate_sous_dossier(dossier, level:int=7):
	if level==7:
		# DOSSIER 1 (Password)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE, "password2")
		dossier.lastChildren().addPassword(Vector2(0,0),"password1")
		
		# DOSSIER 2 (Password)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
		dossier.lastChildren().addPassword(Vector2(0,0),"password2")
		
		# DOSSIER 3 (Vide)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
											
		# DOSSIER 4 (Vide)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE)
											
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ROUGE, "password4")
		generate_sous_dossier(dossier.lastChildren(), level-1)
	
	elif level==6:
		# DOSSIER 1 (TUTO ALIAS)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		#dossier.lastChildren().addTuto(<Alias>)
		
		# DOSSIER 2 (TUTO LOOP)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE, "password3")
		#dossier.lastChildren().addTuto(<Loop>)
		
		# DOSSIER 3 (CHECKPOINT)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addCheckpointFile(Vector2(0,0))
		
		# DOSSIER 4 (Vide)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		generate_sous_dossier(dossier.lastChildren(), level-1)
	
	elif level==5:
		# DOSSIER 1 (TUTO CHECKPOINT)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		#dossier.lastChildren().addTuto(<Checkpoint>)
		
		# DOSSIER 2 (Vide )
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		
		# DOSSIER 3 (Privilège rouge)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addPriviledge(Vector2(0,0), Element.Protection.ROUGE, Element.Protection.ORANGE)
		
		# DOSSIER 4 (Mot de passe)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		dossier.lastChildren().addPassword(Vector2(0,0), "password3", Element.Protection.ORANGE)
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.ORANGE)
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==4:
		# DOSSIER 1 (Privilège orange)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "", true)
		dossier.lastChildren().addPriviledge(Vector2(0,0), Element.Protection.ORANGE)
		
		# DOSSIER 2 (Mot de passe )
		addFolder(dossier, Vector2(0,0))
		dossier.lastChildren().addPassword(Vector2(0,0), "password4")
		
		# DOSSIER 3 (Tuto Remove)
		addFolder(dossier, Vector2(0,0))
		#dossier.lastChildren().addTuto(<Remove>)
		
		# DOSSIER 4 (Tuto back)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "", true)
		#dossier.lastChildren().addTuto(<Back>)
		
		# DOSSIER 5 (Suite du chemin)
		addFolder(dossier, Vector2(0,0), Element.Protection.JAUNE, "password5")
		generate_sous_dossier(dossier.lastChildren(), level-1)
		
	elif level==3:
		# DOSSIER 1 (Password)
		addFolder(dossier, Vector2(0,0))
		dossier.lastChildren().addPassword(Vector2(0,0), Element.Protection.JAUNE, "password5")
		#dossier.lastChildren().addTuto(<Password>)
		
		# DOSSIER 2 (Tuto Tab)
		addFolder(dossier, Vector2(0,0))
		#dossier.lastChildren().addTuto(<Tab>)
		
		# DOSSIER 3 (Tuto Download)
		addFolder(dossier, Vector2(0,0))
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
	
