extends CharacterBody2D

var vida = 10
func _ready() -> void:
	add_to_group("enemy")


func Golpe():
	print("h")
	vida -= 1
	if vida == 0:
		Morir()

func Morir():
	queue_free()
