extends Node


func str_to_int(str_: String) -> int:
	var res: int = 0
	for c in str_:
		res += ord(c)
	res % 49
	res * len(str_)
	return res


func randint(min_: int, max_: int) -> int:
	var noise = OpenSimplexNoise.new()
	noise.seed = str_to_int(Globals.seed_)
	noise.octaves = 5
	noise.period = 0.5
	noise.persistence = 0.8
	var randfloat = noise.get_noise_1d(1)
	return int(randfloat * max_ + 1)

