extends CanvasLayer

var heart1: Sprite2D
var heart2: Sprite2D
var heart3: Sprite2D
var heart4: Sprite2D
var heart5: Sprite2D
var coins_label: Label


func _ready() -> void:
	heart1 = get_node("GridContainer3/GridContainer/GridContainer/Heart1")
	heart2 = get_node("GridContainer3/GridContainer/GridContainer/Heart2")
	heart3 = get_node("GridContainer3/GridContainer/GridContainer/Heart3")
	heart4 = get_node("GridContainer3/GridContainer/GridContainer/Heart4")
	heart5 = get_node("GridContainer3/GridContainer/GridContainer/Heart5")
	
	coins_label = get_node("Coins")
	coins_label.text = "000"
	
	heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
	heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
	heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
	
	GameManager.change_player_life.connect(_on_life_change)
	GameManager.change_coins.connect(_on_coin_change)


func _on_life_change(life: int) -> void:
	match life:
		10:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
		9:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
		8:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		7:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		6:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		5:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		4:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		3:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		2:
			heart1.texture = load("res://Assets/BrianSprites/UI/Corazon full.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		1:
			heart1.texture = load("res://Assets/BrianSprites/UI/medio corazon.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
		0:
			heart1.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart2.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart3.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart4.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
			heart5.texture = load("res://Assets/BrianSprites/UI/corazonvacio.png")
	
	if life <= 0:
		GameManager.game_over()


func _on_coin_change(coins: int) -> void:
	if coins < 10:
		coins_label.text = "00" + str(coins)
	elif coins < 99:
		coins_label.text = "0" + str(coins)
	else:
		coins_label.text = str(coins)
