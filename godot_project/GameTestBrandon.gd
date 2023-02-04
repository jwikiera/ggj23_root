extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.scancode == KEY_T:
			var root = Folder.new()
			root.Initialize(null, Vector2(0,0), Element.Type.FOLDER, Element.Protection.ROUGE, "password1")
			generate(root)
			root.print()

func addFolder(dossier,pos:Vector2, protection=Element.Protection.JAUNE, password="", is_zipped=false):
	
	dossier.addChild(Folder.new())
	dossier.lastChildren().Initialize(	dossier,
										pos,
										Element.Type.FOLDER,
										protection,
										password,
										is_zipped)

func generate(dossier, level:int=7):
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
		generate(dossier.lastChildren(), level-1)
	
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
		generate(dossier.lastChildren(), level-1)
	
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
		generate(dossier.lastChildren(), level-1)
		
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
		generate(dossier.lastChildren(), level-1)
		
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
		addFolder(dossier, Vector2(0,0))
		generate(dossier.lastChildren(), level-1)
		
	elif level==2:
		# DOSSIER 1 (Vide)
		addFolder(dossier, Vector2(0,0))
		
		# DOSSIER 4 (Suite du chemin)
		addFolder(dossier, Vector2(0,0))
		generate(dossier.lastChildren(), level-1)
		
	elif level==1:
		pass
		# définir position départ du joueur
		#joueur.current_folder = dossier
		#joueur.position = Vecteur(0,0)
		
