extends CanvasLayer

var heart1 : Sprite2D
var heart2 : Sprite2D
var heart3 : Sprite2D


func _ready() -> void:
	heart1 = get_node("GridContainer3/GridContainer/GridContainer/Heart1")
	heart2 = get_node("GridContainer3/GridContainer/GridContainer/Heart2")
	heart3 = get_node("GridContainer3/GridContainer/GridContainer/Heart3")
	
	heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	
	GameManager.change_player_life.connect(_on_life_change)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack"):
		GameManager.player_life -= 1


func _on_life_change(life: int) -> void:
	match life:
		6:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
		5:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
		4:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		3:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		2:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		1:
			heart1.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		0:
			heart1.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
