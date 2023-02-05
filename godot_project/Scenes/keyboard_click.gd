extends AudioStreamPlayer


var last_pitch = 1.0
var sounds = []

var seed_key_pitch = 342903284

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(1, 10):
		var name: String = "res://Assets/Audio/Sounds/hit_keys/hit_key" + str(i) +".wav"
		sounds.append(load(name))
	#print(sounds)
	stream = sounds[0]

func random_cos()->float:
	seed_key_pitch-=1
	return int(abs(cos(seed_key_pitch)*10000.0))/10000.0

func play(from_position=0.0):
	
	stream = sounds[seed_key_pitch % sounds.size()]
	pitch_scale = lerp(0.9,1.3, random_cos())
	while abs(pitch_scale - last_pitch) < 0.1:
		seed_key_pitch-=1
		pitch_scale = lerp(0.9,1.3, random_cos() )
	.play(from_position)

func _process(deltat):
	seed_key_pitch-=3
	if seed_key_pitch<=0:
		seed_key_pitch=342903284
