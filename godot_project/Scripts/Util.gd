extends Node


func str_to_int(str_: String) -> int:
	var res: int = 0
	for c in str_:
		res += ord(c)
	res % 49
	res * len(str_)
	return res


func randint(min_: int, max_: int) -> int:
	var randfloat = Singleton.noise.get_noise_2d(min_, max_)
	return int(randfloat * max_ + 1)

