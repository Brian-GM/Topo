extends CanvasLayer

var heart1: Sprite2D
var heart2: Sprite2D
var heart3: Sprite2D
var coins_label: Label


func _ready() -> void:
	heart1 = get_node("GridContainer3/GridContainer/GridContainer/Heart1")
	heart2 = get_node("GridContainer3/GridContainer/GridContainer/Heart2")
	heart3 = get_node("GridContainer3/GridContainer/GridContainer/Heart3")
	
	coins_label = get_node("Coins")
	coins_label.text = "000"
	
	heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	
	GameManager.change_player_life.connect(_on_life_change)
	GameManager.change_coins.connect(_on_coin_change)


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
	
	if life <= 0:
		GameManager.game_over()


func _on_coin_change(coins: int) -> void:
	if coins > 0:
		coins_label.text = "00" + str(coins)
	elif coins > 9:
		coins_label.text = "0" + str(coins)
	else:
		coins_label.text = str(coins)
