extends "res://Elements/Element.gd"

class_name Folder

#extends CollisionShape2D

var children: Array


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func addChild(child : Element):
#	children.append(child)


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
