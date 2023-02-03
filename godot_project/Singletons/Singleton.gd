extends Node2D


var console_width: float = 20 #(percentage)
var console_color: Color = Color(0, 0, 0)
var console_font: DynamicFont


var COLORS = {
	"RED": Color(1, 0, 0),
	"GREEN": Color(0, 1, 0),
	"YELLOW": Color(1, 1, 0)
}


func _ready():
	console_font = DynamicFont.new()
	console_font.font_data = load("res://Fonts/Calculator.ttf")
	console_font.size = 20
	print(console_font.size)
